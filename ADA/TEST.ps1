function Write-DarkGrayLine {
    Write-Host "==================================================" -ForegroundColor DarkGray
}

function Write-DarkGrayDate {
    Write-Host (Get-Date -Format "yyyy-MM-dd HH:mm:ss") -ForegroundColor DarkGray
}

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

function Invoke-OSDCloudInstallation {
    param (
        [Parameter(Mandatory = $true)]
        [string]$OSLanguage,

        [Parameter(Mandatory = $true)]
        [string]$Type, # 'Offline' or 'Online'

        [string]$ESDName = $null, # Only required for offline

        [bool]$EnableUpdates = $false # New parameter to control updates
    )

    $OSName = 'Windows 11 24H2 x64'
    $OSEdition = 'Enterprise'
    $OSActivation = 'Volume'

    # Set OSDCloud Global Variables
    $Global:MyOSDCloud = [ordered]@{
        Restart               = [bool]$False
        RecoveryPartition     = [bool]$true
        OEMActivation         = [bool]$True
        WindowsUpdate         = [bool]$false
        WindowsUpdateDrivers  = [bool]$false
        WindowsDefenderUpdate = [bool]$false
        SetTimeZone           = [bool]$false
        ClearDiskConfirm      = [bool]$False
        ShutdownSetupComplete = [bool]$false
        SyncMSUpCatDriverUSB  = [bool]$true
        CheckSHA1             = [bool]$true
    }

    # Conditionally set update flags based on $EnableUpdates parameter
    if ($EnableUpdates) {
        $Global:MyOSDCloud.WindowsUpdate         = [bool]$true
        $Global:MyOSDCloud.WindowsUpdateDrivers  = [bool]$true
    }

    Write-SectionHeader "OSDCloud Variables for $($OSLanguage) $($Type) Installation"
    Write-Output $Global:MyOSDCloud

    Write-SectionHeader -Message "Starting OSDCloud for $($OSLanguage) $($Type) Installation"

    if ($Type -eq 'Offline') {
        if (-not $ESDName) {
            Write-Host "Error: ESDName is required for offline installation." -ForegroundColor Red
            return
        }
        $imageFilePath = '\OSDCloud\OS\' # Consider making this configurable
        $ImageFileItem = Find-OSDCloudFile -Name $ESDName -Path $imageFilePath

        if ($ImageFileItem) {
            $ImageFileItem = $ImageFileItem | Where-Object {$_.FullName -notlike "X*"} | Select-Object -First 1
            if ($ImageFileItem) {
                $Global:MyOSDCloud.ImageFileItem = $ImageFileItem
                $Global:MyOSDCloud.ImageFileName = Split-Path -Path $ImageFileItem.FullName -Leaf
                $Global:MyOSDCloud.ImageFileFullName = $ImageFileItem.FullName
                $Global:MyOSDCloud.OSImageIndex = 1
                Start-OSDCloud -ImageFileUrl $ImageFileItem -ImageIndex 1 -Zti
                Write-SectionHeader -Message "OSDCloud Process Complete for Offline Installation, Rebooting"
                Restart-Computer -Force
            } else {
                Write-Host "Error: No valid image file found for $ESDName at $imageFilePath." -ForegroundColor Red
            }
        } else {
            Write-Host "Error: Image file $ESDName not found at $imageFilePath." -ForegroundColor Red
        }
    } elseif ($Type -eq 'Online') {
        Start-OSDCloud -OSName $OSName -OSEdition $OSEdition -OSActivation $OSActivation -OSLanguage $OSLanguage
        Write-SectionHeader -Message "OSDCloud Process Complete, Running Custom Actions From Script Before Reboot"
    }
}

#============================================================
cls # Clear the console screen

## Automatic ADA.ppkg Download

# --- ADA.ppkg Download Logic (runs automatically) ---
# This section handles the automatic download of the ADA.ppkg file.
# Write-SectionHeader "Startup Preparations: Downloading ADA.ppkg"

# # Define the source URL and the target filename.
# $SourceUrl = "https://github.com/szilardshome/OSDCloud/raw/main/ADA/ADA.ppkg"
# $FileName = "ADA.ppkg"

# # List of possible root drives to check for the target directory, in order of priority.
# $PossibleRootDrives = @("C:", "D:", "E:", "F:", "G:")
# # Define the sub-path within each drive where the file should be saved.
# $TargetSubPath = "OSDCloud\Automate\Provisioning"

# # Initialize the variable that will store the final destination path.
# $DestinationPath = $null

# Write-Host "Searching for an existing destination directory for download..." -ForegroundColor Yellow

# # Iterate through the possible drive letters to find an existing target directory.
# foreach ($Drive in $PossibleRootDrives) {
#     # Construct the full path to check for the directory.
#     $CurrentCheckPath = Join-Path -Path $Drive -ChildPath $TargetSubPath
#     Write-Host "Checking: $CurrentCheckPath" -ForegroundColor DarkGray

#     # Check if the current path exists and is a directory.
#     if (Test-Path -Path $CurrentCheckPath -PathType Container) {
#         # If found, construct the full destination path including the filename.
#         $DestinationPath = Join-Path -Path $CurrentCheckPath -ChildPath $FileName
#         Write-Host "Found! The file will be downloaded to: $DestinationPath" -ForegroundColor Green
#         break # Exit the loop once the first existing folder is found.
#     }
# }

# if ($null -eq $DestinationPath) {
#     Write-Host "Error: No existing destination directory found for 'ADA.ppkg' at the specified paths." -ForegroundColor Red
# } else {
#     try {
#         # the file if it already exists at the $DestinationPath.
#         Write-Host "Starting download of '$FileName' from '$SourceUrl'..." -ForegroundColor Yellow

#         # Perform the download. If the file exists, it will be overwritten.
#         Invoke-WebRequest -Uri $SourceUrl -OutFile $DestinationPath -UseBasicParsing -ErrorAction Stop

#         Write-Host "Successfully downloaded and overwritten '$FileName' to '$DestinationPath'." -ForegroundColor Green
#     } catch {
#         # Catch and display any errors that occur during the download process.
#         Write-Host "An error occurred during the 'ADA.ppkg' download:" -ForegroundColor Red
#         Write-Host $_.Exception.Message -ForegroundColor Red
#         Write-Host "Please check your internet connection and the source URL." -ForegroundColor Red
#     }
# }

## Main Menu Options

# --- Download complete, now display the menu and get user input ---
Write-Host "`n"
Write-Host "--------------------------------------------------------------------------------" -ForegroundColor DarkCyan
Write-Host "           OSDCloud Deployment for ADA Moebel                               " -ForegroundColor Cyan
Write-Host "--------------------------------------------------------------------------------" -ForegroundColor DarkCyan
Write-Host ""
Write-Host "  1: Windows 11 24H2 | English   | Enterprise | Offline Installer"               -ForegroundColor Yellow
Write-Host "  2: Windows 11 24H2 | English   | Enterprise | Offline Installer | Windows&Driver Updates" -ForegroundColor Red
Write-Host "  3: Windows 11 24H2 | German    | Enterprise | Offline Installer"               -ForegroundColor Yellow
Write-Host "  4: Windows 11 24H2 | German    | Enterprise | Offline Installer | Windows&Driver Updates" -ForegroundColor Red
Write-Host "  5: Windows 11 24H2 | Hungarian | Enterprise | Offline Installer"               -ForegroundColor Yellow
Write-Host "  6: Windows 11 24H2 | Hungarian | Enterprise | Offline Installer | Windows&Driver Updates" -ForegroundColor Red
Write-Host "--------------------------------------------------------------------------------" -ForegroundColor DarkCyan
Write-Host "  7: Windows 11 24H2 | English   | Enterprise | Online Installer"                 -ForegroundColor Yellow
Write-Host "  8: Windows 11 24H2 | German    | Enterprise | Online Installer"                 -ForegroundColor Yellow
Write-Host "  9: Windows 11 24H2 | Hungarian | Enterprise | Online Installer"                 -ForegroundColor Yellow
Write-Host ""
Write-Host " 10: Exit"                                                                         -ForegroundColor Yellow
Write-Host "--------------------------------------------------------------------------------" -ForegroundColor DarkCyan

# Important notes/warnings with a clear separation.
Write-Host "`n Windows Update and Driver Updates can take up to 30min!!! `n"-ForegroundColor Red
Write-Host "`n If you need any help, please go to: Confluence > IT System x86 > NinjaOne > OS Deployment `n"-ForegroundColor Red
Write-Host "--------------------------------------------------------------------------------" -ForegroundColor DarkCyan

$input = Read-Host "Please make a selection"

switch ($input)
{
    '1' { Invoke-OSDCloudInstallation -OSLanguage 'en-US' -Type 'Offline' -ESDName 'windows11-24h2-en.esd' -EnableUpdates $false }
    '2' { Invoke-OSDCloudInstallation -OSLanguage 'en-US' -Type 'Offline' -ESDName 'windows11-24h2-en.esd' -EnableUpdates $true } # Enable updates
    '3' { Invoke-OSDCloudInstallation -OSLanguage 'de-DE' -Type 'Offline' -ESDName 'windows11-24h2-de.esd' -EnableUpdates $false }
    '4' { Invoke-OSDCloudInstallation -OSLanguage 'de-DE' -Type 'Offline' -ESDName 'windows11-24h2-de.esd' -EnableUpdates $true } # Enable updates
    '5' { Invoke-OSDCloudInstallation -OSLanguage 'hu-HU' -Type 'Offline' -ESDName 'windows11-24h2-hu.esd' -EnableUpdates $false }
    '6' { Invoke-OSDCloudInstallation -OSLanguage 'hu-HU' -Type 'Offline' -ESDName 'windows11-24h2-hu.esd' -EnableUpdates $true } # Enable updates
    '7' { Invoke-OSDCloudInstallation -OSLanguage 'en-US' -Type 'Online' -EnableUpdates $false }
    '8' { Invoke-OSDCloudInstallation -OSLanguage 'de-DE' -Type 'Online' -EnableUpdates $false }
    '9' { Invoke-OSDCloudInstallation -OSLanguage 'hu-HU' -Type 'Online' -EnableUpdates $false }
    '10' { # Changed from '7' to '10' based on the menu.
        Write-Host "Exiting script. Goodbye!" -ForegroundColor Green
        exit
    }
    default {
        Write-Host "Invalid selection. Please enter a number between 1 and 10." -ForegroundColor Red # Updated range
    }
}