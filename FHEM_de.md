<H2>Einbindung in FHEM</H2>
English version can be found <A HREF="FHEM.md">here</A>.
<BR>
<H3>Robotan-Modul in FHEM einbinden</H3>
Um Robotan in FHEM einzubinden, muss das Modul 98_Robotan.pm in das Verzeichnis <code>./opt/FHEM</code> unterhalb der FHEM-Installation
kopiert werden.<BR>
Dann erfolgt die Einbindung in FHEM mit<BR>
<code>define Ciiky Robotan:Robotan88@192.168.1.51 300</code><BR>
Damit wird das Gerät "Ciiky" angelegt, mit den Standardzugangsdaten (Benutzername Robotan, Passwort Robotan88), das auf die IP
192.168.1.51 eingestellt ist. Der Abfrageintervall wird auf 300 Sekunden festgelegt, also alle fünf Minuten.<BR>
<BR>
<H3>Modulkonfiguration</H3>
<code>Left</code>, <code>Right</code>, <code>Straight</code> - Lässt den Roboter links bzw. rechts bzw. gerade fahren.<BR>
<code>Spiral</code> - lässt den Roboter temporär in Spiralform mähen<BR>
<code>Home/Work</code> - lässt den Roboter je nach Status aus bzw. zurück in die Station fahren.<BR>
<code>Play/Pause</code> - lässt den Roboter in bzw. aus dem Pause-Modus gehen. Der Pause-Modus ist Voraussetzung, um Parameter im Roboter zu ändern, u.a. auch die Mähzeiten und -tage.<BR>
<code>Start_Time_1</code> - Beginn der ersten Mähzeit<BR>
<code>End_Time_1</code> - Ende der ersten Mähzeit<BR>
<BR>
<code>Mowing_Days</code> - Setzt direkt die Wochentage im Roboter, an denen der Rand gemäht werden soll.<BR> 
<code>General_Mowing_Days</code> - Standard-Mäh-Tage; kann kann von Funktionen verwendet werden, um z.B. nach <code>Mow_Today</code> die Standard-Einstellungen wieder herzustellen.<BR>
<code>Border_Mowing_Days</code> - Setzt direkt die Wochentage im Roboter, an denen der Rand gemäht werden soll.<BR>
<code>General_Border_Mowing_Days</code> - Standard-Randmäh-Tage; kann von Funktionen verwendet werden, um z.B. nach <code>Mow_Today</code> die Standard-Einstellungen wieder herzustellen.<BR>
<code>Mow_Today</code> - <code>1</code> fügt den heutigen Tag den Mähtagen hinzu, <code>0</code> entfernt ihn. Die übrigen Mähtage werden aus <code>General_Border_Mowing_Days</code> (also dem in FHEM hinterlegten Standard) ausgelesen, nicht aus dem Roboter direkt. 
<H3>Beispieleinbindungen</H3>
<B>Mähzeiten entsprechend des Tageslichts anpassen:</B><BR>
<pre>
define di_Ciiky_Daylight_Mowing DOIF ([01:10]) ## execute at 01:10 am
((set Ciiky Start_Time_1 {(sunrise_abs(3600, "08:15"))}), ## set start time to one hour after sunrise, but not earlier than 08:15 am
(set Ciiky End_Time_1 {(sunset_abs(-3600, "", "20:00"))})) ## set end time to one hour before sunset, but not later than 4:45pm
</pre>
<BR>
<B>Kein Mähen, wenn schlechtes Wetter vorhergesagt wird:</B><BR>
Benötigt das Modul PROPLANTA, hier am Beispiel der Postleitzahl 29439<BR>
<pre>
define Wetter PROPLANTA 29439 de
define di_No_Mow_When_Bad_Weather DOIF ([Wetter:fc0_tempMax] < 12 ## check if weather today is bad, i.e. less than 12°C or rain
or ([Wetter:fc0_rain] > 1))
(set Ciiky Mow_Today 0) ## then do not mow today
</pre>
<BR>
<B>Nachts wieder auf Standard-Mähtage zurücksetzen:</B><BR>
<pre>
define di_Ciiky_Set_Standard_Mowing_Times DOIF ([01:05]) ## execute at 01:05 am
(set Ciiky Mowing_Days {(AttrVal("Ciiky","General_Mowing_Days",""))}, ## reset mowing days with value from General_Mowing_Days
set Ciiky Border_Mowing_Days {(AttrVal("Ciiky","General_Border_Mowing_Days",""))}) ## reset border mowing days with value from General_Border_Mowing_Days
</pre>