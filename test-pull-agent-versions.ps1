$WebResponse = Invoke-WebRequest "https://cdn.zabbix.com/zabbix/binaries/stable/5.2/5.2.2/"
$WebResponse.Links | Select-Object href -ExpandProperty href | Where-Object {$_.href -like "zabbix_agent2-5.2.2-windows-amd64-openssl.msi"}
$StaticDownloadLink = "https://cdn.zabbix.com/zabbix/binaries/stable/5.2/5.2.2/"

$downloadLink = $StaticDownloadLink + $WebResponse
echo $StaticDownloadLink
echo $WebResponse
#echo $StaticDownloadLink + $WebResponse.
#Write-Output $downloadLink


