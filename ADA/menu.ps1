$Panther = "C:\Windows\Panther"
$UnattendedPath = "$Panther\Unattend.xml"

function Write-SectionHeader {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true, Position = 0)]
        [System.String]
        $Message
    )
    Write-DarkGrayLine
    Write-DarkGrayDate
    Write-Host -ForegroundColor Cyan $Message
}
#============================================================
cls
Write-Host "================ Main Menu ==================" -ForegroundColor Yellow
Write-Host " "
Write-Host "=============================================" -ForegroundColor Yellow
Write-Host "========== ADA Mobelfabrik GMBH ===+++=======" -ForegroundColor Yellow
Write-Host "=============================================`n" -ForegroundColor Yellow
Write-Host "1: Windows 11 24H2 | English | Enterprise | Offline Installer" -ForegroundColor Yellow
Write-Host "2: Windows 11 24H2 | German | Enterprise | Offline Installer" -ForegroundColor Yellow
Write-Host "3: Windows 11 24H2 | Hungarian | Enterprise | Offline Installer" -ForegroundColor Yellow
Write-Host "4: Windows 11 24H2 | English | Enterprise | Online Installer" -ForegroundColor Yellow
Write-Host "5: Windows 11 24H2 | German | Enterprise | Online Installer" -ForegroundColor Yellow
Write-Host "6: Windows 11 24H2 | Hungarian | Enterprise | Online Installer" -ForegroundColor Yellow
Write-Host "7: Exit`n"-ForegroundColor Yellow

Write-Host "`n DISCLAIMER: USE AT YOUR OWN RISK - Going further will erase all data on your disk ! `n"-ForegroundColor Red

$input = Read-Host "Please make a selection"

switch ($input)
{
    '1' {
        $OSName = 'Windows 11 24H2 x64'
        $OSEdition = 'Enterprise' # Changed to Enterprise as per menu
        $OSActivation = 'Volume' # Or 'Volume' if using VLK
        $OSLanguage = 'en-US' # Changed to en-US for consistency, en-EN is not a standard locale
        #Set OSDCloud Vars

        $Global:MyOSDCloud = [ordered]@{
            Restart = [bool]$False
            RecoveryPartition = [bool]$true
            OEMActivation = [bool]$True
            WindowsUpdate = [bool]$true
            WindowsUpdateDrivers = [bool]$false
            WindowsDefenderUpdate = [bool]$false
            SetTimeZone = [bool]$true
            ClearDiskConfirm = [bool]$False
            ShutdownSetupComplete = [bool]$false
            SyncMSUpCatDriverUSB = [bool]$true
            CheckSHA1 = [bool]$true
        }

        #Region Custom Image - For Offline Installer
        $ESDName = 'windows11-24h2-en.esd'
        $ImageFileItem = Find-OSDCloudFile -Name $ESDName -Path '\OSDCloud\OS\'
        if ($ImageFileItem) {
            $ImageFileItem = $ImageFileItem | Where-Object {$_.FullName -notlike "C*"} | Where-Object {$_.FullName -notlike "X*"} | Select-Object -First 1
            if ($ImageFileItem) {
                $ImageFileName = Split-Path -Path $ImageFileItem.FullName -Leaf
                $ImageFileFullName = $ImageFileItem.FullName

                $Global:MyOSDCloud.ImageFileItem = $ImageFileItem
                $Global:MyOSDCloud.ImageFileName = $ImageFileName
                $Global:MyOSDCloud.ImageFileFullName = $ImageFileFullName
                $Global:MyOSDCloud.OSImageIndex = 1
            }
        }
        Write-Host "Creating $sourcePath..."
            if (-not (Test-Path $sourcePath)) {
            New-Item -Path $sourcePath -ItemType Directory | Out-Null
            }

        #Prompt the user for the client name
        $clientName = Read-Host "Please enter the client name"

        #Save the client name to clientname.txt in X:\Temp
        Set-Content -Path $filePath -Value $clientName
        #Launch OSDCloud
        Start-OSDCloud -ImageFileUrl $ImageFileItem -ImageIndex 1 -Zti
        try {
            Move-Item -Path $sourcePath -Destination $destinationPath -Force -ErrorAction Stop
            Write-Host "Successfully moved '$sourcePath' to '$destinationPath'."
            Write-Host "Client name '$clientName' has been saved to $destinationPath\$fileName"
        }
        catch {
            Write-Error "Failed to move directory: $($_.Exception.Message)"
            Write-Host "The client name is still saved at $filePath"
        }
        Restart-Computer -Force
    }
    '2' {
        $OSName = 'Windows 11 24H2 x64'
        $OSEdition = 'Enterprise' # Changed to Enterprise as per menu
        $OSActivation = 'Volume' # Or 'Volume' if using VLK
        $OSLanguage = 'de-DE' # Changed to en-US for consistency, en-EN is not a standard locale
        #Set OSDCloud Vars

        $Global:MyOSDCloud = [ordered]@{
            Restart = [bool]$False
            RecoveryPartition = [bool]$true
            OEMActivation = [bool]$True
            WindowsUpdate = [bool]$true
            WindowsUpdateDrivers = [bool]$false
            WindowsDefenderUpdate = [bool]$false
            SetTimeZone = [bool]$true
            ClearDiskConfirm = [bool]$False
            ShutdownSetupComplete = [bool]$false
            SyncMSUpCatDriverUSB = [bool]$true
            CheckSHA1 = [bool]$true
        }

        #Region Custom Image - For Offline Installer
        $ESDName = 'windows11-24h2-de.esd'
        $ImageFileItem = Find-OSDCloudFile -Name $ESDName -Path '\OSDCloud\OS\'
        if ($ImageFileItem) {
            $ImageFileItem = $ImageFileItem | Where-Object {$_.FullName -notlike "C*"} | Where-Object {$_.FullName -notlike "X*"} | Select-Object -First 1
            if ($ImageFileItem) {
                $ImageFileName = Split-Path -Path $ImageFileItem.FullName -Leaf
                $ImageFileFullName = $ImageFileItem.FullName

                $Global:MyOSDCloud.ImageFileItem = $ImageFileItem
                $Global:MyOSDCloud.ImageFileName = $ImageFileName
                $Global:MyOSDCloud.ImageFileFullName = $ImageFileFullName
                $Global:MyOSDCloud.OSImageIndex = 1
            }
        }
        if (-not (Test-Path $Panther)) {
            New-Item -Path $Panther -ItemType Directory -Force -ErrorAction Stop | Out-Null
            }
        # Move XAML definition and window display outside the button click event
        Add-Type -AssemblyName PresentationFramework
        [xml]$xaml =
        @"
<Window xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
        xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml"
        xmlns:d="http://schemas.microsoft.com/expression/blend/2008"
        xmlns:mc="http://schemas.openxmlformats.org/markup-compatibility/2006"
        Title="Let's do automation" Height="auto" Width="auto" SizeToContent="WidthAndHeight" Topmost="True"
        WindowStartupLocation="CenterScreen" >
    <StackPanel Orientation="Vertical">
        <GroupBox Header="Configure computer name">
            <StackPanel Orientation="Vertical">
                <TextBlock>
                    Name:    
                </TextBlock>
                <TextBox Name="input_computer_name" />
                <Button Name="button_join_and_rename" Content="Rename" />
            </StackPanel>
        </GroupBox>
    </StackPanel>
</Window>
"@
        $window = [Windows.Markup.XamlReader]::Load((New-Object System.Xml.XmlNodeReader $xaml))

        $input_computer_name = $window.FindName('input_computer_name')

        $window.FindName('button_join_and_rename').Add_Click(
            {
                # This code will execute when the button is clicked
                $clientName = $input_computer_name.Text
                $UnattendXmlContent = @"
<?xml version="1.0" encoding="utf-8"?>
<unattend xmlns="urn:schemas-microsoft-com:unattend">
    <settings pass="specialize">
        <component name="Microsoft-Windows-Shell-Setup" processorArchitecture="amd64" publicKeyToken="31bf3856ad364e35" language="neutral" versionScope="nonSxS">
            <ComputerName>$clientName</ComputerName>
        </component>
    </settings>
</unattend>
"@
                $window.Close()
            }
        )
        # Show the window here so the user can interact with it
        $window.ShowDialog()

        #Launch OSDCloud
        Start-OSDCloud -ImageFileUrl $ImageFileItem -ImageIndex 1 -Zti
        try {
            Move-Item -Path $sourcePath -Destination $destinationPath -Force -ErrorAction Stop
            Write-Host "Successfully moved '$sourcePath' to '$destinationPath'."
            Write-Host "Client name '$clientName' has been saved to $destinationPath\$fileName"
        }
        catch {
            Write-Error "Failed to move directory: $($_.Exception.Message)"
            Write-Host "The client name is still saved at $filePath"
        }
        $UnattendXmlContent | Out-File -FilePath $UnattendedPath -Encoding UTF8 -Force
        Restart-Computer -Force
    }
    '3' {
        $OSName = 'Windows 11 24H2 x64'
        $OSEdition = 'Enterprise' # Changed to Enterprise as per menu
        $OSActivation = 'Volume' # Or 'Volume' if using VLK
        $OSLanguage = 'hu-HU' # Corrected to Hungarian

        #Set OSDCloud Vars
        $Global:MyOSDCloud = [ordered]@{
            Restart = [bool]$False
            RecoveryPartition = [bool]$true
            OEMActivation = [bool]$True
            WindowsUpdate = [bool]$true
            WindowsUpdateDrivers = [bool]$false
            WindowsDefenderUpdate = [bool]$false
            SetTimeZone = [bool]$true
            ClearDiskConfirm = [bool]$False
            ShutdownSetupComplete = [bool]$false
            SyncMSUpCatDriverUSB = [bool]$true
            CheckSHA1 = [bool]$true
        }

        Write-SectionHeader "OSDCloud Variables"
        Write-Output $Global:MyOSDCloud

        #Launch OSDCloud
        Write-SectionHeader -Message "Starting OSDCloud"

        #Region Custom Image - For Offline Installer
        $ESDName = 'windows11-24h2-hu.esd' # Corrected to Hungarian ESD
        $ImageFileItem = Find-OSDCloudFile -Name $ESDName -Path '\OSDCloud\OS\'
        if ($ImageFileItem) {
            $ImageFileItem = $ImageFileItem | Where-Object {$_.FullName -notlike "C*"} | Where-Object {$_.FullName -notlike "X*"} | Select-Object -First 1
            if ($ImageFileItem) {
                $ImageFileName = Split-Path -Path $ImageFileItem.FullName -Leaf
                $ImageFileFullName = $ImageFileItem.FullName

                $Global:MyOSDCloud.ImageFileItem = $ImageFileItem
                $Global:MyOSDCloud.ImageFileName = $ImageFileName
                $Global:MyOSDCloud.ImageFileFullName = $ImageFileFullName
                $Global:MyOSDCloud.OSImageIndex = 1
            }
        }
        Start-OSDCloud -ImageFileUrl $ImageFileItem -ImageIndex 1 -Zti
    }
    '4' {
        # Logic for Windows 11 24H2 | English | Enterprise | Online Installer
        # This will likely involve downloading the OS image directly via OSDCloud
        # Example (you'll need to confirm the exact OSDCloud commands for online installs):
        Write-Host "Starting Online Installation for Windows 11 24H2 English Enterprise..."
        $OSName = 'Windows 11 24H2 x64'
        $OSLanguage = 'en-US'
        $OSEdition = 'Enterprise'
        $OSActivation = 'Volume'

        #Set OSDCloud Vars
        $Global:MyOSDCloud = [ordered]@{
            Restart = [bool]$False
            RecoveryPartition = [bool]$true
            OEMActivation = [bool]$True
            WindowsUpdate = [bool]$true
            WindowsUpdateDrivers = [bool]$false
            WindowsDefenderUpdate = [bool]$false
            SetTimeZone = [bool]$true
            ClearDiskConfirm = [bool]$False
            ShutdownSetupComplete = [bool]$false
            SyncMSUpCatDriverUSB = [bool]$true
            CheckSHA1 = [bool]$true
        }

        Write-SectionHeader "OSDCloud Variables"
        Write-Output $Global:MyOSDCloud

        #Launch OSDCloud
        Write-SectionHeader -Message "Starting OSDCloud"
        Start-OSDCloud -OSName $OSName -OSEdition $OSEdition -OSActivation $OSActivation -OSLanguage $OSLanguage
        Write-SectionHeader -Message "OSDCloud Process Complete, Running Custom Actions From Script Before Reboot"

        # Note: You'll need to adapt the OSDCloud parameters for online installation,
        # typically you wouldn't specify an ESDName for online installs.
    }
    '5' {
        # Logic for Windows 11 24H2 | German | Enterprise | Online Installer
        Write-Host "Starting Online Installation for Windows 11 24H2 German Enterprise..."
        $OSName = 'Windows 11 24H2 x64'
        $OSLanguage = 'de-DE'
        $OSEdition = 'Enterprise'
        $OSActivation = 'Volume'

        #Set OSDCloud Vars
        $Global:MyOSDCloud = [ordered]@{
            Restart = [bool]$False
            RecoveryPartition = [bool]$true
            OEMActivation = [bool]$True
            WindowsUpdate = [bool]$true
            WindowsUpdateDrivers = [bool]$false
            WindowsDefenderUpdate = [bool]$false
            SetTimeZone = [bool]$true
            ClearDiskConfirm = [bool]$False
            ShutdownSetupComplete = [bool]$false
            SyncMSUpCatDriverUSB = [bool]$true
            CheckSHA1 = [bool]$true
        }

        Write-SectionHeader "OSDCloud Variables"
        Write-Output $Global:MyOSDCloud

        #Launch OSDCloud
        Write-SectionHeader -Message "Starting OSDCloud"
        Start-OSDCloud -OSName $OSName -OSEdition $OSEdition -OSActivation $OSActivation -OSLanguage $OSLanguage
        Write-SectionHeader -Message "OSDCloud Process Complete, Running Custom Actions From Script Before Reboot"
    }
    '6' {
        # Logic for Windows 11 24H2 | Hungarian | Enterprise | Online Installer
        Write-Host "Starting Online Installation for Windows 11 24H2 Hungarian Enterprise..."
        $OSName = 'Windows 11 24H2 x64'
        $OSLanguage = 'hu-HU'
        $OSEdition = 'Enterprise'
        $OSActivation = 'Volume'
        #Set OSDCloud Vars
        $Global:MyOSDCloud = [ordered]@{
            Restart = [bool]$False
            RecoveryPartition = [bool]$true
            OEMActivation = [bool]$True
            WindowsUpdate = [bool]$true
            WindowsUpdateDrivers = [bool]$true
            WindowsDefenderUpdate = [bool]$false
            SetTimeZone = [bool]$true
            ClearDiskConfirm = [bool]$False
            ShutdownSetupComplete = [bool]$false
            SyncMSUpCatDriverUSB = [bool]$true
            CheckSHA1 = [bool]$true
        }

        Write-SectionHeader "OSDCloud Variables"
        Write-Output $Global:MyOSDCloud

        #Launch OSDCloud
        Write-SectionHeader -Message "Starting OSDCloud"
        Start-OSDCloud -OSName $OSName -OSEdition $OSEdition -OSActivation $OSActivation -OSLanguage $OSLanguage
        Write-SectionHeader -Message "OSDCloud Process Complete, Running Custom Actions From Script Before Reboot"
    }
    '7' {
        Write-Host "Exiting script. Goodbye!" -ForegroundColor Green
        exit
    }
    default {
        Write-Host "Invalid selection. Please enter a number between 1 and 7." -ForegroundColor Red
    }
}
