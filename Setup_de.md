<H2>Installieren und Updaten der Robotan Firmware</H2>
English version can be found <A HREF="Setup.md">here</A>.
<BR><BR>
Die Prozeduren für das Installieren und Updaten der Robotan Firmware unterscheiden
sich leicht, aber sobald einmal eine Robotan Firmware installiert ist, kann man
immer die browserbasierte Update-Funktion verwenden, die weiter unten beschrieben 
wird.

<H3>Erstmalige Installation der Firmware</H3>

Wenn Du die Robotan Firmware auf einem neuen Wemos D1 Mini installieren möchtest,
auf dem bisher noch keine Robotan Firmware installiert wurde, musst Du die folgenden
Schrite durchführen:

1. Herunterladen und Installieren der Arduino IDE sowie des ESP8266 Cores wie <A HREF="https://github.com/esp8266/Arduino#installing-with-boards-manager">hier</A> beschrieben.

2. In der Arduino IDE müssen die folgenden Parameter im "Werkzeuge" Menü eingestellt
werden:
<IMG SRC="img/ArduinoSettings.png">

3. Verbinde den Wemos D1 über USB mit Deinem Computer ABER OHNE DAS ROBOTAN BOARD und flashe den Sketch
<A HREF="RobotanSetup.ino">RobotanSetup.ino</A>.  
In dieser Datei können vorher noch bei Bedarf individuelle Zugangsdaten für das 
WLAN (Variablen WLAN_local_SSID und WLAN_local_password) sowie für den Zugang 
zum Webinterface (Variablen http_username und http_password) konfiguriert 
werden. Diese werden dann im  Modul gespeichert und anstatt der später 
beschriebenen Standardwerte verwendet.

4. Danach ist eine minimale Browser-Upload Firmware auf dem Wemos D1 installiert 
und Du kannst mit dem Update-Prozess wie folgt fortfahren.

<H3>Updaten der Firmware über den Webbrowser</H3>

Das Updaten der Firmware funktioniert nur, wenn vorher eine Robotan Firmware
oder die RobotanSetup.ino installiert war! Wenn das nicht der Fall ist,
gehe bitte zurück zum Anfang dieser Seite und installiere zuerst die 
RobotanSetup.ino. Ansonsten folge diesen Schritten:

1. Lade die aktuelle <A HREF="Robotan.ino.bin">Robotan.ino.bin</A> herunter und
speichere sie auf Deinem Computer.

2. Verbinde Dich mit dem WLAN-Netzwerk des Roboters. Der Standardname des 
WLANs lautet <code>Robotan</code> und das Passwort <code>Robotan88</code>.
Wenn Du Robotan so konfiguriert hast, dass er Teil Deines WLAN-Netzwerks ist,
musst Du natürlich mit diesem Netzwerk verbunden sein.

3. Öffne die folgende URL, wenn Du das Standard-WLAN von Robotan verwendest,
andernfalls ersetze die IP-Nummer mit der IP, die Robotan in Deinem WLAN 
verwendet:  
`http://192.168.4.1:8080/update`  
Wenn Du nach Zugangsdaten gefragt wirst, lautet der Benutzername <code>Robotan</code> und das Passwort <code>Robotan88</code>, es sei denn Du hast bei der Installation Deine eigenen Werte angegeben.

4. Wähle im Browser-Upload die Robotan.ino.bin aus, die Du vorher heruntergeladen
hast und klicke auf "Update".

5. Wenn der Upload erfolgreich war, wird Robotan neu starten und nach einer 
kurzen Weile solltest Du das Robotan Webinterface unter 
`http://192.168.4.1` aufrufen können. Wenn Du Robotan so konfiguriert
hast, dass er Teil Deines WLANs ist, bleiben diese Einstellungen auch nach einem
Update erhalten, so dass Du das Webinterface über die IP-Adresse aufrufen kannst,
die Robotan in Deinem WLAN bekommen hat.<BR>
Wenn Du nach Zugangsdaten gefragt wirst, lautet der Benutzername <code>Robotan</code>
und das Passwort <code>Robotan88</code>, falls Du keine eigenen Werte bei der Installation angegeben hast..
<BR><BR>
<B>Bitte beachte: Jedes Mal, wenn das Robotan Board in Deinem Mähroboter
eingesteckt wird, fragt der Mäher nach einem PIN Passwort!</B> <BR>
Das ist die PIN, die bei Installation des Mähers im Setup eingegeben wurde und 
ist standardmäßig 0000.<BR>
<B>Ohne die Eingabe der PIN kann der Roboter nicht gesteuert werden!</B> <BR>
Falls die PIN nicht schnell genug nach dem Start eingegeben wurde, muss der Roboter
noch einmal aus- und wieder angeschaltet werden, um beim Hochfahren den neuen
Status zu erkennen. eine erneute PIN-Eingabe ist dann i.d.R. nicht mehr nötig.
<H3>Fertig :-)!</H3>
