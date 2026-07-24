#ifndef WIFI_SERVICE_H
#define WIFI_SERVICE_H

#include <WiFiNINA.h>
class WifiService{
    WiFiServer server;
    public:
        void begin();
};
WifiService::WifiService()
    :server(SERVER_PORT);
#endif