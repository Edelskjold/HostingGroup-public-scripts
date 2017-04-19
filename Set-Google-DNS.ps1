if (!([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) { Start-Process powershell.exe "-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`"" -Verb RunAs; exit }

Write-Host "######################################################"
Write-Host "#   Starting HostingGroup DNS Setter                 #"
Write-Host "#   Script v. 1.0.0                                  #"
Write-Host "#   Release date: 19/04/2017                         #"
Write-Host "#   Copyright: HostingGroup IVS                      #"
Write-Host "######################################################"


$Connections = netsh interface ipv4 show interfaces | Select-Object -Skip 2 | Where {$_ -match "(\d+)\s+(\S+)\s+(\S+)\s+(\S+)\s+(\S.*)$"} | ForEach{
[PSCustomObject]@{
    'Idx'=$Matches[1]
    'Met'=$Matches[2]
    'MTU'=$Matches[3]
    'State'=$Matches[4]
    'Name'=$Matches[5]
}


netsh interface ipv4 add dnsservers $Matches[5] 8.8.8.8 index=1;
netsh interface ipv4 add dnsservers $Matches[5] 8.8.4.4 index=2;
ipconfig /flushdns
}

