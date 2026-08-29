#ifndef WIFI_SERVICE_H
#define WIFI_SERVICE_H

#include <WiFiNINA.h>
class WifiService{
    public:
        WifiService();
        void begin();
        void update();
    private:
        WiFiServer server;
        WiFiClient client;
};
#endif