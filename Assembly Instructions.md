<H2>Assembly Instructions</H2>
Die deutsche Version findet man  <A HREF="Assembly Instructions_de.md">hier</A>.  
<BR><BR>
To assemble the Robotan board, you'll need the <A HREF="schematics">plain board</A> itself plus:  
<BR>
<UL>
<LI>1 x Wemos D1 Mini
<LI>1 x MAX 3232 CPE DIP 16 RS232/TTL converter
<LI>1 x 9 pin male serial connector
<LI>5 x 0.1µF capacitators
<LI>1 x 470µF capacitator
<LI>2 x 8 pin header
<LI>2 x 8 pin socket
<LI>optionally: 1 x <A HREF="https://amzn.to/2ZaNa4P">HC-05 Bluetooth module</A> (HC-06 also works)
<LI>optionally: 1 x <A HREF="https://amzn.to/2JXdzQ2">u-blox NEO-6 GPS module</A> (or compatible)
<LI>optionally: 1 x <A HREF="https://amzn.to/2MoVvjT">ADXL335 acceleration sensor</A> (analogue, with X/Y/Z output pins) for older robots for stuck detection
<LI>optionally: 1 x <A HREF="https://amzn.to/3184fOL">KY-003</A> hall effect sensor (digital, active low) for older robots for stuck detection
<LI>optionally: 1 x <A HREF="https://amzn.to/2MqvkJP">strong magnet (N52)</A> for the hall effect sensor
<LI>optionally: 1 x Piezo buzzer CPM 121 (for alarm beeps when robot is outside GPS boundaries)
  </UL>
Except for the Wemos D1 Mini and the extension modules/sensors, you can find a list of items at <A HREF="https://www.reichelt.de/my/1409494">Reichelt</A>.  
<BR>
Some boards from a collective order are still available. Contact robotan (ät) code-it.de if you are interested (German or English).
<BR><BR>
To assemble the board, proceed as follows:
<BR>

1. Solder the MAX 3232 CPE on the board.

2. Solder the five 0.1µF capacitators on the board at the designated spots

3. Solder the 470µF capacitator on the board at the designatet spot - watch the polarity!

4. Solder the two 8 pin sockets to the Wemos D1 mini and the two 8 pin headers on the Robotan board.

5. Solder the serial connector to the board. You might have to bend the two adjacent capacitators a bit.

6. Plug the Robotan board on top of the Wemos D1 Mini. The serial connector of the Robotan board must be on the same side as the Micro USB 
connector of the Wemos D1 Mini.

7. If you need to flash the firmware via USB, you have to unplug the board and the Wemos first. This usually only applies to the first flashing process, because afterwards you can use the web-based flashing feature which is not affected by this.

8. If you want to add the u-blox GPS module, you can solder the pins like this:  
VCC <-> 3V3  
GND <-> G  
TX <-> D7  
Do not connect the RX line of the module as it is not used and might interfere with the Wemos D1 Mini board.  
If you connect the piezo buzzer to D2 (+) and GND (-), an SOS beep will turn on once the robot has left the permissible GPS coordinates.<BR><BR>
On the newer version of the board, the pins in the parallel row marked as "GPS" can be used. Opposite of D6 is a GND pin so that the GPS module can be attached 1:1. Pin D0 is additionally located at the top right of the baurd so that a buzzer can be soldered in there direclty.

9. If you want to add the  ADXL335 acceleration sensor in older robots for detecting whether the robot is stuck, connect the pins one to one like this:  
VCC <-> 3V3  
GND <-> G  
X/Y/Z (one of them) <-> A0  
Use that axis pin on the ADXL335 that best matches the horizontal movement axis of the robot. This depends on where and in which direction you have attached the sensor inside the robot. On the newer version of the board, the respective pins can be found in the parallel row named "ACC". The pins between 3V3 and GND are all connected to A0.  
To reduce or at best eliminate false alarms on older robots when the robot is back in its base, you can use a Hall Effect Sensor KY-003 in combination with a strong magnet. Connect ths pins like this:
VCC <-> 5V  
GND <-> G  
SIG/OUT <-> D1  
Magnet and sensor should be placed in a way that there is only a very small distance between them when the robot is in its base (2-3 cm), this is possible for example by placing the sensor directly on/below the ground plate of the chassis and then place the magnet on the ground below, or to place the sensor at the front of the robot and the magnet attached to the charging elements. You might have to try a bit to find the most reliable position!   

10. If you want to add the HC-05 Bluetooth module, you can solder the pins one 
to one like this, newer versions of the board have a parallel row labelled as "BLUETOOTH" which are connected the same way:  
5V <-> 5V  
GND <-> G  
TX <-> D4  
RX <-> D3  
For modules with six pins, make sure you only connect the four center ones 
(5V, GND, RX and TX)!  
To configure the HC-05, see the manual or try the `RobotanBT.ino` which should
be able to configure the Bluetooth module correctly. You have to put the module
into programming mode first by connecting the 5V and EN pins on the module 
while powering up. Better modules have a microswitch which you just need to
press alternatively.  
<H3>Done :-)!</H3>
<IMG SRC="img/Robotan-Board-Final.jpg">
