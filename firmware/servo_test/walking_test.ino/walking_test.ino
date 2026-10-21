#include <Wire.h>
#include <PCA9685.h>

PCA9685 pwm = PCA9685(0x40);

const int TICK_MIN = 200;     // 安全のための下限（約814µs）
const int TICK_MAX = 550;     // 安全のための上限（約2240µs）
const int STEP = 2;           // 1回に動かすティック数
const int STEP_MS = 15;       // 動かす間隔（ms）

int current[16];              // 各チャンネルの現在値（0は未設定）

void moveTo(int ch, int target) {
  target = constrain(target, TICK_MIN, TICK_MAX);
  if (current[ch] == 0) {     // 最初の1回だけは直接指定
    pwm.setPWM(ch, 0, target);
    current[ch] = target;
    return;
  }
  int now = current[ch];
  while (now != target) {
    if (now < target) now = min(now + STEP, target);
    else now = max(now - STEP, target);
    pwm.setPWM(ch, 0, now);
    delay(STEP_MS);
  }
  current[ch] = target;
}

//初期位置&起動位置
void reset(){
  moveTo(0, 420);
  moveTo(1, 220);
  moveTo(2, 410);
  moveTo(3, 550);
  moveTo(12, 410);
  moveTo(13, 230);
  moveTo(14, 410);
  moveTo(15, 550);
}

//スリープ位置
void Sleep(){
  moveTo(0, 420);
  moveTo(1, 450);
  moveTo(2, 410);
  moveTo(3, 330);
  moveTo(12, 410);
  moveTo(13, 440);
  moveTo(14, 410);
  moveTo(15, 330);
}

void setup() {
  Serial.begin(115200);
  pwm.begin();
  pwm.setPWMFreq(60);
  Serial.println("使い方: 「チャンネル ティック数」を送信（例: 0 375）");
  Serial.println("最初は必ず中心（375）から。範囲は200〜550に制限しています。");
  Sleep();
  delay(5000);
  reset();
  delay(5000);
}

void loop() {
  
}