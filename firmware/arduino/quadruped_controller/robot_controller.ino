#include "wifi_service.h"

WifiService wifi;

void setup(){
    Serial.begin(115200);

    wifi.begin();
}

void loop(){
    
}