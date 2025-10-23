# File containing domains
$domainFile = "domainnames.txt"
# Log file
$logFile = "sslexpirylog.txt"
# Threshold in days
$threshold = 15

# Clear previous log
Clear-Content $logFile -ErrorAction SilentlyContinue

# Read each domain
Get-Content $domainFile | ForEach-Object {
    $domain = $_.Trim()
    if ($domain -eq "") { return }

    try {
        $tcp = New-Object System.Net.Sockets.TcpClient($domain, 443)
        $sslStream = New-Object System.Net.Security.SslStream($tcp.GetStream(), $false, ({$true}))
        $sslStream.AuthenticateAsClient($domain)
        $cert = $sslStream.RemoteCertificate
        $expiryDate = [datetime]::Parse($cert.GetExpirationDateString())

        $remainingDays = ($expiryDate - (Get-Date)).Days

        if ($remainingDays -lt $threshold) {
            $message = "ALERT: $domain SSL expires in $remainingDays days ($expiryDate)"
        } else {
            $message = "$domain SSL is fine, expires in $remainingDays days"
        }
        Write-Output $message
        Add-Content $logFile $message

        $sslStream.Close()
        $tcp.Close()
    }
    catch {
        $message = "Could not retrieve SSL expiry for $domain"
        Write-Output $message
        Add-Content $logFile $message
    }
}
