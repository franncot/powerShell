Write-Host "";
Write-Host " ===== VDA Validation is starting ====="
Write-Host "";

# Check if Microsoft Visual Studio 2017 is installed
$vs2017 = Get-ItemProperty -path "HKLM:\SOFTWARE\WOW6432Node\Microsoft\VisualStudio\SxS\VS7" -name "15.0" -ErrorAction SilentlyContinue
if (-not $vs2017) {
    Write-Host -ForegroundColor Red -BackgroundColor Yellow -NoNewline "  ERROR: Please install Microsoft Visual Studio 2017"
    Write-Host "";
}
else {
    Write-Host "";
    Write-Host -ForegroundColor Green -NoNewline "  PASS: Visual studio 2017 is Installed"
    Write-Host "";
}

#Check if Visual studio 2017 is the default compiler
$compiler = select-string -path "C:\ProgramData\Runtime.config.xml" -Pattern "msdev2017.config.xml" 
if (-not $compiler) {
    Write-Host "";
    Write-Host -ForegroundColor Red -BackgroundColor Yellow -NoNewline "  ERROR: Please change the compiler version on  Professional settings "
    Write-Host "";
}
else {
    Write-Host "";
    Write-Host -ForegroundColor Green -NoNewline  "  PASS: Compiler version is VS 2017"
    Write-Host "";
}

# Check if the registry key "HKEY_CURRENT_USER\SOFTWARE\some\some1\RunMachineSelection" exists and has data
$regKey = Get-ItemProperty -path "Registry::HKEY_CURRENT_USER\Software\RunMachineSelection" -Name "Details" -ErrorAction SilentlyContinue
if (-not $regKey) {
    Write-Host "";
    Write-Host -ForegroundColor Red -BackgroundColor Yellow -NoNewline "  ERROR: Please add the PPC machines to the GPOs"
    Write-Host "";
}
else {
    Write-Host "";
    Write-Host -ForegroundColor Yellow -NoNewline  "  Warning: PPC machines are setup, but verify the name is correct and CPU details as ACL describes"
    Write-Host "";
}

# Check if the file c:\programdata\software\suite\system.config contains the word "TempData"
#$file = Get-Content "C:\ProgramData\Suite\\System.config.xml"
$sysconfg1 = select-string -path "C:\ProgramData\System.config.xml" -Pattern "TempData" 
if ($sysconfg1 -notmatch "TempData") {
    Write-Host "";
    Write-Host -ForegroundColor Red -BackgroundColor Yellow -NoNewline "  ERROR: Please update system.config tmp folder under C:\ProgramData\Suite\System.config.xml "
    Write-Host "";
}
else {
    Write-Host "";
    Write-Host -ForegroundColor Green -NoNewline  "  PASS: System.config file has  tmp folder configurated!"
    Write-Host "";
}

$sysconfg2 = select-string -path "C:\ProgramData\System.config.xml" -Pattern "false" 
if ($sysconfg2 -notmatch "false") {
    Write-Host "";
    Write-Host -ForegroundColor Red -BackgroundColor Yellow -NoNewline "  ERROR: Please update interactive-mode to false under C:\ProgramData\Suite\System.config.xml "
    Write-Host "";
}
else {
    Write-Host "";
    Write-Host -ForegroundColor Green -NoNewline  "  PASS: System config interactive-mode is setup!"
    Write-Host "";
}

$guixml = select-string -path "C:\ProgramData\config.xml" -Pattern "false" 
if ($guixml -notmatch "false") {
    Write-Host "";
    Write-Host -ForegroundColor Red -BackgroundColor Yellow -NoNewline "  ERROR: Please update ShowHomepage to false under C:\ProgramData\config.xml "
    Write-Host "";
}
else {
    Write-Host "";
    Write-Host -ForegroundColor Green -NoNewline  "  PASS:  GUI Home Page is disabled" 
    Write-Host "";
}
#Validate if Web Certicate is installed
$Cert = Get-ChildItem Cert:\LocalMachine\Root | Where-Object { $_.Issuer -like "*IWKS*" } 
if ($Cert) {
    Write-Host "";
    Write-Host -ForegroundColor Green -NoNewline  "  PASS: Webserver certificate is installed"
    Write-Host "";
} else {
    Write-Host "";
    Write-Host -ForegroundColor Red -BackgroundColor Yellow -NoNewline "  ERROR: Please install Webserver certificate "
    Write-Host "";
}

#Checking if web is added to trusted sites
$IESet = (get-item "HKLM:\SOFTWARE\Policies\Microsoft\Windows\CurrentVersion\Internet Settings\ZoneMapKey").property | select-string "" 
if ($IESet) {
    Write-Host "";
    Write-Host -ForegroundColor Green -NoNewline  "  PASS: -web is set as a Trusted Sites zone"
    Write-Host "";
} else {
    Write-Host "";
    Write-Host -ForegroundColor Red -BackgroundColor Yellow -NoNewline "  ERROR: Please add -web url to the Trusted site zone via GPO "
    Write-Host "";
}

# Check if 7zip is installed
$zipPath = "C:\Program Files\7-Zip\7z.exe" 
if (Test-Path $zipPath) {
    Write-Host "";
    Write-Host -ForegroundColor Green -NoNewline  "  PASS: 7-Zip is Installed"
    Write-Host "";
} else {
    Write-Host "";
    Write-Host -ForegroundColor Red -BackgroundColor Yellow -NoNewline "  ERROR: Install 7-ZIP "
    Write-Host "";
}

# Check if Notepad++ is installed
$nppPath = "C:\Program Files\Notepad++\notepad++.exe" 
if (Test-Path $nppPath) {
    Write-Host "";
    Write-Host -ForegroundColor Green -NoNewline  "  PASS: Notepad++ is Installed"
    Write-Host "";
} else {
    Write-Host "";
    Write-Host -ForegroundColor Red -BackgroundColor Yellow -NoNewline "  ERROR: Install Notepad++ "
    Write-Host "";
}

# Check if Adobe Reader is installed
$adobePath = (Get-ItemProperty "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\App Paths\AcroRd32.exe" -ErrorAction SilentlyContinue).Path
if ($adobePath) {
    Write-Host "";
    Write-Host -ForegroundColor Green -NoNewline  "  PASS: Adobe is Installed"
    Write-Host -NoNewline " ";
} else {
    Write-Host "";
    Write-Host -ForegroundColor Red -BackgroundColor Yellow -NoNewline "  ERROR: Install Adobe "
    Write-Host "";
}

#Check if excel is installed
$excelPath = (Get-ItemProperty "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\App Paths\excel.exe" -ErrorAction SilentlyContinue).'(default)' 
if ($excelPath) {
	$excelVersion = (Get-Item $excelPath).VersionInfo.ProductVersion
	Write-Host "";
	Write-Host "";
    Write-Host -ForegroundColor Green -NoNewline "  PASS: Excel is installed, version $excelVersion"
	Write-Host "";
} else {
    Write-Host "";
	Write-Host -ForegroundColor Red -BackgroundColor Yellow -NoNewline  "  ERROR: Excel is not installed."
	Write-Host "";
}

#Check if excel reporting is installed
$excelReporting = "C:\Program Files\Suite\Excel Reporting"
if (Test-Path $excelReporting -PathType Container) {
    Write-Host "";
    Write-Host -ForegroundColor Green -NoNewline  "  PASS: Excel Plugin is Installed"
    Write-Host
} else {
    Write-Host "";
    Write-Host -ForegroundColor Red -BackgroundColor Yellow -NoNewline "  ERROR: Please install Excel plugin if required "
	Write-Host
}

#Check if Google chrome is installed
if (Test-Path "$env:LOCALAPPDATA\Google\Chrome\Application\chrome.exe") {
	Write-Host
    Write-Host -ForegroundColor Green -NoNewline "  PASS: Google Chrome is installed on User directory"
    Write-Host
}
else {
    Write-Host
	Write-Host -ForegroundColor Red -BackgroundColor Yellow -NoNewline "  ERROR: Please install Google Chrome"
    Write-Host
}

#Check if Google chrome is installed
if (Test-Path "C:\Program Files\Google\Chrome\Application\chrome.exe") {
	Write-Host
    Write-Host -ForegroundColor Green -NoNewline "  PASS: Google Chrome is installed "
    Write-Host
}
else {
    Write-Host
	Write-Host -ForegroundColor Red -BackgroundColor Yellow -NoNewline "  ERROR: Please install Google Chrome"
    Write-Host
}

#check if SSMS is installed
$ssmsInstallDir = "$env:ProgramFiles (x86)\Microsoft SQL Server Management Studio 18" 
if (Test-Path $ssmsInstallDir) {
	Write-Host
    Write-Host -ForegroundColor Green -NoNewline "  PASS: SQL Server Management Studio is installed"
    Write-Host
} else {
	Write-Host
    Write-Host -ForegroundColor Red -BackgroundColor Yellow -NoNewline "  ERROR: Please install SQL Server Management Studio"
    Write-Host
}

$xpsViewer = "$env:ProgramFiles\Windows Photo Viewer\ImagingDevices.exe" 
if  (Test-Path $xpsViewer) {
	Write-Host
    Write-Host -ForegroundColor Green -NoNewline "  PASS: XPS viewer is installed"
    Write-Host
} else {
	Write-Host
    Write-Host -ForegroundColor Red -BackgroundColor Yellow -NoNewline "  ERROR: XPS Viewer not installed"
    Write-Host
}


try { 
    $socket = New-Object System.Net.Sockets.TcpClient('localhost',445)
	Write-Host
    Write-Host -ForegroundColor Green -NoNewline "  PASS: Telnet is Installed"
    Write-Host
    $socket.Close()
} catch {
	Write-Host
    Write-Host -ForegroundColor Red -BackgroundColor Yellow -NoNewline "  ERROR: Telnet not installed"
    Write-Host
}

if  (Get-Module -ListAvailable -Name sqlserver) {
	Write-Host
    Write-Host -ForegroundColor Green -NoNewline "  PASS: SQL server module is installed"
    Write-Host
} else {
	Write-Host
    Write-Host -ForegroundColor Red -BackgroundColor Yellow -NoNewline "  ERROR: SQL Server module not installed"
    Write-Host
}

#RSAT-AD Installed and having and Identity attached
$featureName = "RSAT-AD-Powershell" 
$feature = Get-WindowsFeature $featureName -ErrorAction SilentlyContinue
if ($feature ) {
	Write-Host
    Write-Host -ForegroundColor Green -NoNewline "  PASS: '$featureName' is installed"
	Write-Host

    if ($feature.Identity) {
		Write-Host
        Write-Host -ForegroundColor Green -NoNewline "  PASS: '$featureName' feature has the following identity: $($feature.Identity)"
		Write-Host
    }
    else {
		Write-Host
        Write-Host -ForegroundColor Red -BackgroundColor Yellow -NoNewline "  ERROR: '$featureName' feature is installed but test the SVC account."
		Write-Host
    }
}
else {
	Write-Host
    Write-Host -ForegroundColor Red -BackgroundColor Yellow -NoNewline "  ERROR: '$featureName' feature is not installed or is not enabled."
	Write-Host
}

$agentKeyPath = (Get-Itemproperty -path HKLM:\SOFTWARE\VirtualDesktopAgent -Name ListOfDDCs -ErrorAction SilentlyContinue)
if ($agentKeyPath) {
   	Write-Host
    Write-Host -ForegroundColor Green -NoNewline "  PASS:  DDCs are configured."
	Write-Host
} else {
	Write-Host
    Write-Host -ForegroundColor Red -BackgroundColor Yellow -NoNewline "  ERROR:  DDCs are not configured."
	Write-Host
}


$Cvda = Get-WmiObject -Class Win32_Product | Where-Object {$_.Name -like "* Virtual Desktop*"} -ErrorAction SilentlyContinue
if ($Cvda) {
   	Write-Host
    Write-Host -ForegroundColor Green -NoNewline "  PASS:  Virtual Delivery Agent is installed "
   	Write-Host
}
else {
	Write-Host
    Write-Host -ForegroundColor Red -BackgroundColor Yellow -NoNewline "  ERROR:   Virtual Delivery Agent is not installed."
	Write-Host
}


$firewallStatus = Get-NetFirewallProfile | Select-Object -ExpandProperty enabled
if ($firewallStatus -eq "False") {
   	Write-Host
    Write-Host -ForegroundColor Green -NoNewline "  PASS: Windows firewall is disabled "
   	Write-Host
}
else {
	Write-Host
    Write-Host -ForegroundColor Red -BackgroundColor Yellow -NoNewline "  ERROR:  Windows firewall is Enabled"
	Write-Host
}

# Retrieve a list of software with the name ""
Write-Host
Write-Host  -ForegroundColor Green -NoNewline "`n   Suite software Installed with Versions:"
Write-Host
Get-WmiObject -Class Win32_Product | Where-Object {$_.Name -like "**"} -ErrorAction SilentlyContinue | Select-Object Name, Version | Out-Host -Paging



pause