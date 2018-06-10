<H2>Frequently Asked Questions (FAQ)</H2>
English version can be found here <A HREF="FAQ_de.md">here</A>.
<H3>Wo kann ich Hilfe bekommen?</H3>
Das folgende Forum ist momentan der Platz, um die Entwicklung von Robotan und
(begrenzter) Support kann dort gegeben werden:<BR>
  http://www.roboter-forum.com/showthread.php?24443-WLAN-Steuerung-f%FCr-Ambrogio-L30-und-baugleiche-Modelle-(Stiga-Wiper-Wolf)
<H3>Ich versuche mich, mit dem "Robotan" WLAN zu verbinden, wie lautet das
Passwort?</H3>
  <code>Robotan88</code>
<H3>Ich möchte die Robotan webseite aufrufen, wie lauten die Zugangsdaten?</H3>
  Username: <code>Robotan</code>  <BR>
Password: <code>Robotan88</code>
<H3>Kann ich mit Robotan die Firmware meines Mähers updaten?</H3>
Nein, leider nicht. Aber mit dem Anschluss eines Bluetooth-Moduls 
(HC-05 oder HC-06, weniger als 10 Euro), kann Robotan als Bluetooth-Gerät
agieren, das von Android-Geräten erkannt wird, von dem aus man dann mit der
entsprechenden App ein Update ausführen kann.<BR>
Bitte beachte, dass dies leider nicht mit iOS-Geräten funktioniert, weil
Apple es erfordert, dass alle Bluetooth-Geräte vorher lizenziert werden. 
Und das ist bei diesen Standard-Modulen nicht der Fall.
<H3>Wie muss ich das Bluetooth-Modul konfigurieren?<H3>
Das Modul muss auf 38400bps, 8 Datenbits, 1 Stoppbit und keine Parität 
konfiguriert werden. Der Bluetooth PIN-Code muss auf 0000 gesetzt sein.<BR>
Wenn Du das Modul installierst und die RobotanBT.ino auf dem Wemos D1 
aufspielst, sollte das Modul richtig konfiguriert werden.<BR>
Bitte beachte, dass das Bluetooth-Modul im Programmiermodus sein muss. Dafür
muss man je nach Modul entweder beim Einschalten einen Microschalter drücken
oder zwei Pins kurzschließen. Genauere Infos dazu stehen in der Anleitung zu
dem jeweiligen Modul.
<H3>Warum ist der Sourcecode für Robotan nicht verfügbar?</H3>
Wie Du bei meinen anderen Projekten sehen kannst, bin ich ein Unterstützer
der Open Source Philsophie. Für dieses Projekt musste ich aber herausfinden,
wie die App und der Roboter miteinander kommunizieren. Das ist legal
(zumindest hier in Deutschland), aber es ist möglicherweise nicht legal der Welt
zu erzählen, wie dieses Protokoll im Detail aussieht, Und das wäre der Fall, wenn
ich den Sourcecode öffentlich machen würde, weil jede/r, der/die sich den Code 
mit etwas Programmierkenntnis ansehen würde, diese Information in kürzester
Zeit bekommen würde.  
Und da ich der Typ Mensch bin, die lieber auf Nummer sicher gehen, kann das 
Kernprogramm der Robotan Software nur als Binär-Image heruntergeladen werden.


