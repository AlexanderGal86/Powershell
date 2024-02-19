$users = Get-ADComputer -Filter {OperatingSystem -notLike '*SERVER*' } -Properties LastLogonDate | Sort Name 

$usersWithFormattedTimestamp = foreach ($user in $users) {

    $formattedTimestamp = if ($user.LastLogonTimestamp) {

        [DateTime]::FromFileTime($user.LastLogonTimestamp).ToString("yyyy-MM-dd HH:mm:ss")

    } else {

        ""

    }

    

    [PSCustomObject]@{

        Name              = $user.Name

        WhenCreated       = $user.WhenCreated

        LastLogonTimestamp = $formattedTimestamp

    }

}

$usersWithFormattedTimestamp | Export-Csv $env:HOMEPATH\Desktop\adcomputers-last-logon2.csv -NoTypeInformation