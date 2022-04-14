<#
    .SYNOPSIS
    Install custom ShareX 
    
    .NOTES
    Author: Gal A.
#>

#Check ShareX installation

$Check = $null
$Check = Select-String -Path "$env:PUBLIC\installed.log" -Pattern was -Quiet -SimpleMatch
clear

if($Check){
Write-Host "SharX обнаружена повторная установка." -ForegroundColor Red
Get-Content $env:PUBLIC\installed.log
Exit
}

$ShareX = (Get-CimInstance -Class Win32_Product | Where-Object Name -eq "ShareX")
#install
if (!$ShareX){
    #delete old configs
    Get-ChildItem -Include *.json, *.bak, *.temp -Path C:\ProgramData\ShareX -Recurse | ForEach-Object  { $_.Delete()}
  
    #Create new folder temp
    New-Item -ItemType Directory -Force -Path $env:PUBLIC\temp
    
    #Copy instalation files in temp
    Copy-Item -Path \\$env:userdnsdomain\SYSVOL\global\soft\ShareX -Destination $env:PUBLIC\temp\ -Recurse -Force
    clear

    #Set local path
    Set-Location $env:PUBLIC\temp\ShareX
    clear

    #run setup as admin
    powershell -command "Start-Process cmd -ArgumentList '/c cd /d %CD% && install.bat' -Verb runas"
    
    #Copy new configs
    Copy-Item $env:PUBLIC\temp\ShareX\conf\*  C:\ProgramData\ShareX\ -Force
    clear

    #add log file
    New-Item -Path $env:PUBLIC -Name "installed.log" -ItemType "file"  -Force
    Add-Content -Path $env:PUBLIC\installed.log -Value "$(Get-Date) - SheraX was installed."
    Get-Content $env:PUBLIC\installed.log
}
#update
else {
    #Stop ShareX
    Stop-Process -Name ShareX

    #delete old configs
    Get-ChildItem -Include *.json, *.bak, *.temp -Path C:\ProgramData\ShareX -Recurse | ForEach-Object  { $_.Delete()}
  
    #Create new folder temp
    New-Item -ItemType Directory -Force -Path $env:PUBLIC\temp
    
    #Copy instalation files in temp
    Copy-Item -Path \\$env:userdnsdomain\SYSVOL\global\soft\ShareX -Destination $env:PUBLIC\temp\ -Recurse -Force
    clear

    #Set local path
    Set-Location $env:PUBLIC\temp\ShareX
    clear

    #run setup as admin
    powershell -command "Start-Process cmd -ArgumentList '/c cd /d %CD% && install.bat' -Verb runas"
    
    #Copy new configs
    Copy-Item $env:PUBLIC\temp\ShareX\conf\*  C:\ProgramData\ShareX\ -Force
    clear

    #add log file
    New-Item -Path $env:PUBLIC -Name "installed.log" -ItemType "file"  -Force
    Add-Content -Path $env:PUBLIC\installed.log -Value "$(Get-Date) - SheraX conf was updated."
    Get-Content $env:PUBLIC\installed.log
}

# SIG # Begin signature block
# MIIFqgYJKoZIhvcNAQcCoIIFmzCCBZcCAQExCzAJBgUrDgMCGgUAMGkGCisGAQQB
# gjcCAQSgWzBZMDQGCisGAQQBgjcCAR4wJgIDAQAABBAfzDtgWUsITrck0sYpfvNR
# AgEAAgEAAgEAAgEAAgEAMCEwCQYFKw4DAhoFAAQU3FVIWR5sAoRv3DiCGYfMtHdQ
# hjugggM/MIIDOzCCAiOgAwIBAgIQVK6K/vRZZKdBj7vE56hnfzANBgkqhkiG9w0B
# AQsFADAgMR4wHAYDVQQDDBVDZXJ0IGZvciBDb2RlIFNpZ25pbmcwHhcNMjIwMzI0
# MTMyMTI0WhcNMjMwMzI0MTM0MTI0WjAgMR4wHAYDVQQDDBVDZXJ0IGZvciBDb2Rl
# IFNpZ25pbmcwggEiMA0GCSqGSIb3DQEBAQUAA4IBDwAwggEKAoIBAQDbV0PbbP9X
# I+r/30EBZRRDPrroFOrI2EPBNdnLERPvCtgDiLb+BkkLp45DFMm4RL+pRWWm7Mcl
# E9ucf4qjdEaWlak+52imX01LmeVuOP54+FK2WV795LbjTVAvB/uMX+b182w75/JH
# 2ye8qt277dZZKqbgxO7M3WcSWq6ehYXQjFO/G009lgrS50McTwoJ3bfi3+EzGkbh
# 5T0jX2mtlWKotSvh1hYVywOW59LdTqv3ir8YPPEWwG1kh11fchD40D8WK5skDQAQ
# rG4h1A/AEv64NnTe8HOVr0oEJJUz1zee+e+lQbqjgJquj36LVtcodu70ErKZptSX
# 52+0iY1CDE19AgMBAAGjcTBvMA4GA1UdDwEB/wQEAwIHgDATBgNVHSUEDDAKBggr
# BgEFBQcDAzApBgNVHREEIjAggh5DTj1TUEItV1MtMjQ1Lmdsb2JhbC5zbGV0YXQu
# cnUwHQYDVR0OBBYEFBf6bs+/1DWzlj4eC+vGxmfSgnQ+MA0GCSqGSIb3DQEBCwUA
# A4IBAQDQ3aJHfII8Q2BAhVnQYQyFtk598r1QxuZM93pX8D81EBMIxAua8jR4nTaG
# MioeEPej5LsYmCHiUsXDyxOrqiN+8Qk5bu882/vD69+GNNdXt8S0oqm8BxhmGNjG
# bmnbeBrvCtRrVerIhUXzfVXSEcgN+taiRE2BJ6+cYqOjWwTdGz5VRL9cQ4EUO71a
# Dkno+cf/2tjXB9pNphNv+Md7GRCUHs8jpqx5a/t821S8XrDJ14ajBfIF/Y1yBw+P
# 9mEylYteC0/gyNawHrXAM0RYKPPbLaHhCOTNoSxNVTayzM8NuKPjZluJdAbna6dm
# 0cJzfqBWIk8A1b0vDFakRf5HykqSMYIB1TCCAdECAQEwNDAgMR4wHAYDVQQDDBVD
# ZXJ0IGZvciBDb2RlIFNpZ25pbmcCEFSuiv70WWSnQY+7xOeoZ38wCQYFKw4DAhoF
# AKB4MBgGCisGAQQBgjcCAQwxCjAIoAKAAKECgAAwGQYJKoZIhvcNAQkDMQwGCisG
# AQQBgjcCAQQwHAYKKwYBBAGCNwIBCzEOMAwGCisGAQQBgjcCARUwIwYJKoZIhvcN
# AQkEMRYEFMkUo0UKeL4a5q9eHCxFq1bRpUIsMA0GCSqGSIb3DQEBAQUABIIBAFcc
# N4/0duZF7InorTtSFi+KQc0z40X7NG4G3m/wbs3/U27jMlR27v5PuogeD6lk5BfK
# kqvh/hVaxwXvHvGvepTAJCjz5nISs0f+27PgXndG192Pru27EiM2TDf061yM5Q+e
# 59D/SyPVe8Yj5uhfxeTY/BeIhDnS/9dvAGuOzkRjau63e9anaFInEWH00MNEgccv
# wHxIN1otiBLNWSSUMbixTwgAUTI+XL4G0N+sJAiBXdNDxggk7L6iG82r4gPKn+m9
# pMkex6sWVjKtpx6K6FrHPRBGvBSM2/zWfh32ZiRxAXgRhKh9/0A1a7X9Xz2LChTW
# M5RCLBToAgf0WulCtZI=
# SIG # End signature block
