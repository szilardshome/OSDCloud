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
            WindowsUpdateDrivers = [bool]$true
            WindowsDefenderUpdate = [bool]$true
            SetTimeZone = [bool]$true
            ClearDiskConfirm = [bool]$False
            ShutdownSetupComplete = [bool]$false
            SyncMSUpCatDriverUSB = [bool]$true
            CheckSHA1 = [bool]$true
        }

        #Launch OSDCloud
        Write-Host "Start-OSDCloud -OSName $OSName -OSEdition $OSEdition -OSActivation $OSActivation -OSLanguage $OSLanguage"
        Start-OSDCloud -OSName $OSName -OSEdition $OSEdition -OSActivation $OSActivation -OSLanguage $OSLanguage
        Write-SectionHeader -Message "OSDCloud Process Complete, Running Custom Actions From Script Before Reboot"

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
    }
    '2' {
        $OSName = 'Windows 11 24H2 x64'
        $OSEdition = 'Enterprise' # Changed to Enterprise as per menu
        $OSActivation = 'Volume' # Or 'Volume' if using VLK
        $OSLanguage = 'de-DE' # Corrected to German

        #Set OSDCloud Vars
        $Global:MyOSDCloud = [ordered]@{
            Restart = [bool]$False
            RecoveryPartition = [bool]$true
            OEMActivation = [bool]$True
            WindowsUpdate = [bool]$true
            WindowsUpdateDrivers = [bool]$true
            WindowsDefenderUpdate = [bool]$true
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
        Write-Host "Start-OSDCloud -OSName $OSName -OSEdition $OSEdition -OSActivation $OSActivation -OSLanguage $OSLanguage"
        Start-OSDCloud -OSName $OSName -OSEdition $OSEdition -OSActivation $OSActivation -OSLanguage $OSLanguage
        Write-SectionHeader -Message "OSDCloud Process Complete, Running Custom Actions From Script Before Reboot"

        #Region Custom Image - For Offline Installer
        $ESDName = 'windows11-24h2-de.esd' # Corrected to German ESD
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
            WindowsUpdateDrivers = [bool]$true
            WindowsDefenderUpdate = [bool]$true
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
        Write-Host "Start-OSDCloud -OSName $OSName -OSEdition $OSEdition -OSActivation $OSActivation -OSLanguage $OSLanguage"
        Start-OSDCloud -OSName $OSName -OSEdition $OSEdition -OSActivation $OSActivation -OSLanguage $OSLanguage
        Write-SectionHeader -Message "OSDCloud Process Complete, Running Custom Actions From Script Before Reboot"

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
            WindowsUpdateDrivers = [bool]$true
            WindowsDefenderUpdate = [bool]$true
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
        Write-Host "Start-OSDCloud -OSName $OSName -OSEdition $OSEdition -OSActivation $OSActivation -OSLanguage $OSLanguage"
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
            WindowsUpdateDrivers = [bool]$true
            WindowsDefenderUpdate = [bool]$true
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
        Write-Host "Start-OSDCloud -OSName $OSName -OSEdition $OSEdition -OSActivation $OSActivation -OSLanguage $OSLanguage"
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
            WindowsDefenderUpdate = [bool]$true
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
        Write-Host "Start-OSDCloud -OSName $OSName -OSEdition $OSEdition -OSActivation $OSActivation -OSLanguage $OSLanguage"
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
