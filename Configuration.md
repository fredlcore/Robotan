<H2>Configuring Robotan</H2>
Die deutsche Version befindet sich <A HREF="Configuration_de.md">hier</A>.
<BR><BR>
Currently, there are two options you can configure when using Robotan: The WiFi network and the push notification. To configure these options, go to<BR>
  <code>http://192.168.4.1/config</code>
<BR>
If you are asked for a login, the username is "Robotan" and the password is "Robotan88", unless you chose your own credentials during instalation.  
If Robotan is already connected to your own WiFi network, you'll have to use the IP address assigned to Robotan or try using the 
hostname "robotan" instead of the IP number. 
<H3>Configuring WiFi network</H3>
By default, Robotan sets up its own WiFi network called "Robotan" with the password "Robotan88". If you want to access your robot from 
within your own WiFi network, you can enter the name of your WiFi network at "WiFi SSID" and your WiFi's password at "WiFi Password".  
Then click on "Set WiFi" and wait a while. If your robot does not automatically connect to your own network, you can turn off the robot and
turn it on again after a few seconds.<BR>
<BR>
If Robotan cannot connect to your WiFi network, for example because the password is wrong or because it is too far away to pick up a signal, 
Robotan will fall back to setting up its own "Robotan" network mentioned above. However, it will try every five minutes to connect again to 
your WiFi network. This will ensure it will re-connect to your network even if it lost signal in a remote section of your garden.
<BR>
You also have the option to provide the Robotan module with a fixed IP address along with gateway, subnet and dns addresses in the configuration menu.

<H3>Configuring push notifications</H3>
Robotan can notify you in case the robot reports an error, for example when it gets stuck.  
To be able to send the notifications, Robotan must use your own WiFi network (see above). Robotan will call the URL defined at "Notify URL"
and add the reason for the notification (i.e. "Lift Error") at the very end, so you can call an URL and pass the reason as a parameter. If you don't want the error to be passed on, then just end your URL with a <code>#</code>. The reason text will still be appended, but the <code>#</code> will basically make the text being ignored in the URL.<BR>
Please take note that you can only call plain http URLs, https is currently not supported! However, you can call a http URL for example on 
your local network and then make a https call from there.
<H4>Example for using Prowl (Apple iPhone/iPad)</H4>
<A HREF="http://www.prowlapp.com">Prowl</A> is a notification app for iPhone and iPad. After you register, you can create an API key which 
you can send your notifications to. The URL for Robotan would look like this:<BR>
<code>http://api.prowlapp.com/publicapi/add?apikey=INSERT YOUR API KEY HERE&application=Robotan&event=</code>
<BR>
Take note of the end of the URL: The last parameter is "event=", so Robotan will add the reason for the notification there, so that the
final URL might end like "event=Lift Error"
<H4>Example for using SimplePush (Android)</H4>
<A HREF="http://www.simplepush.io">SimplePush</A> is a notification app for Android. After you've downloaded the app, you'll get a key which 
you can send your notifications to. The URL for Robotan would look like this:<BR>
<code>http://http://api.simplepush.io/send/INSERT YOUR KEY HERE/</code>. 
The error message will then be pushed to your Android device running the 
SimplePush app. Please take note that the URL must end with a <code>/</code>
after the key!
<BR>
<H4>Example for sending an e-mail via a PHP script</H4>
You can download and install the <A HREF="scripts/sendmail.php">sendmail.php script</A> on your own server and configure it to send an
e-mail through an e-mail service of your choice. The script expects the parameter "error" to be sent via a GET request like this:<BR>
  <code>http://this-is-my-server.com/sendmail.php?error=Error-Message</code>
<BR>
Please make sure that the script runs smoothly before setting it up in Robotan by calling the script from your browser. If you receive
an e-mail from the script, you can use the URL in the Robotan configuration like this:
<BR>
  <code>http://this-is-my-server.com/sendmail.php?error=</code>
<BR>
Then click "Set URL" and Robotan will send out a notification each time an error occurs.

<H3>Configuring GPS functions</H3>
In the configuration menu, you have the following GPS-based options:  
* Enable GPS logging  
GPS logs will be saved every 10 seconds into the device's flash memory until the size exceeds 1 MByte after which it will automatically be deleted. You have the option to download the logs in GPX format to be displayed for example on sites like <A HREF="http://www.gpsvisualizer.com/map_input">GPS Visualizer</A>.
* Enable GPS stuck detection
This is useful for older robots which do not provide access to the error messages, like when the robot is stuck. This function will evaluate the (not 100% accurate) GPS position of the robot and determine whether the robot is stuck or not. The inaccuracy radius may help to prevent false positives. Alerts will only be sent during start and end time. Please note that these times are based on the UTC timezone (which is in summer two hours behind the rest of central Europe.  
The position of the base (garage) helps to prevent false positives when the robot is in the garage (and therefore looks as being 'stuck').
* Enable geo-fencing
You may provide coordinates of your garden here. Once the robot leaves these coordinates (e.g. because of theft) a message will be sent out with the current coordinates.
