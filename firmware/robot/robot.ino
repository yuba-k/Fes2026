#include <SPI.h>
#include <WiFiNINA.h>
#include <WiFiUdp.h>
#include "config.h"

const char SSID[] = WIFI_SSID;
const char PASS[] = WIFI_PASSWORD;
const unsigned int UDP_PORT = 8888;
const unsigned long TIMEOUT_MS = 500;
const unsigned long STATUS_MS = 200;

WiFiUDP udp;
IPAddress peerIp;
unsigned int peerPort = 0;
bool havePeer = false;

int mode = 0, vx = 0, wz = 0;
unsigned long lastRx = 0, lastStatus = 0;
bool timedOut = true;

void setup() {
  Serial.begin(115200);
  delay(1500);
  if (WiFi.status() == WL_NO_MODULE) {
    Serial.println("Wi-Fiモジュールが見つかりません");
    while (true);
  }
  if (WiFi.beginAP(SSID, PASS) != WL_AP_LISTENING) {
    Serial.println("APの起動に失敗しました");
    while (true);
  }
  delay(5000);                              // APが安定するまで待つ
  udp.begin(UDP_PORT);
  Serial.print("AP起動: ");
  Serial.print(SSID);
  Serial.print("  IP: ");
  Serial.println(WiFi.localIP());           // ← この値をパネルの接続先にする
}

void loop() {
  // 受信
  if (udp.parsePacket() > 0) {
    char buf[48];
    int len = udp.read(buf, sizeof(buf) - 1);
    if (len > 0) {
      buf[len] = '\0';
      int m, v, w;
      if (sscanf(buf, "C,%d,%d,%d", &m, &v, &w) == 3) {
        if (timedOut) Serial.println("受信再開");
        if (m != mode || v != vx || w != wz) {
          Serial.print("受信: mode=");
          Serial.print(m);
          Serial.print(" vx=");
          Serial.print(v);
          Serial.print(" wz=");
          Serial.println(w);
        }
        mode = m; vx = v; wz = w;
        lastRx = millis();
        timedOut = false;
        peerIp = udp.remoteIP();
        peerPort = udp.remotePort();
        havePeer = true;
      }
    }
  }

  // タイムアウト（500ms受信がなければ停止）
  if (!timedOut && millis() - lastRx > TIMEOUT_MS) {
    timedOut = true;
    vx = 0;
    wz = 0;
    Serial.println("タイムアウト: 停止 (vx=0 wz=0)");
  }

  // 状態通知（電池は、今はダミーの4800mV）
  if (havePeer && millis() - lastStatus >= STATUS_MS) {
    lastStatus = millis();
    udp.beginPacket(peerIp, peerPort);
    udp.print("S,");
    udp.print(mode);
    udp.print(",4800\n");
    udp.endPacket();
  }
}