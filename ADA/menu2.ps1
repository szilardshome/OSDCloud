function Write-SectionHeader {
    param(
        [string]$Message = ""
    )
    Write-Host " "
    Write-Host "=============================================" -ForegroundColor Green
    if (-not ([string]::IsNullOrEmpty($Message))) {
        Write-Host "========== $Message ===============" -ForegroundColor Green
    }
    Write-Host "=============================================`n" -ForegroundColor Green
}

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
        $OSEdition = 'Enterprise'
        $OSActivation = 'Volume'
        $OSLanguage = 'en-US'

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
        $Global:MyOSDCloud | Format-List | Out-String | Write-Host

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
                
                Write-SectionHeader -Message "Starting OSDCloud Offline Installation for $OSLanguage"
                Start-OSDCloud -ImageFileUrl $ImageFileItem.FullName -ImageIndex 1 -Zti -OSName $OSName -OSEdition $OSEdition -OSActivation $OSActivation -OSLanguage $OSLanguage
                Write-SectionHeader -Message "OSDCloud Process Complete, Running Custom Actions From Script Before Reboot"
            } else {
                Write-Host "Error: Could not find a suitable image file for '$ESDName'." -ForegroundColor Red
            }
        } else {
            Write-Host "Error: The ESD file '$ESDName' was not found in '\OSDCloud\OS\'. Please ensure it exists." -ForegroundColor Red
        }
    }
    '2' {
        $OSName = 'Windows 11 24H2 x64'
        $OSEdition = 'Enterprise'
        $OSActivation = 'Volume'
        $OSLanguage = 'de-DE'

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
        $Global:MyOSDCloud | Format-List | Out-String | Write-Host

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

                Write-SectionHeader -Message "Starting OSDCloud Offline Installation for $OSLanguage"
                Start-OSDCloud -ImageFileUrl $ImageFileItem.FullName -ImageIndex 1 -Zti -OSName $OSName -OSEdition $OSEdition -OSActivation $OSActivation -OSLanguage $OSLanguage
                Write-SectionHeader -Message "OSDCloud Process Complete, Running Custom Actions From Script Before Reboot"
            } else {
                Write-Host "Error: Could not find a suitable image file for '$ESDName'." -ForegroundColor Red
            }
        } else {
            Write-Host "Error: The ESD file '$ESDName' was not found in '\OSDCloud\OS\'. Please ensure it exists." -ForegroundColor Red
        }
    }
    '3' {
        $OSName = 'Windows 11 24H2 x64'
        $OSEdition = 'Enterprise'
        $OSActivation = 'Volume'
        $OSLanguage = 'hu-HU'

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
        $Global:MyOSDCloud | Format-List | Out-String | Write-Host

        $ESDName = 'windows11-24h2-hu.esd'
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
                
                Write-SectionHeader -Message "Starting OSDCloud Offline Installation for $OSLanguage"
                Start-OSDCloud -ImageFileUrl $ImageFileItem.FullName -ImageIndex 1 -Zti -OSName $OSName -OSEdition $OSEdition -OSActivation $OSActivation -OSLanguage $OSLanguage
                Write-SectionHeader -Message "OSDCloud Process Complete, Running Custom Actions From Script Before Reboot"
            } else {
                Write-Host "Error: Could not find a suitable image file for '$ESDName'." -ForegroundColor Red
            }
        } else {
            Write-Host "Error: The ESD file '$ESDName' was not found in '\OSDCloud\OS\'. Please ensure it exists." -ForegroundColor Red
        }
    }
    '4' {
        Write-Host "Starting Online Installation for Windows 11 24H2 English Enterprise..."
        $OSName = 'Windows 11 24H2 x64'
        $OSLanguage = 'en-US'
        $OSEdition = 'Enterprise'
        $OSActivation = 'Volume'

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
        $Global:MyOSDCloud | Format-List | Out-String | Write-Host

        Write-SectionHeader -Message "Starting OSDCloud Online Installation for $OSLanguage"
        Start-OSDCloud -OSName $OSName -OSEdition $OSEdition -OSActivation $OSActivation -OSLanguage $OSLanguage
        Write-SectionHeader -Message "OSDCloud Process Complete, Running Custom Actions From Script Before Reboot"
    }
    '5' {
        Write-Host "Starting Online Installation for Windows 11 24H2 German Enterprise..."
        $OSName = 'Windows 11 24H2 x64'
        $OSLanguage = 'de-DE'
        $OSEdition = 'Enterprise'
        $OSActivation = 'Volume'

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
        $Global:MyOSDCloud | Format-List | Out-String | Write-Host

        Write-SectionHeader -Message "Starting OSDCloud Online Installation for $OSLanguage"
        Start-OSDCloud -OSName $OSName -OSEdition $OSEdition -OSActivation $OSActivation -OSLanguage $OSLanguage
        Write-SectionHeader -Message "OSDCloud Process Complete, Running Custom Actions From Script Before Reboot"
    }
    '6' {
        Write-Host "Starting Online Installation for Windows 11 24H2 Hungarian Enterprise..."
        $OSName = 'Windows 11 24H2 x64'
        $OSLanguage = 'hu-HU'
        $OSEdition = 'Enterprise'
        $OSActivation = 'Volume'
        
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
        $Global:MyOSDCloud | Format-List | Out-String | Write-Host

        Write-SectionHeader -Message "Starting OSDCloud Online Installation for $OSLanguage"
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
