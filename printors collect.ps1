$ErrorActionPreference= 'silentlycontinue'
$ip = ('192.168.130.26','192.168.130.30','192.168.130.31','192.168.130.35','192.168.130.38', 
'192.168.130.40','192.168.130.44','192.168.130.53','192.168.130.69','192.168.130.73','192.168.130.76',
'192.168.130.79','192.168.130.152','192.168.130.162')
$RESULT = @()

foreach ($printer in $ip) {
$SNMP = New-Object -ComObject olePrn.OleSNMP
$SNMP.open($printer,'public',2,1000)
$RESULT += $SNMP.get('.1.3.6.1.2.1.43.10.2.1.4.1.1')
$SNMP.Close() 
}
$RESULT


