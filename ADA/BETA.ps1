Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

# --- Logging Function for GUI ---
function Log-Message {
    param(
        [string]$Message,
        [string]$Level = "INFO" # INFO, WARNING, ERROR, CRITICAL
    )
    $logFile = "C:\Temp\gui-log.txt" # Separate log file for GUI events
    $timestamp = (Get-Date -Format "yyyy-MM-dd HH:mm:ss")
    $logEntry = "$timestamp [$Level] $Message"

    try {
        Add-Content -Path $logFile -Value $logEntry -ErrorAction SilentlyContinue # Do not interrupt GUI on error
    } catch {
        # If logging to file fails, at least write to console.
        Write-Error "ERROR: Failed to write to log file (GUI): $($_.Exception.Message) - Message: $logEntry"
    }
}
# --- End Logging Function ---


# --- Console Header Functions ---
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
# --- End Console Header Functions ---


# --- GUI Function Definition ---
function Show-DeploymentGUI {

    $form = New-Object System.Windows.Forms.Form
    $form.Text = "ADA Windows Deployment - Data Entry"
    $form.Size = New-Object System.Drawing.Size(1000, 1000) # Window size (width, height)
    $form.StartPosition = [System.Windows.Forms.FormStartPosition]::CenterScreen # Center the window on screen
    $form.FormBorderStyle = [System.Windows.Forms.FormBorderStyle]::FixedSingle # Fixed size, not resizable
    $form.MaximizeBox = $false # Disable maximize button
    $form.MinimizeBox = $false # Disable minimize button
    $form.BackColor = [System.Drawing.Color]::White # Set window background color to white

    # Hide logo
    $logoPath = "C:\ProgramData\Provisioning\ADA.jpg" # Logo file path
    $pictureBox = New-Object System.Windows.Forms.PictureBox
    if (Test-Path $logoPath) {
        $pictureBox.Image = [System.Drawing.Image]::FromFile($logoPath)
    } else {
        # Fallback if logo not found, create a placeholder
        $bitmap = New-Object System.Drawing.Bitmap(400, 400)
        $graphics = [System.Drawing.Graphics]::FromImage($bitmap)
        $graphics.FillRectangle([System.Drawing.Brushes]::LightGray, 0, 0, 400, 400)
        $font = New-Object System.Drawing.Font("Arial", 24)
        $brush = [System.Drawing.Brushes]::Black
        $stringFormat = New-Object System.Drawing.StringFormat
        $stringFormat.Alignment = [System.Drawing.StringAlignment]::Center
        $stringFormat.LineAlignment = [System.Drawing.StringAlignment]::Center
        $graphics.DrawString("ADA Logo Missing", $font, $brush, (New-Object System.Drawing.RectangleF -ArgumentList 0, 0, 400, 400), $stringFormat)
        $pictureBox.Image = $bitmap
        $graphics.Dispose()
    }
    $pictureBox.SizeMode = [System.Windows.Forms.PictureBoxSizeMode]::StretchImage # Adjust image to size
    $pictureBox.Size = New-Object System.Drawing.Size(400, 400) # Logo size 400x400

    # Set logo position: centered at the top
    $logoX = ([int]($form.ClientSize.Width - $pictureBox.Width) / 2)
    $logoY = 10 # Small distance from top edge
    $pictureBox.Location = New-Object System.Drawing.Point($logoX, $logoY)
    $form.Controls.Add($pictureBox)

    # --- OS Deployment Section ---
    $currentY_OS = $pictureBox.Bottom + 20 # 20px below the logo

    # OS Deployment Title
    $labelOSDeploymentTitle = New-Object System.Windows.Forms.Label
    $labelOSDeploymentTitle.Text = "OS Deployment Data"
    $labelOSDeploymentTitle.Font = New-Object System.Drawing.Font("Segoe UI", 11, [System.Drawing.FontStyle]::Bold)
    $labelOSDeploymentTitle.AutoSize = $True
    $labelOSDeploymentTitle.BackColor = [System.Drawing.Color]::Transparent
    $form.Controls.Add($labelOSDeploymentTitle)
    $leftColumnStartX = 50
    $leftColumnWidth = 400
    $labelOSDeploymentTitle.Location = New-Object System.Drawing.Point(($leftColumnStartX + ($leftColumnWidth - $labelOSDeploymentTitle.Width) / 2), $currentY_OS)

    $currentY_OS = $labelOSDeploymentTitle.Bottom + 20 # 20px below the OS Deployment Title

    # Computer Name Label
    $labelComputerName = New-Object System.Windows.Forms.Label
    $labelComputerName.Text = "Computer Name:"
    $labelComputerName.Location = New-Object System.Drawing.Point($leftColumnStartX, ($currentY_OS - 3))
    $labelComputerName.AutoSize = $True
    $labelComputerName.BackColor = [System.Drawing.Color]::Transparent
    $form.Controls.Add($labelComputerName)

    # Computer Name input field
    $textBoxComputerName = New-Object System.Windows.Forms.TextBox
    $textBoxComputerName.Location = New-Object System.Drawing.Point(($leftColumnStartX + 120), ($currentY_OS - 3))
    $textBoxComputerName.Size = New-Object System.Drawing.Size(200, 20)
    $form.Controls.Add($textBoxComputerName)
    $currentY_OS += 40

    # Organization Unit Label
    $labelOrgUnit = New-Object System.Windows.Forms.Label
    $labelOrgUnit.Text = "Organization Unit:"
    $labelOrgUnit.Location = New-Object System.Drawing.Point($leftColumnStartX, ($currentY_OS - 3))
    $labelOrgUnit.AutoSize = $True
    $labelOrgUnit.BackColor = [System.Drawing.Color]::Transparent
    $form.Controls.Add($labelOrgUnit)

    # Organization Unit dropdown menu
    $comboBoxOrgUnit = New-Object System.Windows.Forms.ComboBox
    $comboBoxOrgUnit.Location = New-Object System.Drawing.Point(($leftColumnStartX + 120), ($currentY_OS - 3))
    $comboBoxOrgUnit.Size = New-Object System.Drawing.Size(200, 20)
    $comboBoxOrgUnit.DropDownWidth = 600
    $comboBoxOrgUnit.Items.AddRange(@(
        "OU=Desktop,OU=AA-Standard,OU=Anger,DC=ada-moebel,DC=com",
        "OU=Notebook,OU=AA-Standard,OU=Anger,DC=ada-moebel,DC=com",
        "OU=Computers,OU=RS,DC=ada-moebel,DC=com",
        "OU=Desktop,OU=HK-Standard,OU=Koermend,DC=ada-moebel,DC=com",
        "OU=Desktop,OU=HN-Standard,OU=Nova,DC=ada-moebel,DC=com",
        "OU=Desktop,OU=HZ,DC=ada-moebel,DC=com"
    ))
    $form.Controls.Add($comboBoxOrgUnit)
    $currentY_OS += 40

    # Region Label
    $labelRegion = New-Object System.Windows.Forms.Label
    $labelRegion.Text = "Region:"
    $labelRegion.Location = New-Object System.Drawing.Point($leftColumnStartX, ($currentY_OS - 3))
    $labelRegion.AutoSize = $True
    $labelRegion.BackColor = [System.Drawing.Color]::Transparent
    $form.Controls.Add($labelRegion)

    # Region dropdown menu
    $comboBoxRegion = New-Object System.Windows.Forms.ComboBox
    $comboBoxRegion.Location = New-Object System.Drawing.Point(($leftColumnStartX + 120), ($currentY_OS - 3))
    $comboBoxRegion.Size = New-Object System.Drawing.Size(200, 20)
    $comboBoxRegion.Items.AddRange(@("Germany", "Hungary", "Romania"))
    $comboBoxRegion.SelectedIndex = 0
    $form.Controls.Add($comboBoxRegion)
    $currentY_OS += 40

    # Time Zone Label
    $labelTimeZone = New-Object System.Windows.Forms.Label
    $labelTimeZone.Text = "Time Zone:"
    $labelTimeZone.Location = New-Object System.Drawing.Point($leftColumnStartX, ($currentY_OS - 3))
    $labelTimeZone.AutoSize = $True
    $labelTimeZone.BackColor = [System.Drawing.Color]::Transparent
    $form.Controls.Add($labelTimeZone)

    # Time Zone dropdown menu
    $comboBoxTimeZone = New-Object System.Windows.Forms.ComboBox
    $comboBoxTimeZone.Location = New-Object System.Drawing.Point(($leftColumnStartX + 120), ($currentY_OS - 3))
    $comboBoxTimeZone.Size = New-Object System.Drawing.Size(200, 20)
    $comboBoxTimeZone.Items.AddRange(@("Wien", "Budapest", "Bucharest"))
    $comboBoxTimeZone.SelectedIndex = 0
    $form.Controls.Add($comboBoxTimeZone)
    $currentY_OS += 40

    # Role Label
    $labelRole = New-Object System.Windows.Forms.Label
    $labelRole.Text = "Role:"
    $labelRole.Location = New-Object System.Drawing.Point($leftColumnStartX, ($currentY_OS - 3))
    $labelRole.AutoSize = $True
    $labelRole.BackColor = [System.Drawing.Color]::Transparent
    $form.Controls.Add($labelRole)

    # Role dropdown menu
    $comboBoxRole = New-Object System.Windows.Forms.ComboBox
    $comboBoxRole.Location = New-Object System.Drawing.Point(($leftColumnStartX + 120), ($currentY_OS - 3))
    $comboBoxRole.Size = New-Object System.Drawing.Size(200, 20)
    $comboBoxRole.Items.AddRange(@("Office", "Production", "Test"))
    $comboBoxRole.SelectedIndex = 0 # Set default selection
    $form.Controls.Add($comboBoxRole)

    # --- End OS Deployment Section ---


    # --- Software Deployment Section ---
    $softwareDeploymentStartX = 500 # X position for the right column
    $currentY_Software = $pictureBox.Bottom + 20 # Align with OS Deployment title

    # Software Deployment Title
    $labelSoftwareDeploymentTitle = New-Object System.Windows.Forms.Label
    $labelSoftwareDeploymentTitle.Text = "Software Selection"
    $labelSoftwareDeploymentTitle.Font = New-Object System.Drawing.Font("Segoe UI", 11, [System.Drawing.FontStyle]::Bold)
    $labelSoftwareDeploymentTitle.AutoSize = $True
    $labelSoftwareDeploymentTitle.BackColor = [System.Drawing.Color]::Transparent
    $form.Controls.Add($labelSoftwareDeploymentTitle)
    $rightColumnWidth = 400
    $labelSoftwareDeploymentTitle.Location = New-Object System.Drawing.Point(($softwareDeploymentStartX + ($rightColumnWidth - $labelSoftwareDeploymentTitle.Width) / 2), $currentY_Software)


    # Selectable Programs for Checkboxes
    $selectablePrograms = @(
        '1Password', '7zip', 'Adobe Acrobat Reader', 'Amazon Corretto',
        'Google Chrome', 'Libre Office', 'Microsoft Office 365', 'Microsoft Teams',
        'Notepad++', 'PDF24', 'PowerToys', 'Total Commander', 'VLC'
    )

    $checkboxY = $labelSoftwareDeploymentTitle.Bottom + 20 # Starting Y for checkboxes, 20px below title
    $checkboxX = $softwareDeploymentStartX + 10 # Starting X for checkboxes

    # Create Checkboxes dynamically and store them in a Hashtable for easy lookup
    $checkboxes = @{}
    foreach ($program in $selectablePrograms) {
        $checkBox = New-Object System.Windows.Forms.CheckBox
        $checkBox.Text = $program
        $checkBox.Location = New-Object System.Drawing.Point($checkboxX, $checkboxY)
        $checkBox.AutoSize = $True
        $form.Controls.Add($checkBox)
        $checkboxes[$program] = $checkBox # Store checkbox by program name
        $checkboxY += 25 # Move down for the next checkbox
    }
    # --- End Software Deployment Section ---


    # --- Buttons ---
    $buttonHeight = 25
    $buttonSpacing = 10
    $totalButtonWidth = 75 + $buttonSpacing + 75

    $buttonY = $form.ClientSize.Height - $buttonHeight - 30
    $buttonOKX = ([int]($form.ClientSize.Width - $totalButtonWidth) / 2)
    $buttonCancelX = $buttonOKX + 75 + $buttonSpacing


    # OK Button
    $buttonOK = New-Object System.Windows.Forms.Button
    $buttonOK.Text = "OK"
    $buttonOK.Location = New-Object System.Drawing.Point($buttonOKX, $buttonY)
    $buttonOK.Size = New-Object System.Drawing.Size(75, 25)
    $form.Controls.Add($buttonOK)

    # Cancel Button
    $buttonCancel = New-Object System.Windows.Forms.Button
    $buttonCancel.Text = "Cancel"
    $buttonCancel.Location = New-Object System.Drawing.Point($buttonCancelX, $buttonY)
    $buttonCancel.Size = New-Object System.Drawing.Size(75, 25)
    $form.Controls.Add($buttonCancel)

    # Event handler for OU ComboBox
    $comboBoxOrgUnit.Add_SelectedIndexChanged({
        $selectedOU = $comboBoxOrgUnit.SelectedItem

        switch ($selectedOU) {
            "OU=Desktop,OU=AA-Standard,OU=Anger,DC=ada-moebel,DC=com" {
                $comboBoxRegion.SelectedItem = "Germany"
                $comboBoxTimeZone.SelectedItem = "Wien"
            }
            "OU=Notebook,OU=AA-Standard,OU=Anger,DC=ada-moebel,DC=com" {
                $comboBoxRegion.SelectedItem = "Germany"
                $comboBoxTimeZone.SelectedItem = "Wien"
            }
            "OU=Computers,OU=RS,DC=ada-moebel,DC=com" {
                $comboBoxRegion.SelectedItem = "Romania"
                $comboBoxTimeZone.SelectedItem = "Bucharest"
            }
            "OU=Desktop,OU=HK-Standard,OU=Koermend,DC=ada-moebel,DC=com" {
                $comboBoxRegion.SelectedItem = "Hungary"
                $comboBoxTimeZone.SelectedItem = "Budapest"
            }
            "OU=Desktop,OU=HN-Standard,OU=Nova,DC=ada-moebel,DC=com" {
                $comboBoxRegion.SelectedItem = "Hungary"
                $comboBoxTimeZone.SelectedItem = "Budapest"
            }
            "OU=Desktop,OU=HZ,DC=ada-moebel,DC=com" {
                $comboBoxRegion.SelectedItem = "Hungary"
                $comboBoxTimeZone.SelectedItem = "Budapest"
            }
            default {
            }
        }
    })

    # Event handler for Role ComboBox to automatically select programs
    $roleSelectionChangeHandler = {
        param($sender, $e)

        Log-Message "Role ComboBox SelectedIndexChanged event triggered."

        foreach ($checkbox in $checkboxes.Values) {
            $checkbox.Checked = $false
        }
        Log-Message "All checkboxes cleared."

        $selectedRoleItem = $comboBoxRole.SelectedItem
        if ($selectedRoleItem -ne $null) {
            $selectedRole = $selectedRoleItem.ToString()
            Log-Message "Role selected in GUI: $selectedRole"

            switch ($selectedRole) {
                "Office" {
                    if ($checkboxes.ContainsKey('7zip')) { $checkboxes['7zip'].Checked = $true; Log-Message "Checked: 7zip" }
                    if ($checkboxes.ContainsKey('Google Chrome')) { $checkboxes['Google Chrome'].Checked = $true; Log-Message "Checked: Google Chrome" }
                    if ($checkboxes.ContainsKey('Microsoft Office 365')) { $checkboxes['Microsoft Office 365'].Checked = $true; Log-Message "Checked: Microsoft Office 365" }
                    if ($checkboxes.ContainsKey('Microsoft Teams')) { $checkboxes['Microsoft Teams'].Checked = $true; Log-Message "Checked: Microsoft Teams" }
                }
                "Production" {
                    if ($checkboxes.ContainsKey('7zip')) { $checkboxes['7zip'].Checked = $true; Log-Message "Checked: 7zip" }
                    if ($checkboxes.ContainsKey('Google Chrome')) { $checkboxes['Google Chrome'].Checked = $true; Log-Message "Checked: Google Chrome" }
                }
                "Test" {
                    Log-Message "Role 'Test' selected, all optional programs remain deselected."
                }
                default {
                    Log-Message "Unknown role '$selectedRole' selected. No programs automatically checked." -Level "WARNING"
                }
            }
        } else {
            Log-Message "No role selected in ComboBox."
        }
    }
    $comboBoxRole.Add_SelectedIndexChanged($roleSelectionChangeHandler)

    $form.Add_Load({
        $roleSelectionChangeHandler.Invoke($comboBoxRole, [System.EventArgs]::Empty)
    })

    # Button event handlers
    $buttonOK.Add_Click({
        $computer_name = $textBoxComputerName.Text.Trim()
        $organization_unit = $comboBoxOrgUnit.SelectedItem
        $region_display_name = $comboBoxRegion.SelectedItem
        $time_zone_display_name = $comboBoxTimeZone.SelectedItem
        $role_selected = $comboBoxRole.SelectedItem

        # Get selected programs
        $selectedProgramsLocal = @()
        foreach ($cb in $checkboxes.Values) {
            if ($cb.Checked) {
                $selectedProgramsLocal += $cb.Text
            }
        }

        # Validation: Is computer name empty?
        if ([string]::IsNullOrWhiteSpace($computer_name)) {
            [System.Windows.Forms.MessageBox]::Show("A számítógép név nem lehet üres!", "Hiba", [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Error)
            return
        }

        # Validation: Invalid characters in computer name
        if ($computer_name -match '[\\/:*?"<>|]') {
            [System.Windows.Forms.MessageBox]::Show("A számítógép név érvénytelen karaktereket tartalmaz! Kérem használjon csak betűket, számokat és kötőjelet.", "Hiba", [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Error)
            return
        }

        # Validation: Organization Unit selection is mandatory
        if ([string]::IsNullOrEmpty($organization_unit)) {
            [System.Windows.Forms.MessageBox]::Show("Kérem válasszon Szervezeti Egységet!", "Hiba", [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Error)
            return
        }

        # Validation: Role selection is mandatory
        if ([string]::IsNullOrEmpty($role_selected)) {
            [System.Windows.Forms.MessageBox]::Show("Kérem válasszon Szerepkört!", "Hiba", [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Error)
            return
        }

        # Confirmation MessageBox
        $confirmationMessage = "Kérjük ellenőrizze az alábbi adatokat:`n`n" +
                               "Számítógép neve: $($computer_name)`n" +
                               "Szervezeti egység: $($organization_unit)`n" +
                               "Régió: $($region_display_name)`n" +
                               "Időzóna (GUI): $($time_zone_display_name)`n" +
                               "Szerepkör: $($role_selected)`n" +
                               "Telepítendő szoftverek: $($($selectedProgramsLocal -join ', ') -replace '^$', 'Nincs kiválasztva')`n`n" +
                               "Szeretné folytatni?"

        $confirmationResult = [System.Windows.Forms.MessageBox]::Show($confirmationMessage, "Adatok ellenőrzése", [System.Windows.Forms.MessageBoxButtons]::OKCancel, [System.Windows.Forms.MessageBoxIcon]::Question)

        if ($confirmationResult -eq [System.Windows.Forms.DialogResult]::Cancel) {
            $form.DialogResult = [System.Windows.Forms.DialogResult]::Cancel
            $form.Close()
            return
        }

        # --- Folder check and creation ---
        $outputFolderPath = "C:\Temp"
        if (-not (Test-Path $outputFolderPath)) {
            try {
                New-Item -Path $outputFolderPath -ItemType Directory -Force | Out-Null
            } catch {
                [System.Windows.Forms.MessageBox]::Show("Hiba a 'C:\Temp' mappa létrehozása során:`n$($_.Exception.Message)", "Hiba", [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Error)
                $form.DialogResult = [System.Windows.Forms.DialogResult]::Cancel
                $form.Close()
                return
            }
        }

        # --- Save values to file ---
        $ouOutputPath = Join-Path -Path $outputFolderPath -ChildPath "enroll-organization.txt"
        try { Set-Content -Path $ouOutputPath -Value $organization_unit -Force; Log-Message "Saved OU: $organization_unit to $ouOutputPath" }
        catch { [System.Windows.Forms.MessageBox]::Show("Hiba az OU fájlba írása során:`n$($_.Exception.Message)", "Hiba", [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Error); $form.DialogResult = [System.Windows.Forms.DialogResult]::Cancel; $form.Close(); return }

        $computerNameOutputPath = Join-Path -Path $outputFolderPath -ChildPath "enroll-computer-name.txt"
        try { Set-Content -Path $computerNameOutputPath -Value $computer_name -Force; Log-Message "Saved Computer Name: $computer_name to $computerNameOutputPath" }
        catch { [System.Windows.Forms.MessageBox]::Show("Hiba a számítógép név fájlba írása során:`n$($_.Exception.Message)", "Hiba", [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Error); $form.DialogResult = [System.Windows.Forms.DialogResult]::Cancel; $form.Close(); return }

        $regionCode = ""
        switch ($region_display_name) {
            "Germany" { $regionCode = "de-DE" }
            "Hungary" { $regionCode = "hu-HU" }
            "Romania" { $regionCode = "en-US" }
        }
        if (-not [string]::IsNullOrEmpty($regionCode)) {
            $regionOutputPath = Join-Path -Path $outputFolderPath -ChildPath "enroll-region.txt"
            try { Set-Content -Path $regionOutputPath -Value $regionCode -Force; Log-Message "Saved Region Code: $regionCode to $regionOutputPath" }
            catch { [System.Windows.Forms.MessageBox]::Show("Hiba a régió fájlba írása során:`n$($_.Exception.Message)", "Hiba", [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Error); $form.DialogResult = [System.Windows.Forms.DialogResult]::Cancel; $form.Close(); return }
        }

        $keyboardLayoutsArray = @()
        switch ($region_display_name) {
            "Germany" { $keyboardLayoutsArray = @("00000407", "00000409", "0000040e") }
            "Hungary" { $keyboardLayoutsArray = @("0000040e", "00000409", "00000407") }
            "Romania" { $keyboardLayoutsArray = @("00000409", "00000407", "0000040e") }
        }
        if ($keyboardLayoutsArray.Count -gt 0) {
            $keyboardLayoutOutputPath = Join-Path -Path $outputFolderPath -ChildPath "enroll-keyboard-layout.txt"
            try { Set-Content -Path $keyboardLayoutOutputPath -Value ($keyboardLayoutsArray -join ',') -Force; Log-Message "Saved Keyboard Layouts: $($keyboardLayoutsArray -join ',') to $keyboardLayoutOutputPath" }
            catch { [System.Windows.Forms.MessageBox]::Show("Hiba a billentyűzetkiosztás fájlba írása során:`n$($_.Exception.Message)", "Hiba", [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Error); $form.DialogResult = [System.Windows.Forms.DialogResult]::Cancel; $form.Close(); return }
        }

        $homeLocationCode = ""
        switch ($region_display_name) {
            "Germany" { $homeLocationCode = "14" }
            "Hungary" { $homeLocationCode = "109" }
            "Romania" { $homeLocationCode = "200" }
        }
        if (-not [string]::IsNullOrEmpty($homeLocationCode)) {
            $homeLocationOutputPath = Join-Path -Path $outputFolderPath -ChildPath "enroll-home-location.txt"
            try { Set-Content -Path $homeLocationOutputPath -Value $homeLocationCode -Force; Log-Message "Saved Home Location: $homeLocationCode to $homeLocationOutputPath" }
            catch { [System.Windows.Forms.MessageBox]::Show("Hiba a home location fájlba írása során:`n$($_.Exception.Message)", "Hiba", [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Error); $form.DialogResult = [System.Windows.Forms.DialogResult]::Cancel; $form.Close(); return }
        }

        $timeZoneID = ""
        switch ($time_zone_display_name) {
            "Wien" { $timeZoneID = "W. Europe Standard Time" }
            "Budapest" { $timeZoneID = "Central Europe Standard Time" }
            "Bucharest" { $timeZoneID = "GTB Standard Time" }
        }
        if (-not [string]::IsNullOrEmpty($timeZoneID)) {
            $timeZoneOutputPath = Join-Path -Path $outputFolderPath -ChildPath "enroll-time-zone.txt"
            try { Set-Content -Path $timeZoneOutputPath -Value $timeZoneID -Force; Log-Message "Saved Time Zone ID: $timeZoneID to $timeZoneOutputPath" }
            catch { [System.Windows.Forms.MessageBox]::Show("Hiba az időzóna fájlba írása során:`n$($_.Exception.Message)", "Hiba", [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Error); $form.DialogResult = [System.Windows.Forms.DialogResult]::Cancel; $form.Close(); return }
        }

        $ninjaRoleOutputPath = Join-Path -Path $outputFolderPath -ChildPath "enroll-ninja1.txt"
        try { Set-Content -Path $ninjaRoleOutputPath -Value $role_selected -Force; Log-Message "Saved Role: $role_selected to $ninjaRoleOutputPath" }
        catch { [System.Windows.Forms.MessageBox]::Show("Hiba a NinjaOne szerepkör fájlba írása során:`n$($_.Exception.Message)", "Hiba", [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Error); $form.DialogResult = [System.Windows.Forms.DialogResult]::Cancel; $form.Close(); return }

        # --- Create Configuration Files for Software ---
        $softwareListFile = Join-Path $outputFolderPath "software.txt"
        $wingetListFile = Join-Path $outputFolderPath "software-winget.txt"
        try {
            $wingetMapping = @{
                "1Password"="AgileBits.1Password"; "7zip"="7zip.7zip"; "Adobe Acrobat Reader"="Adobe.Acrobat.Reader.64-bit";
                "Amazon Corretto"="Amazon.Corretto.21.JDK"; "Google Chrome"="Google.Chrome"; "Libre Office"="TheDocumentFoundation.LibreOffice";
                "Notepad++"="Notepad++.Notepad++"; "PDF24"="geeksoftwareGmbH.PDF24Creator";
                "PowerToys"="Microsoft.PowerToys"; "Total Commander"="Ghisler.TotalCommander"; "VLC"="VideoLAN.VLC"
            }
            $wingetPackages = [System.Collections.Generic.List[string]]::new()
            $specialSoftware = [System.Collections.Generic.List[string]]::new()
            $selectedSoftwareNamesForLog = [System.Collections.Generic.List[string]]::new()

            Log-Message "Processing selected programs for file saving..."
            foreach ($item in $checkboxes.GetEnumerator()) {
                if ($item.Value.Checked) {
                    $programName = $item.Key
                    $selectedSoftwareNamesForLog.Add($programName)
                    if ($programName -eq 'Microsoft Office 365' -or $programName -eq 'Microsoft Teams') {
                        $specialSoftware.Add($programName); Log-Message "Program '$programName' marked for special handling (software.txt)."
                    } else {
                        if ($wingetMapping.ContainsKey($programName)) {
                            $wingetId = $wingetMapping[$programName]
                            if (-not [string]::IsNullOrWhiteSpace($wingetId)) { $wingetPackages.Add($wingetId); Log-Message "Mapped '$programName' to Winget ID '$wingetId' (software-winget.txt)." }
                            else { Log-Message "WARNING: Winget mapping found for '$programName' but the ID is empty. Skipping." }
                        } else { Log-Message "WARNING: Winget mapping not found for '$programName'. It won't be added to software-winget.txt." }
                    }
                }
            }

            if ($selectedSoftwareNamesForLog.Count -gt 0) { Log-Message "User selected programs: $($selectedSoftwareNamesForLog -join ', ')" }
            else { Log-Message "No optional software selected by user." }

            if (Test-Path $softwareListFile) { Remove-Item $softwareListFile -Force }
            if ($specialSoftware.Count -gt 0) { $specialSoftware | Out-File $softwareListFile -Encoding UTF8 -ErrorAction Stop; Log-Message "Special handling software saved to: $softwareListFile - Programs: $($specialSoftware -join ', ')" }
            else { Log-Message "No software selected for special handling. $softwareListFile is empty or not created." }

            if (Test-Path $wingetListFile) { Remove-Item $wingetListFile -Force }
            if ($wingetPackages.Count -gt 0) { $wingetPackages | Out-File $wingetListFile -Encoding UTF8 -ErrorAction Stop; Log-Message "Winget package IDs saved to: $wingetListFile - Packages: $($wingetPackages -join ', ')" }
            else { Log-Message "No software with valid Winget mapping selected. $wingetListFile is empty or not created." }

        } catch {
            Log-Message "ERROR: Failed to create software list files in '$outputFolderPath'. Error: $($_.Exception.Message)"; [System.Windows.Forms.MessageBox]::Show("Failed to create software list files in C:\Temp.", "File Error", [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Error)
            $form.DialogResult = [System.Windows.Forms.DialogResult]::Cancel
            $form.Close()
            return
        }
        # --- End Create Configuration Files for Software ---

        [System.Windows.Forms.MessageBox]::Show("Az adatok mentésre kerültek a C:\Temp mappába.", "Befejezve", [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Information)
        $form.DialogResult = [System.Windows.Forms.DialogResult]::OK # Set DialogResult to OK on successful save
        $form.Close()
    })

    $buttonCancel.Add_Click({
        $form.DialogResult = [System.Windows.Forms.DialogResult]::Cancel # Set DialogResult to Cancel
        $form.Close()
    })

    $form.ShowDialog() # Display the GUI and wait for user interaction

    return ($form.DialogResult -eq [System.Windows.Forms.DialogResult]::OK)
}
# --- End GUI Function Definition ---


# --- OSDCloud Installation Function ---
function Invoke-OSDCloudInstallation {
    param (
        [Parameter(Mandatory = $true)]
        [string]$OSLanguage,

        [Parameter(Mandatory = $true)]
        [string]$Type, # 'Offline' or 'Online'

        [string]$ESDName = $null # Only required for offline
    )

    # --- Robust OSDCloud Module Check ---
    if (-not (Get-Module -ListAvailable -Name OSDCloud)) {
        Write-Host ""
        Write-Host "======================================================================" -ForegroundColor Red
        Write-Host "CRITICAL ERROR: OSDCloud module is not installed or discoverable." -ForegroundColor Red
        Write-Host "Please run the following commands in an ADMINISTRATOR PowerShell session FIRST:" -ForegroundColor Red
        Write-Host "" -ForegroundColor Red
        Write-Host "    Install-Module -Name PowerShellGet -Force -AllowClobber -Scope CurrentUser" -ForegroundColor Red
        Write-Host "    Install-Module -Name OSDCloud -Force -Confirm:`$false" -ForegroundColor Red
        Write-Host "" -ForegroundColor Red
        Write-Host "Then try running this main script again." -ForegroundColor Red
        Write-Host "======================================================================" -ForegroundColor Red
        Start-Sleep -Seconds 10
        return $false # Indicate failure to the calling script
    }

    # If the module is found, import it.
    try {
        Import-Module OSDCloud -ErrorAction Stop
        Write-Host "OSDCloud module loaded successfully." -ForegroundColor Green
    } catch {
        Write-Error "ERROR: Failed to load OSDCloud module even after detection. Check permissions or module integrity. $($_.Exception.Message)"
        return $false
    }
    # --- End Robust OSDCloud Module Check ---


    $OSName = 'Windows 11 24H2 x64'
    $OSEdition = 'Enterprise'
    $OSActivation = 'Volume'

    # Set OSDCloud Global Variables
    $Global:MyOSDCloud = [ordered]@{
        Restart               = [bool]$False # OSDCloud usually handles restarts, setting to False for control
        RecoveryPartition     = [bool]$true
        OEMActivation         = [bool]$True
        WindowsUpdate         = [bool]$false
        WindowsUpdateDrivers  = [bool]$false
        WindowsDefenderUpdate = [bool]$false
        SetTimeZone           = [bool]$false # TimeZone will be set by a later script based on GUI data
        ClearDiskConfirm      = [bool]$False
        ShutdownSetupComplete = [bool]$false
        SyncMSUpCatDriverUSB  = [bool]$true
        CheckSHA1             = [bool]$true
    }

    Write-SectionHeader "OSDCloud Variables for $($OSLanguage) $($Type) Installation"
    Write-Output $Global:MyOSDCloud

    Write-SectionHeader -Message "Starting OSDCloud for $($OSLanguage) $($Type) Installation"

    try {
        if ($Type -eq 'Offline') {
            if (-not $ESDName) {
                Write-Host "Error: ESDName is required for offline installation." -ForegroundColor Red
                return $false # Indicate failure for the main script
            }
            $imageFilePath = '\OSDCloud\OS\' # This should be a network share path accessible in WinPE

            Write-Host "Searching for OSDCloud image file: $ESDName at $imageFilePath" -ForegroundColor Cyan
            # Actual OSDCloud function call
            $ImageFileItem = Find-OSDCloudFile -Name $ESDName -Path $imageFilePath -ErrorAction Stop

            if ($ImageFileItem) {
                $Global:MyOSDCloud.ImageFileItem = $ImageFileItem
                $Global:MyOSDCloud.ImageFileName = $ImageFileItem.Name
                $Global:MyOSDCloud.ImageFileFullName = $ImageFileItem.FullName
                $Global:MyOSDCloud.OSImageIndex = 1 # Assuming default index 1, adjust if needed

                Write-Host "Executing Start-OSDCloud for Offline Deployment..." -ForegroundColor Green
                # Actual OSDCloud function call
                Start-OSDCloud -ImageFileUrl $ImageFileItem.FullName -ImageIndex 1 -Zti $true -ErrorAction Stop
                Write-SectionHeader -Message "OSDCloud Offline Process Complete."
                
                # In a real ZTI (Zero Touch Installation) scenario, you might want to restart immediately.
                # Keep this commented out if you need the GUI to run first, then a final restart.
                # Restart-Computer -Force 
            } else {
                Write-Host "Error: Image file $ESDName not found or accessible at $imageFilePath." -ForegroundColor Red
                return $false # Indicate failure
            }
        } elseif ($Type -eq 'Online') {
            Write-Host "Executing Start-OSDCloud for Online Deployment..." -ForegroundColor Green
            # Actual OSDCloud function call
            Start-OSDCloud -OSName $OSName -OSEdition $OSEdition -OSActivation $OSActivation -OSLanguage $OSLanguage -ErrorAction Stop
            Write-SectionHeader -Message "OSDCloud Online Process Complete."
        }
    } catch {
        Write-Error "ERROR during OSDCloud installation: $($_.Exception.Message)"
        return $false # Indicate failure
    }
    return $true # Indicate success
}


#============================================================
cls # Clear the console screen
Write-Host "================ Main Menu ==================" -ForegroundColor Yellow
Write-Host " "
Write-Host "=============================================" -ForegroundColor Yellow
Write-Host "========== ADA Mobelfabrik GMBH =============" -ForegroundColor Yellow
Write-Host "=============================================`n" -ForegroundColor Yellow
Write-Host "`n" # Empty line before the menu
Write-Host "1: Windows 11 24H2 | English | Enterprise | Offline Installer" -ForegroundColor Yellow
Write-Host "2: Windows 11 24H2 | German | Enterprise | Offline Installer" -ForegroundColor Yellow
Write-Host "3: Windows 11 24H2 | Hungarian | Enterprise | Offline Installer" -ForegroundColor Yellow
Write-Host "4: Windows 11 24H2 | English | Enterprise | Online Installer" -ForegroundColor Yellow
Write-Host "5: Windows 11 24H2 | German | Enterprise | Online Installer" -ForegroundColor Yellow
Write-Host "6: Windows 11 24H2 | Hungarian | Enterprise | Online Installer" -ForegroundColor Yellow
Write-Host "7: Exit`n"-ForegroundColor Yellow

Write-Host "`n DISCLAIMER: USE AT YOUR OWN RISK - Going further will erase all data on your disk ! `n"-ForegroundColor Red

$selection = Read-Host "Please make a selection"

switch ($selection)
{
    '1' {
        Write-Host "Initiating OS deployment (English, Offline)..." -ForegroundColor Green
        if (Invoke-OSDCloudInstallation -OSLanguage 'en-US' -Type 'Offline' -ESDName 'windows11-24h2-en.esd') {
            Write-Host "OSDCloud process completed successfully. Opening data entry GUI..." -ForegroundColor Green
            Show-DeploymentGUI # Call GUI after OSDCloud completes
        } else {
            Write-Host "OSDCloud installation failed or was aborted. Skipping GUI and exiting." -ForegroundColor Red
            Start-Sleep -Seconds 5
            exit 1 # Exit with error code
        }
    }
    '2' {
        Write-Host "Initiating OS deployment (German, Offline)..." -ForegroundColor Green
        if (Invoke-OSDCloudInstallation -OSLanguage 'de-DE' -Type 'Offline' -ESDName 'windows11-24h2-de.esd') {
            Write-Host "OSDCloud process completed successfully. Opening data entry GUI..." -ForegroundColor Green
            Show-DeploymentGUI
        } else {
            Write-Host "OSDCloud installation failed or was aborted. Skipping GUI and exiting." -ForegroundColor Red
            Start-Sleep -Seconds 5
            exit 1
        }
    }
    '3' {
        Write-Host "Initiating OS deployment (Hungarian, Offline)..." -ForegroundColor Green
        if (Invoke-OSDCloudInstallation -OSLanguage 'hu-HU' -Type 'Offline' -ESDName 'windows11-24h2-hu.esd') {
            Write-Host "OSDCloud process completed successfully. Opening data entry GUI..." -ForegroundColor Green
            Show-DeploymentGUI
        } else {
            Write-Host "OSDCloud installation failed or was aborted. Skipping GUI and exiting." -ForegroundColor Red
            Start-Sleep -Seconds 5
            exit 1
        }
    }
    '4' {
        Write-Host "Initiating OS deployment (English, Online)..." -ForegroundColor Green
        if (Invoke-OSDCloudInstallation -OSLanguage 'en-US' -Type 'Online') {
            Write-Host "OSDCloud process completed successfully. Opening data entry GUI..." -ForegroundColor Green
            Show-DeploymentGUI
        } else {
            Write-Host "OSDCloud installation failed or was aborted. Skipping GUI and exiting." -ForegroundColor Red
            Start-Sleep -Seconds 5
            exit 1
        }
    }
    '5' {
        Write-Host "Initiating OS deployment (German, Online)..." -ForegroundColor Green
        if (Invoke-OSDCloudInstallation -OSLanguage 'de-DE' -Type 'Online') {
            Write-Host "OSDCloud process completed successfully. Opening data entry GUI..." -ForegroundColor Green
            Show-DeploymentGUI
        } else {
            Write-Host "OSDCloud installation failed or was aborted. Skipping GUI and exiting." -ForegroundColor Red
            Start-Sleep -Seconds 5
            exit 1
        }
    }
    '6' {
        Write-Host "Initiating OS deployment (Hungarian, Online)..." -ForegroundColor Green
        if (Invoke-OSDCloudInstallation -OSLanguage 'hu-HU' -Type 'Online') {
            Write-Host "OSDCloud process completed successfully. Opening data entry GUI..." -ForegroundColor Green
            Show-DeploymentGUI
        } else {
            Write-Host "OSDCloud installation failed or was aborted. Skipping GUI and exiting." -ForegroundColor Red
            Start-Sleep -Seconds 5
            exit 1
        }
    }
    '7' {
        Write-Host "Exiting script. Goodbye!" -ForegroundColor Green
        exit 0
    }
    default {
        Write-Host "Invalid selection. Please enter a number between 1 and 7." -ForegroundColor Red
        Start-Sleep -Seconds 2
        exit 1
    }
}