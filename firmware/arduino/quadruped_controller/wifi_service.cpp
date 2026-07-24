#include "wifi_service.h"
#include "wifi_config.h"

void WifiService::begin(){
    Serial.print("Connection to Wifi");
    WiFi.begin(WIFI_SSID, WIFI_PASSWORD);

    while(WiFi.status() != WL_CONNECTED){
        delay(1000);
        Serial.print(".");
    }

    Serial.println();
    Serial.println("WiFi Connected");
    Serial.print("IP Address: ");
    Serial.println(WiFi.localIP());
}