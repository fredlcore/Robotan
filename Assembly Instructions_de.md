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
<LI>1 x 220µF Kondensator
<LI>2 x 8 Pin Steckerleiste
<LI>2 x 8 Pin Buchsenleiste
  </UL>
Außer dem Wemos D1 Mini finden sich alle Bauteile in dieser Liste bei <A HREF="https://www.reichelt.de/my/1409494">Reichelt</A>.

Dann wie folgt vorgehen:
<BR>

1. Die zwei 8 Pin Buchsenleisten auf den Wemos D1 mini löten und die zwei 8 Pin Steckerleisten auf das Robotan Board.

2. Dann den MAX 3232 CPE auf das Board löten.

3. Dann die fünf 0.1µF Kondensatoren an den markierten Stellen auf das Board löten.

4. Dann den 220µF Kondensator zwischen 5V und G(ND) auf das Board löten, dabei unbedingt die Polarität beachten! Den Kondensator dann zur Seite hin herunterbiegen (siehe Foto unten).

5. Dann den seriellen Stecker auf das Board löten. Ggf. muss man die zwei angrenzenden Kondensatoren etwas biegen.

6. Dann das Robotan Board auf den Wemos D1 Mini stecken. Dabei muss der serielle Stecker auf der selben Seite sein, wie der Micro-USB-Anschluss des Wemos D1 Mini.

7. Wenn die Firmware per USB geflasht werden muss (was in der Regel nur bei der allerersten Installation der Fall ist), muss dafür das Board wieder vom Wemos gelöst werden. Bei allen Flash-Vorgängen über die Weboberfläche ist das nicht nötig.

<H3>Fertig :-)!</H3>
<IMG SRC="img/Robotan-Board-Final.jpg">
