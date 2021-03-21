# storyline: Send an email
# variable can have an undersore or any alphanumeric value.

#body of the email
$msg = "Hello there."

write-host -BackgroundColor Red -ForegroundColor white $msg

#Email from address
$email "alex.kelley@mymail.champlain.edu"

#to address
$toEmail "deployer@csi-web"

# sending the email
Send-MailMessage -From $email -To $toEmail -Subject "A Greeting" -Body $msg -SmtpServer 192.168
