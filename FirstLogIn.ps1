#Author: a.gal86@ya.ru
#Firsr Logon Script

#Get permission
# Create new rule
$Rule = New-Object Security.AccessControl.FileSystemAccessRule("$env:UserDomain\$env:UserName", "FullControl", "ContainerInherit, ObjectInherit", "None", "Allow") 
$Folders = Get-Item C:\Users\user

#Applying new rule
foreach ($folder in $Folders) {
    $path = $folder.FullName
    $Acl = Get-Acl $folder
    $Acl.SetAccessRule($Rule)
    Set-Acl -Path "C:\Users\user" $Acl
}

#User
$ADUser = (Get-Item -Path Env:\USERPROFILE).Value
#Paths
$hash = [Ordered]@{ 
    'C:\Users\user\AppData\Local' = "$ADUser\AppData"; 
    'C:\Users\user\AppData\Roaming' = "$ADUser\AppData";
    'C:\Users\user\Downloads' = "$ADUser"; 
    'C:\Users\user\Desktop' = "$ADUser";
}

#Copy
foreach ($h in $hash.Keys) {
    Write-Host "${h} $($hash.Item($h))"
    Copy-Item -Path "${h}" -Destination "$($hash.Item($h))" -recurse -Force
    Write-Host "Готово" -ForegroundColor Green
    pause
}