/*
  To upload through terminal you can use: curl -F "image=@firmware.bin" robotan.local/update
*/

#include <ESP8266WiFi.h>
#include <WiFiClient.h>
#include <ESP8266WebServer.h>
#include <ESP8266HTTPUpdateServer.h>
#include <EEPROM.h>
extern "C" {
  #include "user_interface.h"
}

const char* host = "robotan";
const char* ssid = "Robotan";
const char* password = "Robotan88";

ESP8266WebServer httpServer(8080);
ESP8266HTTPUpdateServer httpUpdater;

void setup(void){

  Serial.begin(38400);
  Serial.println();

  Serial.println("Clearing EEPROM...");
  EEPROM.begin(512);
  for (int i = 0; i < 512; ++i) { 
    EEPROM.write(i, 0); 
  }
  EEPROM.commit();
  Serial.println("Done.");

  Serial.println("Setting up Firmware Upload Tool...");
  wifi_station_set_hostname((char*)"robotan");
  WiFi.softAP(ssid, password);

  httpUpdater.setup(&httpServer);
  httpServer.begin();

  Serial.printf("HTTPUpdateServer ready!\nConnect to WiFi network \"Robotan\" with password \"Robotan88\" and open http://192.168.4.1:8080/update in your browser to upload the Robotan firmware.\n", host);
}

void loop(void){
  httpServer.handleClient();
}
