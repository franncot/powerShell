$servers = @(
"Server71"
"Server72"
"Server73"
"Server74"
"Server75"
"Server76"
"Server77"
"Server78"
"Server79"
"Server80"
"Server81"
"Server82"
"Server83"
"Server84"
"Server85"
"Server86"
"Server87"
"Server88"
"Server89"
"Server90"
"Server91"
"Server92"
"Server93"
"Server94"
)  # Add the server names or IP addresses here 

$configurationXmlPath = "C:\Support\Office\UninstallConfiguration.xml"  #This configuration will be for Unninstall 
$configurationXmlPath2 = "C:\Support\Office\Configuration32.xml"  # This configuration.xml file will be to install

$scriptBlock = {
	Write-Host "Office 2019 uninstallation in progress on $server."
    $officeSetupPath = "C:\Support\Office\setup.exe"  # Update the path to your Office setup.exe file
    $uninstallArgs = "/configure ""$using:configurationXmlPath"""
    Start-Process -FilePath $officeSetupPath -ArgumentList $uninstallArgs -Wait
	Write-Host "Office 2019 uninstallation complete on $server"

 # Execute the silent package.exe program
	Write-Host "Access Data engine  installation in progress on $server."
    $packageExePath = "C:\Support\accessdatabaseengine.exe"
    $packageArgs = "/quiet"
    Start-Process -FilePath $packageExePath -ArgumentList $packageArgs -Wait
	Write-Host "Access Data engine  installation complete on $server."
	
	Write-Host "Office 2019 installation in progress on $server."
    $officeSetupPath2 = "C:\Support\Office\setup.exe"  # setup.exe file with arguments
    $uninstallArgs2 = "/download ""$using:configurationXmlPath2"""
	$uninstallArgs3 = "/configure ""$using:configurationXmlPath2"""
	Start-Process -FilePath $officeSetupPath2 -ArgumentList $uninstallArgs2 -Wait
    Start-Process -FilePath $officeSetupPath2 -ArgumentList $uninstallArgs3 -Wait
	Write-Host "Office 2019 installation complete on $server."


# Reboot 
    Start-Sleep -Seconds 10  # Wait for 10 seconds before rebooting
    shutdown -r -t 00
}

foreach ($server in $servers) {
    Write-Host "Uninstalling Office,Installing Database engine, Re-installling but 32 bit version on $server..."
    Invoke-Command -ComputerName $server -ScriptBlock $scriptBlock
    Write-Host "The server will reboot."
}
