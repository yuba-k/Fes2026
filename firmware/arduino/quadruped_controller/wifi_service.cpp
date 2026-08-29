#include "wifi_service.h"
#include "wifi_config.h"

WifiService::WifiService():server(SERVER_PORT){
    ;
}

void WifiService::begin() {
    Serial.print("Connecting to Wi-Fi");

    WiFi.begin(WIFI_SSID, WIFI_PASSWORD);

    while (WiFi.status() != WL_CONNECTED) {
        delay(1000);
        Serial.print(".");
    }

    Serial.println();
    Serial.println("WiFi Connected");

    Serial.print("IP Address: ");
    Serial.println(WiFi.localIP());

    server.begin();

    Serial.print("TCP Server started on port ");
    Serial.println(SERVER_PORT);
}

void WifiService::update() {
    if (!client || !client.connected()) {
        client = server.available();

        if (client) {
            Serial.println("Client Connected");
        }
    }
}