<#
    .SYNOPSIS
    AD entity creation Menu.

    .NOTES
    Author: Gal A. A.
    Web: 
#>
Add-type -AssemblyName System.Web
Import-Module ActiveDirectory

#Test OU
$test = 'OU=Test Account,OU=Users_HQ,OU=Accounts,OU=_globalRU,DC=global,DC=global,DC=ru'
$menu = $null
#DepartmentExmplData
$database = @(
@{Dev='Dev';HR='HR';OSA='OSA';SD='SD';JUR='JUR';MSK='MSK';OTP='OTP';OutSorcrs='OutSorcrs';Designers='Designers';DevSLT='Dev SLT'}
@{OB='OB';Visa_mail='Visa_mail';CC='CC';DKS='DKS';LZ='LZ';STA='STA';OP='OP';Aup='Aup';DKK='DKK';Marketing='Marketing'}
@{lC='1C';Buh='Buh';Finance='Finance';Payments='Payments';Dev='DevBuh';OutSorcrs='OutSorcrsBuh'}
#Service Groups
@{Service1='CI_CD'}
@{Service2='Grafana'}
@{Service3='MSSql'}
)

Clear-Host

#Select Department
do
    {Clear-Host
    $select = '0'
        Write-Host -ForegroundColor Cyan "`n`t Select domain:`n1. global.global `n2. global.int `n3. global.local `n"
        $dswitch = Read-Host [Enter Selection or login as: [$env:USERDNSDOMAIN]]
        Switch ($dswitch){
            1 {$Domain='global.global.ru'}
            2 {$Domain='global.int'}
            3 {$Domain='global.local'}
            Default {$Domain="$env:USERDNSDOMAIN"}
            }   
    Write-Host -ForegroundColor Cyan "`n`t Choice the type of entity:`n1. AD-User `n2. ServiceLogin `n3. Test Run `n0. Exit `n"
    Write-Host -ForegroundColor Green "`nDomain:[$Domain]`n"
    $menu = read-host [Enter Selection or return to domain list]
    Switch ($menu) 
        {   #AD User Group
            1  {
            Clear-Host
            Write-Host -ForegroundColor Red "Select AD Group"
            Write-Host -ForegroundColor Green "`n`t Choice the type of entity:`n1.Department Marketing `n2.Department Dev  `n3.Department Buh `n4.Department allDev(Exmpl)  `n5.Department DevBuh(Exmpl) `n"
            Write-Host -ForegroundColor Green "`nDomain:[$Domain]`n"
            $menu1 = read-host [Enter Selection or press Enter to return]
            Switch ($menu1) 
                {
                    #Department Marketing
                "1" {Clear-Host
                    $select = $database.Marketing
                    $menu = '2'
                    }
                    #Department Dev
                "2" {Clear-Host
                    $select = $database[0].Dev
                    $menu = '2'
                    }
                    #Department Buh
                "3" {Clear-Host
                    $select = $database.Buh
                    $menu = '2'
                    }
                    #Department allDev(Exmpl) 
                "4" {Clear-Host
                    $select = $database.Dev
                    $menu = '2'
                    }
                    #Department DevBuh(Exmpl)
                "5" {Clear-Host
                    $select = $database[2].Dev
                    $menu = '2'
                    }
                Default {Clear-Host
                    $menu = '0'}
                }
            }
            #Service entity
            2  {
            Clear-Host
            Write-Host -ForegroundColor Red "Select ServiceLogin Group"
            Write-Host -ForegroundColor Yellow "`n`t Choice the type of entity:`n1. ServiceGroupe CI_CD `n2. ServiceGroupe Grafana `n3. ServiceGroupe MSSql `n4. SubMenu `n"
            Write-Host -ForegroundColor Green "`nDomain:[$Domain]`n"
            $menu2 = read-host [Enter Selection or press Enter to return]
            Switch ($menu2) 
                {
                #ServiceGroupe CI_CD
                "1" {Clear-Host
                    $select = $database.Service1
                    $menu = '1'
                    }
                #ServiceGroupe Grafana
                "2" {Clear-Host
                    $select = $database.Service2
                    $menu = '1'
                    }
                #ServiceGroupe MSSql
                "3" {Clear-Host
                    $select = $database.Service3
                    $menu = '1'
                    }
                #SubMenu
                "4" {Clear-Host
                    Write-Host "`n`t Choice sub entity:`n1. Sub `n2. Super Sub`n" -ForegroundColor Red
                    $menu2.4 = read-host [Enter Selection or press Enter to return]
                    Switch ($menu2.4 )
                        {
                        #SubMenu 1
                        "1" {Clear-Host
                            Write-Host "`nSub`n"
                            $menu = '0'
                            }
                        #SubMenu 2
                        "2" {Clear-Host
                            Write-Host "`nSuper Sub`n"
                            $menu = '0'
                            }
                        Default {Clear-Host
                            $menu = '0'}
                        }
                    }
                Default {Clear-Host
                    $menu = '0'}
                } 
            }
            #Test zone
            3  {
                Clear-Host
                Write-Host -ForegroundColor Green "`nTest Zone Add ADUser`n"
                Write-Host -ForegroundColor Cyan "`n1. Try Add ADUser. `n2. Try Add multiple users from CSV.`n"
                Write-Host -ForegroundColor Red "`n`t`t WARNING! `nAll action will be apply to AD!`n"
                $menu3 = read-host [Enter Selection or press Enter to return] 
                Switch ($menu3) 
                {
                #Test Add ADUser
                "1" {Clear-Host
                    Write-Host "`nTest Add ADUser`n"
                    $select = $test
                    $menu = '2'
                    }
                #Test bulk add
                "2" {Clear-Host
                    Write-Host "`nTest add multiple users`n"
                    $select = '0'
                    $menu = '3'
                    }
                  Default {Clear-Host
                            $menu = '0'}
                }
            }
            #0.Exit
            0   {Clear-Host
                    $menu = '0'
                    $select = '0'
                    Exit
                }
        Default {Clear-Host
            $menu = '0'}
        }
    }
until ($menu -gt '0')

#Start collect user data
if($select -ne '0') {
Clear-Host
Write-Host -ForegroundColor Magenta "`n`n  Selected Groups:`n`n" -NoNewline
Write-Host -ForegroundColor Cyan "---> " -NoNewline
Write-Host -ForegroundColor Red "[" -NoNewline
Write-Host -ForegroundColor Green "$select" -NoNewline
Write-Host -ForegroundColor Red "]`n`n"

#Generate Password
Write-Host -ForegroundColor Red "`tPasssword will be generated randomly."
Add-Type -AssemblyName System.Web
$unsecPwd = [System.Web.Security.Membership]::GeneratePassword(8, 2) 

#Collection of user data
Write-Host -ForegroundColor Green "`n`tEnter entity data:`n"
$GivenName = Read-Host "`n`nEnter First Name`n`n"
$Surname = Read-Host "`n`nEnter Last Name`n`n"
$SamAccountName = Read-Host "`n`nEnter SamAccountName without:["$Domain"]`n`n"
$EmailAddress = Read-Host "`n`nEnter FQDN for email adress`n`n"
$Name = $GivenName+' '+$Surname
$DisplayName = $Surname+' '+$GivenName
$Description = [string]@(if ($menu -lt '2') {'Service'} 
                else {Read-Host "`n`nEnter description`n`n"})
$Phone = [string]@(if ($menu -gt '1') {Read-Host "`n`nEnter telephone number`n`n"} 
                else {''})
$UserPrincipalName = $SamAccountName+'@'+$Domain 
$Manager = Read-Host "`n`nEnter Manager name(SAM)`n`n"
$Department = Read-Host "`n`nEnter Department`n`n"
$Post = Read-Host "`n`nEnter post(Должность)`n`n"
$Office = Read-Host "`n`nEnter Office`n`n"

#New-ADUser
New-ADUser -GivenName "$GivenName" -Surname "$Surname" -SamAccountName "$SamAccountName" -Name "$Name" -DisplayName "$DisplayName" -Path "$select" -EmailAddress "$EmailAddress" -Description "$Description"  -OfficePhone "$Phone" -UserPrincipalName "$UserPrincipalName" -AccountPassword (convertto-securestring $unsecPwd -AsPlainText -Force) -Department "$Department" -Manager "$Manager" -title "$Post" -Office "$Office"

#-AccountPassword (Read-Host "Enter Password for $GivenName $Surname" -AsSecureString) `

#Show password
Write-Host -ForegroundColor Green "`nPassword is: $unsecPwd`n"
#Purdge password
$unsecPwd='0'
}

if ($menu -eq '2') {
#Connect to Exchange
#Set-ExecutionPolicy RemoteSigned
Install-Module -Name PowershellGet -Force
Install-Module -Name ExchangeOnlineManagement -Force

#Select user for Exchange
$ask = Read-Host "`n`n`nExchange user is $env:USERNAME@global.ru`n`n `n`nPress Enter or enter 1 to chandge login`n`n`n"
$mailuser = [string]@(if ($ask -eq '1') {Read-Host "Enter login name without @global.ru"}
                        else {"$env:USERNAME@global.ru"})

Connect-ExchangeOnline -UserPrincipalName $mailuser@global.ru -ShowProgress $true
#Converting mailbox to shared
Set-Mailbox "$EmailAddress" –Type shared 
Write-Host -ForegroundColor Green "A $EmailAddress account was shared."
Disconnect-ExchangeOnline 
Write-Host -ForegroundColor Green "`n`nDone.`n `n-SamAccountName: "$SamAccountName" `n-Path: "$select" `n-EmailAddress: "$EmailAddress" `n-UserPrincipalName: "$UserPrincipalName" `n`n"
    }

elseif ($menu -eq '3') {
#For CSV with comma only!
#Enter path
    do {
    $testpath = $null
    clear
    Write-Host -ForegroundColor Cyan "`n`t Enter path to CSV with comma only!: `n"
    $Path = Read-Host "[Type real path to exit from loop]"
    $testpath = Test-Path -Path $Path
       }
    until($testpath)
#Store the data from .csv in the $import variable
$import = Import-csv -Path $Path

#Loop through each row containing user details in the CSV file 
foreach ($param in $import)
    {
	 #Read user data from each field in each row and assign the data to a variable as below
	$username = $param.username
	$Password = $param.'password ' 
	$Firstname = $param.firstname
	$Lastname = $param.lastname
	$OU = $param.ou
	$email = $param.email
	$jobtitle = $param.jobtitle
    $UserPrincipalName = $username+'@'+$Domain
	

		#Check to see if the user already exists in AD
		if (Get-ADUser -F {SamAccountName -eq $username})
			{
		 #If user does exist, give a warning
			Write-Warning "A user account with username $username already exist in Active Directory."
			}
		else
			{
		#user does not exist then proceed to create the new param account
		
        #Account will be created in the OU provided by the $OU variable read from the CSV file
		New-ADUser -UserPrincipalName "$UserPrincipalName" -SamAccountName "$username" -Name "$Firstname $Lastname" -GivenName "$Firstname" -Surname "$Lastname" -DisplayName "$Lastname $Firstname" -Path "$OU" -EmailAddress "$email" -Description "Bulk $jobtitle" -title "$jobtitle" -AccountPassword (convertto-securestring $Password -AsPlainText -Force)
			}
        Write-Host -ForegroundColor Green "`n`nDone.`n `n-SamAccountName: "$username" `n-Path: "$OU" `n-EmailAddress: "$email" `n-UserPrincipalName: "$UserPrincipalName" `n`n"
    }
}

else {Write-Host -ForegroundColor Green "`n`nDone.`n `n-SamAccountName: "$SamAccountName" `n-Path: "$select" `n-EmailAddress: "$EmailAddress" `n-UserPrincipalName: "$UserPrincipalName" `n`n"}
