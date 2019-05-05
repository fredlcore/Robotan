/*
  To upload through terminal you can use: curl -u Robotan:Robotan88 -F "image=@fRobotan.ino.bin" robotan.local:8080/update
  Adjust credentials in case you changed them from default.
*/

/* 
    By default this script will become an AP and spawn a new WLAN network.
    The default network name is "Robotan" and the WiFi password is "Robotan88" (without quotation marks).
   
    If you provide your WLAN local network SSID / password information, the script will first try to connect to your 
    existing local WLAN network as a client. Upon success, local WLAN credentials will be stored in the EEPROM and the robotan
    firmware will connect after flashed and restarted.Only if the local WLAN connection is unsuccessful, the script will revert to default behavior 
    
    If you decide to change the default username / password (recommended), the new values will be copied to the Wemos EEPROM 
    and be active after the robotan firmware file has been flashed and restarted. 

    Thanks to Oliver Weismantel for helpful additions!
*/ 

#define LOGIN_CREDENTIALS_LENGTH_MAX 16

/* begin configuration section */
const char WLAN_local_SSID[32] = "";       // fill in your existing local WLAN SSID
const char WLAN_local_password[63] ="";    // fill infor your existing local WLAN password

const char http_username[LOGIN_CREDENTIALS_LENGTH_MAX + 1] = "Robotan";    // HTTP username, maximum of 16 characters
const char http_password[LOGIN_CREDENTIALS_LENGTH_MAX + 1] = "Robotan88";  // HTTP password, maximum of 16 characters
/* end configuration section */

#include <ESP8266WiFi.h>
#include <WiFiClient.h>
#include <ESP8266WebServer.h>
#include <ESP8266HTTPUpdateServer.h>
#include <EEPROM.h>
extern "C" {
  #include "user_interface.h"
}

const char* host = "robotan";
const char* def_ssid = "Robotan";
const char* def_pass = "Robotan88";

int eeprom_allocated_mem = 4096;
int eeprom_login_credentials_base=512;

ESP8266WebServer httpServer(8080);
ESP8266HTTPUpdateServer httpUpdater;
WiFiClient WLAN_Client;
IPAddress local_ip;

void setup(void) {

  /* Initialize Serial Port */
  Serial.begin(38400);
  Serial.println();

  /* Clear EEPROM */
  Serial.print("Clearing EEPROM...");
  EEPROM.begin(eeprom_allocated_mem);
  for (int i = 0; i < eeprom_allocated_mem; ++i) { 
      EEPROM.write(i, 0); 
  }
  Serial.println("done");

  /* Store http username / password in EEPROM */
  EEPROM.put(eeprom_login_credentials_base, http_username);
  EEPROM.put(eeprom_login_credentials_base +  LOGIN_CREDENTIALS_LENGTH_MAX, http_password);

  Serial.println("Setting up Firmware Upload Tool...");
  
  if (!Local_WLAN_Connect()) {
    /* default behavior - spawn access point */
    WiFi.mode(WIFI_AP);  
    wifi_station_set_hostname((char*)"robotan");
    WiFi.softAP(def_ssid, def_pass);
    Serial.printf("Created WLAN access point with WLAN SSID %s\n",def_ssid);
    /* local IP */
    local_ip = WiFi.softAPIP();
    Serial.printf("\n>>> Connect to WiFi network \"%s\" with password \"%s\"\n\n",def_ssid, def_pass);
  }
  
  EEPROM.commit();
  EEPROM.end();
  
  /* Start Update Server Process */
  httpUpdater.setup(&httpServer);
  httpServer.begin();

 /* Ready */
  Serial.printf("\n>>> HTTPUpdateServer ready!\n>>> Open http://");
  Serial.print(local_ip);
  Serial.print(":8080/update in your browser to upload the Robotan firmware.\n");

  return;
}

void loop(void){
  httpServer.handleClient();
}


boolean Local_WLAN_Connect() {
  /* Try local WLAN using credentials given */
  if ( strlen(WLAN_local_SSID) && strlen(WLAN_local_password)) {
    /* Wifi client mode */
    WiFi.mode(WIFI_STA);
    
    /* connect to existing WLAN */
    Serial.printf("Connecting to local WLAN SSID %s",WLAN_local_SSID);
    WiFi.begin(WLAN_local_SSID, WLAN_local_password);

    /* Wait for connection to be successful */
    for (int i=0; i<20; i++) {  //timeout [s]
      delay(1000);  
      
      int connectionStatus = WiFi.status();
      switch(connectionStatus) {
        case WL_CONNECTED: 
          Serial.println("...connected");
          local_ip = WiFi.localIP();
          /* store WiFi credentials in EEPROM */
          EEPROM.put(0,WLAN_local_SSID);
          EEPROM.put(32,WLAN_local_password);
          return true; // WLAN connection successful
        default:
          Serial.print(".");
      }
    }
  }
  Serial.println("...unable to connect"); // revert to default behavior
  return false;
}

