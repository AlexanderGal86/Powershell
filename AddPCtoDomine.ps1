#Author: a.gal86@ya.ru
#Adding in domain

#Menu
Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

$converter = 
    @{
    'Финансовый отдел.' = 'buh'
    'Маркетинг.' = 'markt'
    'Складской комплекс.' = 'store'
    'Отдел закупок.' = 'stock'
    'Интернет-магазин.' = 'intern'
    'Колл-центр.' = 'call'
    'Школа.' = 'school'
    'Отдел персонала.' = 'hr'
    'Розничная сеть.' = 'sale'
    'АХО.' = 'aho'
    'Юридический отдел.' = 'uredit' 
    'Контрольно-ревизионный.' = 'corev'
    'Отдел логистики.' = 'logi'
    'IT отдел.' = 'it'
    }

$form = New-Object System.Windows.Forms.Form
$form.Text = 'AutoDomain'
$form.Size = New-Object System.Drawing.Size(330,200)
$form.StartPosition = 'CenterScreen'

$okButton = New-Object System.Windows.Forms.Button
$okButton.Location = New-Object System.Drawing.Point(75,120)
$okButton.Size = New-Object System.Drawing.Size(75,23)
$okButton.Text = 'OK'
$okButton.DialogResult = [System.Windows.Forms.DialogResult]::OK
$form.AcceptButton = $okButton
$form.Controls.Add($okButton)

$cancelButton = New-Object System.Windows.Forms.Button
$cancelButton.Location = New-Object System.Drawing.Point(150,120)
$cancelButton.Size = New-Object System.Drawing.Size(75,23)
$cancelButton.Text = 'Cancel'
$cancelButton.DialogResult = [System.Windows.Forms.DialogResult]::Cancel
$form.CancelButton = $cancelButton
$form.Controls.Add($cancelButton)

$label = New-Object System.Windows.Forms.Label
$label.Location = New-Object System.Drawing.Point(10,20)
$label.Size = New-Object System.Drawing.Size(380,20)
$label.Text = 'Выберите отдел:'
$form.Controls.Add($label)

$listBox = New-Object System.Windows.Forms.ListBox
$listBox.Location = New-Object System.Drawing.Point(10,40)
$listBox.Size = New-Object System.Drawing.Size(260,20)
$listBox.Height = 80

[void] $listBox.Items.Add('Финансовый отдел.')
[void] $listBox.Items.Add('Маркетинг.')
[void] $listBox.Items.Add('Складской комплекс.')
[void] $listBox.Items.Add('Отдел закупок.')
[void] $listBox.Items.Add('Интернет-магазин.')
[void] $listBox.Items.Add('Колл-центр.')
[void] $listBox.Items.Add('Школа.')
[void] $listBox.Items.Add('Отдел персонала.')
[void] $listBox.Items.Add('Розничная сеть.')
[void] $listBox.Items.Add('АХО.') 
[void] $listBox.Items.Add('Юридический отдел.') 
[void] $listBox.Items.Add('Контрольно-ревизионный.')
[void] $listBox.Items.Add('Отдел логистики.')
[void] $listBox.Items.Add('IT отдел.')

$form.Controls.Add($listBox)

$form.Topmost = $true

$result = $form.ShowDialog()

if ($result -eq [System.Windows.Forms.DialogResult]::OK)
    {
    $depot = $converter[$listBox.SelectedItem]
    }
do
    { 
    #Generate name
    $r = Get-Random -Minimum 10 -Maximum 300
    $n = 'Spb'+'-'+$depot+'-'+$r
    #free name check
    $answer = Test-NetConnection -ComputerName $n
    }
While($answer.PingSucceeded -eq 'False')
Write-Host('Новое имя: '+$n)

#rename and add to domain
Add-Computer -DomainName paris-nail.local -Confirm -Force -NewName $n -PassThru -Verbose -Restart
pause