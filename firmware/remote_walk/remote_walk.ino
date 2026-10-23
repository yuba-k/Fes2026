#include <Wire.h>
#include <PCA9685.h>

PCA9685 pwm = PCA9685(0x40);

const int TICK_MIN = 200;     // 安全のための下限（約814µs）
const int TICK_MAX = 550;     // 安全のための上限（約2240µs）

const float DT = 0.02; //呼び出し間隔[s]
const float PERIOD = 0.6; //1周期[2]
const float A_SH = 30; //肩の揺れ幅
const float H_LIFT = 50; //肘の持ち上げ
const float K_TURN = 0.7; //旋回の効き
const float AMP_RATE = 0.05; //揺れ幅の変化の上限

float phase = 0;
float ampL = 0, ampR = 0;

int vx = 0, wz = 0;
bool standing = false;
bool walking = false;

int target[16];
int cur[16];

unsigned long lastUpdate = 0;

struct Leg{
  int side; //+1:右, -1:左
  int shCh, elCh; //肩と肘のチャンネル 
  int shStand, elStand; //基本姿勢
  int elSleep;
  int shDir; //肩，前進の向き(+1 or -1)
  int elLiftDir; //肘，足先が上がる向き(+1 or -1)
  int pair;
};

Leg legs[4] = {
  {1,0,1,420,220,450,+1,+1,0},//右前
  {-1,2,3,410,550,330,-1,-1,1},//左前
  {1,12,13,410,230,440,+1,+1,1},//後ろ右
  {-1,14,15,410,550,330,-1,-1,0}//後ろ左
};

void setTarget(int ch, int tick){
  target[ch] = constrain(tick, TICK_MIN, TICK_MAX);
}

void slew(int ch, int maxStep){
  int diff = target[ch] - cur[ch];
  int step = constrain(diff, -maxStep, maxStep);
  cur[ch] += step;
  pwm.setPWM(ch, 0, cur[ch]);
}

void applyServos(int maxStep){
  for(int i = 0; i < 4; i++){
    slew(legs[i].shCh, maxStep);
    slew(legs[i].elCh, maxStep);
  }
}

void standPose(){
  for(int i = 0; i < 4; i++){
    setTarget(legs[i].shCh, legs[i].shStand);
    setTarget(legs[i].elCh, legs[i].elStand);
  }
}

void sleepPose(){
  for(int i = 0; i < 4; i++){
    setTarget(legs[i].shCh, legs[i].shStand);
    setTarget(legs[i].elCh, legs[i].elSleep);
  }
}

void legPhase(float p, float &sh, float &lift){
  float u = 0;
  if(p < 0.5){
    u = p / 0.5;
    sh = -cos(PI * u);
    lift = sin(PI * u);
  }else{
    u = (p - 0.5) / 0.5;
    sh = 1 - 2 * u;
    lift = 0;
  }
}

void gaitStep(int vx, int wz){
  float ampTargetR = constrain((vx - K_TURN * wz) / 100.0, -1, 1);
  float ampTargetL = constrain((vx + K_TURN * wz) / 100.0, -1, 1);
  ampR += constrain(ampTargetR - ampR, -AMP_RATE, AMP_RATE);
  ampL += constrain(ampTargetL - ampL, -AMP_RATE, AMP_RATE);
  phase += DT / PERIOD;
  if(phase >= 1)phase -= 1;
  for(int i = 0; i < 4; i++){
    float p = phase + 0.5 * legs[i].pair;
    float sh, lift;
    if(p >= 1)p -= 1;
    legPhase(p, sh, lift);
    float amp = (legs[i].side > 0) ? ampR : ampL;
    int shTick = lroundf(legs[i].shStand + legs[i].shDir * (A_SH * amp * sh));
    int elTick = lroundf(legs[i].elStand + legs[i].elLiftDir * (H_LIFT * fabs(amp) * lift));
    setTarget(legs[i].shCh, shTick);
    setTarget(legs[i].elCh, elTick);
  }
}

void setup() {
  Serial.begin(115200);
  pwm.begin();
  pwm.setPWMFreq(60);
  for(int i = 0; i < 4; i++){
    cur[legs[i].shCh] = legs[i].shStand;
    target[legs[i].shCh] = legs[i].shStand;
    cur[legs[i].elCh] = legs[i].elSleep;
    target[legs[i].elCh] = legs[i].elSleep;
  }
  applyServos(3);
}

void loop() {
  if (Serial.available()) {
    char c = Serial.read();
    if (c == 's') { standPose(); standing = true;  walking = false; vx = wz = 0; }
    if (c == 'z') { sleepPose(); standing = false; walking = false; vx = wz = 0; }
    if (standing) {
      if (c == 'w') { vx = 100;  wz = 0;    walking = true; }  // 前進
      if (c == 'b') { vx = -100; wz = 0;    walking = true; }  // 後退
      if (c == 'a') { vx = 0;    wz = -100; walking = true; }  // 左旋回
      if (c == 'd') { vx = 0;    wz = 100;  walking = true; }  // 右旋回
      if (c == 'x') { vx = 0;    wz = 0; }                     // 停止（立ち姿勢へ収束）
    }
  }
  if (millis() - lastUpdate >= 20) {
    lastUpdate += 20;
    if (walking) { gaitStep(vx, wz); applyServos(8); }
    else         { applyServos(3); }
  }
}
