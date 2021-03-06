﻿#Author a.gal86@ya.ru
#For CSV with comma and without spaces or tabs!
#Import active directory module for running AD cmdlets
Import-Module activedirectory
  
#Store the data from .csv in the $import variable
$import = Import-csv -Path .\Bulk_Users.csv

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
		New-ADUser `
            -UserPrincipalName "$username@paris-nail.local" `
			-SamAccountName $username `
            -Name "$Firstname $Lastname" `
            -GivenName $Firstname `
            -Surname $Lastname `
            -DisplayName "$Lastname $Firstname" `
            -Path $OU `
            -EmailAddress $email `
            -Description $jobtitle `
            -AccountPassword (convertto-securestring $Password -AsPlainText -Force)
		
				Write-Host "A $username account will be created."
			}
}
