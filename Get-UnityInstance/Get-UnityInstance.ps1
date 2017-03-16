#[System.Reflection.Assembly]::LoadWithPartialName("System.Drawing")
#[System.Reflection.Assembly]::LoadWithPartialName("System.Windows.Forms")
Add-Type -AssemblyName System.Drawing
Add-Type -AssemblyName System.Windows.Forms
Import-Module .\Get-NetworkStatistics.ps1
$formTitle = "Unity Instance"
$formPosition = [System.Enum]::GetValues('System.Windows.Forms.FormStartPosition')[1]

$fieldComputerName = "ComputerName"
$fieldProcessName = "ProcessName"
$fieldLocalPort = "LocalPort"

$dataGridView = New-Object System.Windows.Forms.DataGridView
$form = New-Object System.Windows.Forms.Form
$form.add_FormClosing({$timer1.Stop()})

$timer1 = New-Object System.Windows.Forms.Timer
$timer1.Enabled = $true
$timer1.Start()
$timer1.Interval = 5000
$timer1.add_tick({CheckDataGridView})

function GetData
{
    return Get-NetworkStatistics -Computername $env:COMPUTERNAME -Protocol tcp -Address 0.0.0.0 -Port 56* | select $fieldComputerName, $fieldProcessName, $fieldLocalPort 
}

function SetupDataGridView
{
    $dataGridView.ColumnCount = 3
    $dataGridView.AutoSize = $true
    $dataGridView.Columns[0].Name = $fieldComputerName
    $dataGridView.Columns[1].Name = $fieldProcessName
    $dataGridView.Columns[2].Name = $fieldLocalPort

    CheckDataGridView
}

function SetupForm
{
    $form.AutoSize = $true
    $form.StartPosition = $formPosition 
    $form.MaximizeBox = $false
    $form.MinimizeBox = $false
    $form.Controls.Add($dataGridView)
    $form.Text = $formTitle
    $form.ShowDialog() 
}

function CheckDataGridView
{
	$datas = GetData
    $dataGridView.Rows.Clear()
    foreach($data in $datas)
    {
        if($data.ProcessName -ne "Unknown")
        {
            $row = $data.ComputerName, $data.ProcessName, $data.LocalPort 
            $dataGridView.Rows.Add($row) | Out-Null
        }
    }
    $dataGridView.AutoResizeRows()
	$dataGridView.Refresh()
}

function main
{
    SetupDataGridView
    SetupForm
}

main