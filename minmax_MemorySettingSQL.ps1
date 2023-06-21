# check for SQL Server installation
$SqlServerInstalled = Get-WmiObject -Class Win32_Service | Where-Object { $_.Name -eq 'MSSQLSERVER' }
if (-not $SqlServerInstalled) {
    Write-Warning "SQL Server is not installed on this machine. The script will now exit."
    exit
}

# get host memory and calculate memory settings
$TotalMemory = Get-CimInstance Win32_PhysicalMemory | Measure-Object -Property Capacity -Sum | Select-Object -ExpandProperty Sum
$MinMemory = [math]::Round($TotalMemory * 0.1 / 1MB)
$MaxMemory = [math]::Round($TotalMemory * 0.9 / 1MB)

# set memory settings using SQLCMD
$SqlCmdPath = Join-Path $env:ProgramFiles 'Microsoft SQL Server\150\Tools\Binn\SQLCMD.EXE'
if (-not (Test-Path $SqlCmdPath)) {
    Write-Warning "SQLCMD.EXE is not installed on this machine. The script will now exit."
    exit
}
$SqlCmdOptions = "-E -S localhost"
if (Get-SqlInstance | Where-Object { $_.Version.Major -eq 15 }) {
    $SqlCmdOptions += " -Q 'EXEC sys.sp_configure N''show advanced options'', N''1''; RECONFIGURE WITH OVERRIDE; EXEC sys.sp_configure N''max server memory (MB)'', N''$MaxMemory''; RECONFIGURE WITH OVERRIDE; EXEC sys.sp_configure N''min server memory (MB)'', N''$MinMemory''; RECONFIGURE WITH OVERRIDE;'"
}
elseif (Get-SqlInstance | Where-Object { $_.Version.Major -eq 14 }) {
    $SqlCmdOptions += " -Q 'EXEC sp_configure N''show advanced options'', N''1''; RECONFIGURE WITH OVERRIDE; EXEC sp_configure N''max server memory (MB)'', N''$MaxMemory''; RECONFIGURE WITH OVERRIDE; EXEC sp_configure N''min server memory (MB)'', N''$MinMemory''; RECONFIGURE WITH OVERRIDE;'"
}
else {
    Write-Warning "SQL Server Management Studio version 18 or 19 is not installed on this machine. The script will now exit."
    exit
}
Start-Process -FilePath $SqlCmdPath -ArgumentList $SqlCmdOptions -Wait

# output memory settings
Write-Host "Minimum server memory set to $MinMemory MB"
Write-Host "Maximum server memory set to $MaxMemory MB"
