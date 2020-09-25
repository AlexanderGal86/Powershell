#Author a.gal86@ya.ru
#Logon Script

$testpath = "$env:APPDATA\DontDelete"

#test
if (Test-Path -path $testpath) {
    Write-Host "Перенос файлов уже исполнялся ранее." -ForegroundColor red
    break
}

#mark
New-Item -ItemType "directory" -Path "$testpath"

#Run Script
if (Test-Path -path $testpath) {
    Write-Host "Подготовка к переносу файлов из локального пользования." -ForegroundColor green
    Start-Process powershell.exe -ArgumentList '-ExecutionPolicy Bypass -File "\\192.168.0.250\share\Админы\Scripts for AD\FirstLogIn.ps1"' -Verb RunAs -Wait
}
else {
    Write-Host "Сбой" -ForegroundColor red
    [System.Reflection.Assembly]::LoadWithPartialName("System.Windows.Forms")
    [System.Windows.Forms.MessageBox]::Show("Сбой переноса файлов")
}