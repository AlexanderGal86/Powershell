$IP = "192.168.130.26"
$SNMP = New-Object -ComObject olePrn.OleSNMP
$SNMP.Open($IP, "public")
$model = $SNMP.Get(1.3.6.1.2.1.43.10.2.1.4.1.1)
$SNMP.Close()
Write-host "$model"

