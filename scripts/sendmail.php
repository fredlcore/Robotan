// Uses PEAR's Mail class - usually part of a standard PHP installation, otherwise get it from here:
// https://pear.php.net/package/Mail

<?php
require_once "Mail.php";

$from = 'your@e-mail.de'		// CHANGE THIS!; 
$to = 'your@e-mail.de'; 		// CHANGE THIS!
$subject = 'Robotan ' . htmlspecialchars($_GET["error"]); 
$body = $subject;

$headers = array(
    'From' => $from,
    'To' => $to,
    'Subject' => $subject
);

$smtp = Mail::factory('smtp', array(
        'host' => 'smtp-server.de',	// CHANGE THIS!
        'port' => '587',		// You might have to change this
        'auth' => true,			// You might have to change this
	'SMTPAuth' => 'tls',		// You might have to change this
        'username' => 'Username', 	// CHANGE THIS!
        'password' => 'Passwort' 	// CHANGE THIS!
    ));
$mail = $smtp->send($to, $headers, $body);

// Send the mail
print "Sending mail...<BR>\n";
$mail = $smtp->send($to, $headers, $body);
print "Return value: $mail<BR>\nDone.\n";
?>
