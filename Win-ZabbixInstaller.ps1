param([switch]$Elevated)
function CheckAdmin {
$currentUser = New-Object Security.Principal.WindowsPrincipal $([Security.Principal.WindowsIdentity]::GetCurrent())
$currentUser.IsInRole([Security.Principal.WindowsBuiltinRole]::Administrator)
}
if ((CheckAdmin) -eq $false)  {
if ($elevated)
{
    Write-Warning "You are not running this as local administrator. Run it again in an elevated prompt." ; break
    #   could not elevate, quit
}
 
else {
 
Start-Process powershell.exe -Verb RunAs -ArgumentList ('-noprofile -noexit -file "{0}" -elevated' -f ($myinvocation.MyCommand.Definition))
}
exit
}

#Force argument za skripto, da preskoci ping check
$force=$args[0]
if ($null -ne $force) {
    if ($force.ToString().ToLower() -eq "-force")
    {$force = 1
    }
    else {$force = 0
    }
}

$systemArchitecture = (get-ciminstance CIM_OperatingSystem).OSArchitecture
Write-Host "System architecture is " -NoNewline
Write-host -BackgroundColor Green -ForegroundColor White $systemArchitecture

$file = "$PSScriptRoot\ZabbixAgentInstaller.log"
try 
{

if ($systemArchitecture -eq "64-bit ") {
    $url = "https://cdn.zabbix.com/zabbix/binaries/stable/5.2/5.2.2/zabbix_agent2-5.2.2-windows-amd64-openssl.msi"
    $output = "$PSScriptRoot\zabbix_agent2-5.2.0-windows-amd64-openssl.msi"
    }
else {
    $url = "https://cdn.zabbix.com/zabbix/binaries/stable/5.2/5.2.2/zabbix_agent2-5.2.2-windows-i386-openssl.msi"
    $output = "$PSScriptRoot\zabbix_agent2-5.2.0-windows-i386-openssl.msi"
}

$start_time = Get-Date

Write-Host "Downloading " -NoNewline
Write-host -BackgroundColor Green -ForegroundColor White $systemArchitecture -NoNewline
Write-host "Zabbix Agent..."

Invoke-WebRequest -Uri $url -OutFile $output

Write-Host "Transfer finished."
Write-Output "Time taken: $((Get-Date).Subtract($start_time).Seconds) second(s)"

$hostname = (Hostname).ToString().ToLower()
Write-Host "Server hostname is " $hostname


$proxyAddress = Read-Host -Prompt 'Zabbix Proxy server IP address:'
Write-Host -BackgroundColor Green "Zabbix Proxy server address is: " $proxyAddress
if ((Test-Connection $proxyAddress -Quiet -Count 2 -Delay 2) -eq $true -or $force) {
    Write-Host "Running install..."
    Start-Process msiexec.exe -Wait -ArgumentList "/i $output /l*v log.txt LOGTYPE=file ENABLEREMOTECOMMANDS=1 SERVER=$proxyAddress ENABLEPATH=1 HOSTNAME=$hostname /qn"
    Write-Host -BackgroundColor Green -ForegroundColor White "Installation successfull."
    }
else
    {
    Write-Host -BackgroundColor Red -ForegroundColor White "Zabbix Proxy UNREACHABLE. Ending script."
    }

}
catch {
    $errorOutput = $_
    $errorOutput | Out-File -FilePath $file -Append
    Write-Host -BackgroundColor Red -ForegroundColor White "Error occured. Check script log at $file"
}
Start-Sleep 3