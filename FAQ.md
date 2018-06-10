<H2>Frequently Asked Questions (FAQ)</H2>
Die deutsche Version findet man <A HREF="FAQ_de.md">hier</A>.
<H3>Where can I get support?</H3>
The following forum is currently used to discuss the development of Robotan and (limited) support can be given there as well:<BR>
  http://www.roboter-forum.com/showthread.php?24443-WLAN-Steuerung-f%FCr-Ambrogio-L30-und-baugleiche-Modelle-(Stiga-Wiper-Wolf)
<H3>I'm trying to connect to the "Robotan" WiFi network, what is the password?</H3>
  <code>Robotan88</code>
<H3>I want to access the Robotan website, what is the username and password?</H3>
  Username: <code>Robotan</code>  <BR>
Password: <code>Robotan88</code>
<H3>Can I update my robot firmware with Robotan?</H3>
No, unfortunately not. But with an added Bluetooth module (HC-05 or HC-06, less than 10 Euros), Robotan can act as a standard Bluetooth device that is discoverable by Android devices, and these can be used to update the robot's firmware.<BR>
Please take note that this will unfortunately not work with iOS devices because Apple requires all Bluetooth modules to be registered with them before they can be used. And this is not the case with readily available Bluetooth modules.
<H3>How do I need to configure the Bluetooth module?</H3>
The device speed has to be set to 38400 bps, 8 data bits, 1 stop bit, no parity. The bluetooth PIN code must be set to 0000.<BR>
If you install the module and run the provided RobotanBT.ino, it should configure the module for you. Please take note that you may have to put the module into programming mode by pressing a micro-switch or short-circuit two pins during powering up the module. Refer to the module's instructions for further details.
<H3>Why is the source code of Robotan not available?</H3>
As you can see with my other projects, I'm a supporter of open source software. However, with this project, I had to figure out how the app and the robot communicate with each other. This is legal (at least here in Germany), but it may not be legal to tell the world how this protocol works. And this would be the case if I make the source code available, because everyone (with a little bit of programming knowledge) would be able to find out in no time. And as I'm the type of guy who rather is safe than sorry, the core Robotan program can only be downloaded as bin image.


