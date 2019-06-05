<H2>Zusammenbau des Robotan Boards</H2>
English version can be found <A HREF="Assembly Instructions.md">here</A>.
<BR><BR>
Um das Robotan Board zusammenzubauen, benötigt man das 
<A HREF="schematics">unbestückte Board</A> sowie:  
<BR>
<UL>
<LI>1 x Wemos D1 Mini
<LI>1 x MAX 3232 CPE DIP 16 RS232/TTL Konverter
<LI>1 x 9-poliger serieller Stecker (männlich)
<LI>5 x 0.1µF Kondensatoren
<LI>1 x 470µF Kondensator
<LI>2 x 8 Pin Steckerleiste
<LI>2 x 8 Pin Buchsenleiste
<LI>optional: 1 x <A HREF="https://amzn.to/2ZaNa4P">HC-05 Bluetooth Modul</A> (HC-06 auch möglich)
<LI>optional: 1 x <A HREF="https://amzn.to/2JXdzQ2">u-blox NEO-6 GPS Modul</A> (oder kompatibel)
<LI>optional: 1 x <A HREF="https://amzn.to/2MoVvjT">ADXL335 Beschleunigungssensor</A> (mit analogem X/Y/Z Ausgangspins) für ältere Roboter zur Stillstandserkennung
<LI>optional: 1 x <A HREF="https://amzn.to/3184fOL">KY-003 Halleffektsensor</A> (digital, active low) für ältere Roboter zur Stillstandserkennung
<LI>optional: 1 x <A HREF="https://amzn.to/2MqvkJP">starker Magnet (N52)</A> für den Halleffektsensor
<LI>optional: 1 x Piezo Summer CPM 121 (für Alarmierung, wenn der Roboter außerhalb der zulässigen GPS-Koordinaten ist)
  </UL>
Außer dem Wemos D1 Mini und den Erweiterungsmodulen/-sensoren finden sich alle Bauteile in dieser Liste bei <A HREF="https://www.reichelt.de/my/1409494">Reichelt</A>.

Dann wie folgt vorgehen:
<BR>

1. Die zwei 8 Pin Buchsenleisten auf den Wemos D1 mini löten und die zwei 8 Pin Steckerleisten auf das Robotan Board.

2. Dann den MAX 3232 CPE auf das Board löten.

3. Dann die fünf 0.1µF Kondensatoren an den markierten Stellen auf das Board löten.

4. Dann den 470µF Kondensator zwischen 5V und G(ND) auf das Board löten, dabei unbedingt die Polarität beachten! Den Kondensator dann zur Seite hin herunterbiegen (siehe Foto unten).

5. Dann den seriellen Stecker auf das Board löten. Ggf. muss man die zwei angrenzenden Kondensatoren etwas biegen.

6. Dann das Robotan Board auf den Wemos D1 Mini stecken. Dabei muss der serielle Stecker auf der selben Seite sein, wie der Micro-USB-Anschluss des Wemos D1 Mini.

7. Wenn die Firmware per USB geflasht werden muss (was in der Regel nur bei der allerersten Installation der Fall ist), muss dafür das Board wieder vom Wemos gelöst werden. Bei allen Flash-Vorgängen über die Weboberfläche ist das nicht nötig.

8. Das optionale GPS-Modul kann wie folgt an das Robotan-Modul 
angelötet werden:  
VCC <-> 3V3  
GND <-> G    
TX <-> D7  
Den RX-Pin des GPS-Moduls nicht verbinden, da es den Boot-Prozess des Wemos D1 Mini Boards beeinflussen könnte.  
Wenn ein Piezosummer mit Pin D0 (neu, ältere Softwareversionen D2) (+) und GND (-) verbunden wird, ertönen SOS-Piepser, wenn sich der Roboter außerhalb der zulässigen GPS-Koordinaten befindet.

9. Der optionale Beschleunigungssensor ADXL335, der die Stillstandserkennung bei älteren Robotern verbessert, muss wie folgt angeschlossen werden:  
VCC <-> 3V3  
GND <-> G  
X/Y/Z (einer davon) <-> A0  
Dabei ist die Achse zu wählen, die nach Einbau des Sensors die horizontale Bewegungsachse am besten abbildet.  
Um bei älteren Robotern einen Fehlalarm bei Stillstand in der Basis zu vermeiden, kann mit dem Hall Effekt Sensor KY-003 in Kombination mit einem starken Magneten die Erkennung der Basis ermöglicht werden. Dabei muss die Verbindung wie folgt hergestellt werden:  
VCC <-> 5V  
GND <-> G  
SIG/OUT <-> D1  
Magnet und Sensor sind dann so zu platzieren, dass dazwischen ein möglichst kleiner Abstand erzielt wird (2-3 cm), möglich ist dies z.B., wenn der Sensor direkt an/unter der Bodenplattte befestigt wird und der Magnet darunter, oder an der Frontseite des Roboters und der Magnet an der Ladestation. Hier ist Ausprobieren gefragt!    

10. Das optionale Bluetooth-Modul kann eins-zu-eins an das Robotan-Modul 
angelötet werden (siehe auch Bild unten):  
5V <-> 5V  
GND <-> G    
TX <-> D4  
RX <-> D3  
Bei Modulen mit sechs Pins unbedingt darauf achten, dass nur die mittleren vier 
Pins (also 5V, GND, RX und TX) verbunden werden!  
Um das Bluetooth-Modul zu konfigurieren, bitte die entsprechende Anleitung
zu Rate ziehen oder den `RobotanBT.ino` Sketch probieren, der das Modul im 
Idealfall ebenfalls korrekt konfiguriert. Dazu muss das Modul in den Programmier-
Modus versetzt werden. Dies geschieht beim Einschalten der Stromzufuhr des
Moduls entweder durch das Kurzschließen der Pins 5V und EN oder durch Drücken 
eines Microschalters.

<H3>Fertig :-)!</H3>
Position des Kondensators:<BR>
<IMG SRC="img/Robotan-Board-Final.jpg">
<BR><BR>
Position des Bluetooth-Moduls:<BR>
<IMG SRC="img/8 - Adding Bluetooth module.jpg">

