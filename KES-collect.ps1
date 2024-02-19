$cred=Get-Credential

$list= ((Import-Csv -Path $env:HOMEPATH\Documents\KES\hosts.csv).Name)

Invoke-Command -ComputerName $list -Credential $cred -ScriptBlock {
                                                        Get-WmiObject -Class Win32_Product | where -Property Name -like "*Kaspersky*" | select Name, Version | sort PSComputerName 
                                                        } | Export-Csv -Path $env:HOMEPATH\Documents\KES\hosts-out.csv -NoTypeInformation -Encoding UTF8

