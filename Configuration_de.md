<H2>Robotan konfigurieren</H2>
English version can be found <A HREF="Configuration.md">here</A>.
<BR><BR>
Um die Optionen von Robotan zu konfigurieren, ruft man folgende Adresse auf:
  `http://192.168.4.1/config`
<BR>
Wenn Du nach Zugangsdaten gefragt wirst, gib <code>Robotan</code> als Benutzernmane
und <code>Robotan88</code> als Passwort ein, wenn Du nicht bei der Installation Deine eigenen Zugangsdaten eingestellt hast. 
Falls Robotan bereits mit Deinem
WLAN-Netzwerk verbunden ist, musst Du die entsprechende IP-Adresse verwenden,
die Robotan zugewiesen wurde, oder den Hostnamen <code>robotan</code> statt
der IP-Adresse probieren.<BR>
<H3>WLAN-Netzwerk konfigurieren</H3>
Standardmäßig setzt Robotan sein eigenes WLAN-Netzwerk auf, das "Robotan" heißt 
und das Passwort <code>Robotan88</code> hat. Wenn Du Robotan aus Deinem eigenen
WLAN heraus erreichen möchtest, kannst Du den Namen des WLAN-Netzwerks unter
"WiFi SSID" und das WLAN-Passwort unter "WiFi Password" eingeben. Klicke dann
auf "Set WiFi" und warte einen Moment. Falls der Roboter sich nicht automatisch
mit Deinem WLAN verbindet, kannst Du den Roboter aus- und wieder anschalten.
Dann sollte er sich mit Deinem WLAN verbunden haben.
<BR><BR>
Falls Robotan sich nicht mit Deinem WLAN verbinden kann, weil z.B. das Passwort
falsch ist oder sich der Roboter außerhalb der WLAN-Reichweite befindet, wird
Robotan sein bereits erwähntes eigenes WLAN-Netzwerk "Robotan" aufspannen. Es
wird allerdings alle fünf Minuten probieren, sich wieder mit Deinem WLAN-Netzwerk
zu verbinden. Das gewährleistet, dass es sich wieder mit Deinem Netzwerk verbindet,
selbst wenn das Signal in einer entfernten Ecke Deines Gartens verloren gegangen
ist.<BR>  
Es gibt auch die Möglichkeit, dem Robotan-Modul im Konfigurationsmenü eine feste IP-Adresse, sowie Gateway-, Subnet- und DNS-Adressen zu vergeben.
<H3>Push Benachrichtigungen konfigurieren</H3>

Robotan kann Dich benachrichten, falls der Roboter einen Fehler aufweist, z.B.
wenn er sich festgefahren hat und angehoben werden muss.<BR>
Um Push-Benachrichtigungen versenden zu können, muss Robotan in Dein eigenes
WLAN eingebunden sein (s.o.). Robotan ruft im Falle eines Fehlers die URL auf,
die unter "Notify URL" angegeben ist und fügt dieser am Ende den Grund für die 
Meldung hinzu (z.B. "Lift Error" für den Fall, dass der Roboter feststeckt). 
Damit kann eine URL aufgerufen werden, die den Grund für die Meldung als Parameter
überträgt. Wenn Du nicht möchtest, dass die Fehlermeldung an das Script übertragen
wird, beende die URL einfach mit einem <code>#</code>. Der Grund für die Meldung
wird zwar weiterhin an die URL angehängt, aber das <code>#</code> sorgt dafür,
dass der Text nicht als Teil der URL interpretiert wird.<BR>
<B>Seit Mai 2020 sind nur noch Aufrufe von Seiten über https möglich!</B>

<H4>Beispiel: Benachrichtigung über Prowl (Apple iPhone/iPad)</H4>

<A HREF="http://www.prowlapp.com">Prowl</A> ist eine Benachrichtigungs App für
iPhone und iPad. Nachdem Du Dich dort registriert hast, kannst Du dort einen API
Schlüssel erzeigen, über den Du Benachrichtigungen an Dein Handy schicken kannst.
Die URL für Robotan würde folgendermaßen aussehen:<BR>
`https://api.prowlapp.com/publicapi/add?apikey=HIER DEN API SCHLÜSSEL EINTRAGEN&application=Robotan&event=`
<BR>
Beachte hierbei das Ende der URL: Der letzte Parameter ist "event=", woran 
Robotan den Benachrichtigungsgrund anhängen wird, so dass die endgülgtige URL
z.B. auf "event=Lift Error" enden könnte.


<H4>Beispiel: Benachrichtigung über SimplePush (Android)</H4>

<A HREF="http://www.simplepush.io">SimplePush</A> ist eine Benachrichtigungs App für
Android Geräte. Nachdem Du die App installiert hast, bekommst Du einen Schlüssel
angezeigt, über den Du Benachrichtigungen an Dein Handy schicken kannst.
Die URL für Robotan würde folgendermaßen aussehen:<BR>
`https://api.simplepush.io/send/HIER DEN SCHLÜSSEL EINTRAGEN/`
<BR>
Beachte hierbei das Ende der URL: Diese muss mit einem <code>/</code> hinter
dem Schlüssel enden!

<H4>Beispiel: E-Mail Versand über ein PHP Script</H4>

Du kannst das <A HREF="scripts/sendmail.php">sendmail.php script</A> auf Deinen
eigenen Server herunterladen und es so konfigurieren, dass es eine E-Mail über
einen E-Mail Server Deiner Wahl verschickt. Wichtig: Es werden nur Adressen mit `https` unterstützt!
Das Script erwartet den Parameter "error" über einen HTTP GET-Aufruf, z.B.
`https://this-is-my-server.com/sendmail.php?error=Error-Message`
<BR>
Bitte überprüfe, dass das Script fehlerfrei läuft, bevor Du es in Robotan 
einbindest, indem Du es vom Browser aus aufrufst. Wenn Du eine E-Mail von dem
Script erhälst, kannst Du die URL in der Robotan Konfiguration wie folgt 
einbinden:
<BR>
  `https://this-is-my-server.com/sendmail.php?error=`
<BR>
Dann klicke auf "Set URL" und Robotan wird jedes Mal, wenn ein Fehler auftritt,
eine Benachrichtigung versenden.

<H3>Stillstandserkennung konfigurieren (für ältere Roboter)</H3>
Wenn ein ADXL335 Beschleunigungssensor installiert ist, kann dieser hier aktiviert werden und die Stillstanderkennung bei älteren Robotern ermöglichen, die nicht auslesen können, ob ein Fehler vorliegt ("Steering only"). Falls es während des Fahrens des Roboters dennoch zu Fehlalarmen kommt, kann mit der Sensitivity-Einstellung möglicherweise eine Verbesserung erreicht werden. Höhere Werte führen zu einer größeren Toleranz, niedriegere Werte zu einer geringeren.

<H3>GPS-Funktionen konfigurieren</H3>
Im Konfigurationsmenü gibt es folgende GPS-Funktionen:
<UL>
<LI>Enable GPS Logging</LI>
Hiermit wird alle 10 Sekunden die GPS-Position in den Flash-Speicher des Robotan-
Moduls geschrieben, bis die Größe 1 MByte übersteigt (nach ca. 2 Tagen). 
Danach werden die Daten gelöscht und die Aufzeichnung beginnt von vorne. 
Es gibt die Möglichkeit, die Daten als GPX-Datei herunterzuladen und sie in einem
Dienst wie <A HREF="http://www.gpsvisualizer.com/map_input">GPS Visualizer</A> 
darstellen zu lassen.
<LI>Enable GPS Stuck Detection</LI>
Dies ist nützlich für ältere Roboter, bei denen keine Fehlermeldungen direkt 
abgerufen werden können, z.B. wenn sich der Roboter festgefahren hat.
Diese Funktion analyisert die (nie 100% genaue) GPS-Position des Roboters und 
versucht zu erkennen, ob der Roboter stillsteht oder nicht. Die "Inaccuracy"-Einstellung
kann helfen, Fehlalarme zu reduzieren, indem damit ein Radius festgelegt wird,
innerhalb dessen eine Bewegung noch als "Stillstand" gerechnet wird (3-4 Meter können hier sinnvoll sein).
Meldungen werden nur innerhalb der angegebenen Zeiten versendet. Bitte beachte,
dass diese Zeiten in der UTC-Zeitzone eingegeben werden müssen, die im Sommer
zwei Stunden hinter der Zeit in den meisten Staaten Mitteleuropas liegt.
Die Position der Basis (Garage) kann angegeben werden, um zu verhindern, dass
ein geparkter Roboter eine Warnmeldung erzeugt.  
<LI>Enable Geo-Fencing</LI>
Hier können die äußeren Koordinaten des Grundstücks angegeben werden. Wenn sich
der Roboter außerhalb dieser Koordinaten aufhält (z.B., weil er gerade gestohlen wird), dann wird eine Nachricht mit den momentanen Koordinaten versendet.
Bitte beachten: Auch hier kann es durch GPS-Ungenauigkeiten zu Fehlermeldungen kommen, wenn die Grundstückskoordinaten exakt eingegeben werden.
</UL>
<H3>GPIOs Direktzugriff</H3>
Über die URL <code>/gpio?x=y</code> können die GPIO-Pins des Wemos direkt angesprochen werden, z.B. um ein Relay-Shield anzusteuern
o.ä. Dabei ist <code>x</code> die interne Nummer des GPIO Pins und <code>y</code> entweder 0 oder 1, je nachdem, ob der Pin auf low oder high gesetzt werden soll.
