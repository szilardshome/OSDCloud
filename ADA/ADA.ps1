# Placeholder functions (YOU NEED TO DEFINE THESE PROPERLY)
# Include these function definitions if they are not already defined elsewhere
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

        [string]$ESDName = $null # Only required for offline
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
Write-Host "================ Main Menu ==================" -ForegroundColor Yellow
Write-Host " "
Write-Host "=============================================" -ForegroundColor Yellow
Write-Host "========== ADA Mobelfabrik GMBH =============" -ForegroundColor Yellow
Write-Host "=============================================`n" -ForegroundColor Yellow

## Automatic ADA.ppkg Download

# --- ADA.ppkg Download Logic (runs automatically) ---
Write-SectionHeader "Startup Preparations: Downloading ADA.ppkg"

$SourceUrl = "https://github.com/szilardshome/OSDCloud/raw/main/ADA/ADA.ppkg"
$FileName = "ADA.ppkg"

# List of possible root drives to check in order of priority
$PossibleRootDrives = @("C:", "D:", "E:", "F:", "G:")
$TargetSubPath = "OSDCloud\Automate\Provisioning"

$DestinationPath = $null # This will store the final destination path

Write-Host "Searching for an existing destination directory for download..." -ForegroundColor Yellow

# Iterate through the possible drive letters
foreach ($Drive in $PossibleRootDrives) {
    $CurrentCheckPath = Join-Path -Path $Drive -ChildPath $TargetSubPath
    Write-Host "Checking: $CurrentCheckPath" -ForegroundColor DarkGray

    if (Test-Path -Path $CurrentCheckPath -PathType Container) { # -PathType Container checks if it's a directory
        $DestinationPath = Join-Path -Path $CurrentCheckPath -ChildPath $FileName
        Write-Host "Found! The file will be downloaded to: $DestinationPath" -ForegroundColor Green
        break # Found the first existing folder, exit the loop
    }
}

# Check if a valid destination directory was found
if ($null -eq $DestinationPath) {
    Write-Host "Error: No existing destination directory found for 'ADA.ppkg' at the specified paths." -ForegroundColor Red
    Write-Host "Please ensure that at least one of C:\OSDCloud\Automate\Provisioning, D:\OSDCloud\Automate\Provisioning, etc., exists." -ForegroundColor Red
    # Decide here if the script should exit or continue with the menu display
    # exit 1 # Uncomment this line if you want the script to exit on error without showing the menu
} else {
    try {
        # Check if the file already exists, and skip download if it does
        if (Test-Path -Path $DestinationPath) {
            Write-Host "'$FileName' already exists at '$DestinationPath'. Download skipped." -ForegroundColor DarkYellow
        } else {
            Write-Host "Starting download of '$FileName' from '$SourceUrl'..." -ForegroundColor Yellow
            Invoke-WebRequest -Uri $SourceUrl -OutFile $DestinationPath -UseBasicParsing -ErrorAction Stop
            Write-Host "Successfully downloaded '$FileName' to '$DestinationPath'." -ForegroundColor Green
        }
    } catch {
        Write-Host "An error occurred during the 'ADA.ppkg' download:" -ForegroundColor Red
        Write-Host $_.Exception.Message -ForegroundColor Red
        Write-Host "Please check your internet connection and the source URL." -ForegroundColor Red
    }
}

## Main Menu Options

# --- Download complete, now display the menu and get user input ---
Write-Host "`n" # Empty line before the menu
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
    '1' { Invoke-OSDCloudInstallation -OSLanguage 'en-US' -Type 'Offline' -ESDName 'windows11-24h2-en.esd' }
    '2' { Invoke-OSDCloudInstallation -OSLanguage 'de-DE' -Type 'Offline' -ESDName 'windows11-24h2-de.esd' }
    '3' { Invoke-OSDCloudInstallation -OSLanguage 'hu-HU' -Type 'Offline' -ESDName 'windows11-24h2-hu.esd' }
    '4' { Invoke-OSDCloudInstallation -OSLanguage 'en-US' -Type 'Online' }
    '5' { Invoke-OSDCloudInstallation -OSLanguage 'de-DE' -Type 'Online' }
    '6' { Invoke-OSDCloudInstallation -OSLanguage 'hu-HU' -Type 'Online' }
    '7' {
        Write-Host "Exiting script. Goodbye!" -ForegroundColor Green
        exit
    }
    default {
        Write-Host "Invalid selection. Please enter a number between 1 and 7." -ForegroundColor Red
    }
}
