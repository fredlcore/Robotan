<H2>Robotan konfigurieren</H2>
English version can be found <A HREF="Configuration_de.md">here</A>.
<BR><BR>
Momentan gibt es zwei Optionen, die man für die Verwendung von Robotan konfigurieren
kann: Die WLAN-Einstellungen und die Push-Benachrichtigungen.
<BR>
Um diese Optionen zu konfigurieren, ruft man folgende Adresse auf:
  <code>http://192.168.4.1/config</code>
<BR>
Wenn Du nach Zugangsdaten gefragt wirst, gib <code>Robotan</code> als Benutzernmane
und <code>Robotan88</code> als Passwort ein. Falls Robotan bereits mit Deinem
WLAN-Netzwerk verbunden ist, musst Du die entsprechende IP-Adresse verwenden,
die Robotan zugewiesen wurde, oder den Hostnamen <code>robotan</code> statt
der IP-Adresse probieren.<BR>
Wenn Du die Konfigurationsseite aufgerufen hast, finden sich die Optionen 
unterhalb der Statusmeldungen.
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
ist.

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
Bitte beachte, dass es nur möglich ist, einfache http-Aufrufe durchzuführen - 
verschlüsselte https-Aufrufe werden nicht unterstützt! Du kannst aber eine http 
URL in Deinem lokalen Netzwerk aufrufen, die dann von dort aus einen 
entsprechenden https-Aufruf erzeugt.

<H4>Beispiel: Benachrichtigung über  Prowl</H4>

<A HREF="http://www.prowlapp.com">Prowl</A> ist eine Benachrichtigungs App für
iPhone und iPad. Nachdem Du Dich dort registriert hast, kannst Du dort einen API
Schlüssel erzeigen, über den Du Benachrichtigungen an Dein Handy schicken kannst.
Die URL für Robotan würde folgendermaßen aussehen:<BR>
<code>http://api.prowlapp.com/publicapi/add?apikey=INSERT YOUR API KEY HERE&application=Robotan&event=</code>
<BR>
Beachte hierbei das Ende der URL: Der letzte Parameter ist "event=", woran 
Robotan den Benachrichtigungsgrund anhängen wird, so dass die endgülgtige URL
z.B. auf "event=Lift Error" enden könnte.

<H4>Beispiel: E-Mail Versand über ein PHP Script</H4>

Du kannst das <A HREF="scripts/sendmail.php">sendmail.php script</A> auf Deinen
eigenen Server herunterladen und es so konfigurieren, dass es eine E-Mail über
einen E-Mail Server Deiner Wahl verschickt. Das Script erwartet den Parameter
"error" über einen HTTP GET-Aufruf, z.B.
  <code>http://this-is-my-server.com/sendmail.php?error=Error-Message</code>
<BR>
Bitte überprüfe, dass das Script fehlerfrei läuft, bevor Du es in Robotan 
einbindest, indem Du es vom Browser aus aufrufst. Wenn Du eine E-Mail von dem
Script erhälst, kannst Du die URL in der Robotan Konfiguration wie folgt 
einbinden:
<BR>
  <code>http://this-is-my-server.com/sendmail.php?error=</code>
<BR>
Dann klicke auf "Set URL" und Robotan wird jedes Mal, wenn ein Fehler auftritt,
eine Benachrichtigung versenden.
