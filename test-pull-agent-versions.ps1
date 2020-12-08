$WebResponse = Invoke-WebRequest "https://cdn.zabbix.com/zabbix/binaries/stable/5.2/5.2.2/"
$WebResponse.Links | Select-Object href | Where-Object {$_.href -like "zabbix_agent2*.msi"}