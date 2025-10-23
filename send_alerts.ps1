param(
    [string]$service_name
)

$from = "iamsahana31@gmail.com"         
$to   = "sahanachandrashekar1997@gmail.com"      
$appPassword = "xfkprlpmvjqbiwzd" 

# SMTP configuration
$smtpServer = "smtp.gmail.com"
$smtpPort   = 587

# Create secure credential
$securePassword = ConvertTo-SecureString $appPassword -AsPlainText -Force
$credential = New-Object System.Management.Automation.PSCredential($from, $securePassword)

# Email subject and body
$subject = "ALERT: Service $service_name is down!"
$body    = "The monitored service '$service_name' is not running and requires attention.`nTime: $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')"

try {
    Send-MailMessage -From $from -To $to -Subject $subject -Body $body `
        -SmtpServer $smtpServer -Port $smtpPort -UseSsl -Credential $credential -ErrorAction Stop
    Write-Host "Alert email sent for $service_name"
} catch {
    Write-Host "Failed to send email for $service_name. Error: $($_.Exception.Message)"
}
