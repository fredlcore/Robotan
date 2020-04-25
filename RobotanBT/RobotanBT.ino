#include <SoftwareSerial.h>

const uint32_t baud_rates[] = {9600, 38400, 57600, 115200};

SoftwareSerial BluetoothSerial;

void setup(void) {
  Serial.begin(38400);

  for (int x = 0; x < 4; x++) {    
    BluetoothSerial.begin(baud_rates[x], SWSERIAL_8N1, 2, 0, false, 256);
    Serial.print("\nRobotan Bluetooth module configuration starts at ");
    Serial.println(baud_rates[x]);
    BluetoothSerial.println("AT+NAME=\"Robot\"");
    delay(500);
    BluetoothSerial.println("AT+NAME=Robot");
    delay(500);
    BluetoothSerial.println("AT+NAMERobot");
    delay(500);
    BluetoothSerial.println("AT+UART=38400,0,0");
    delay(500);
    BluetoothSerial.println("AT+BAUD6");
    delay(500);
    BluetoothSerial.println("AT+PIN000000");
    delay(500);
    BluetoothSerial.println("AT+PSWD=\"0000\"");
    delay(500);
    BluetoothSerial.println("AT+PIN0000");
    delay(500);
    BluetoothSerial.println("AT+ADDR");
    delay(500);
    BluetoothSerial.println("AT+RESET");
    delay(500);
    BluetoothSerial.end();
  }
  Serial.println("\nRobotan Bluetooth module configuration finished.");

  BluetoothSerial.begin(38400);

}

void loop(void) {
  while (BluetoothSerial.available() > 0) {
    Serial.write(BluetoothSerial.read());
    yield();
  }
  while (Serial.available() > 0) {
    BluetoothSerial.write(Serial.read());
    yield();
  }

}
