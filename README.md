# win-zabbix-agent-installer
Automatic Windows Zabbix agent installer written in Powershell

Trenutno je fiksno nastavljena namestitev verzije "5.4.7 with OpenSSL".

# Download
Invoke-WebRequest -Uri "https://raw.githubusercontent.com/cohatom/win-zabbix-agent-installer/main/Win-ZabbixInstaller.ps1" -OutFile Win-ZabbixInstaller.ps1

To-DO
- Možnost izbire verzije agenta
- Testiranje delovanja na Windows Server 2012R2, Windows 2016