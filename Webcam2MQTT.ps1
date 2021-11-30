$topic= "MyPC/Webcam"
$mqtthost = "mqtt.example.com"
$mqttLogin = "MQTTLogin"
$mqttPass= "MQTTPass"
cd -path "c:\lib\M2Mqtt.*\lib\net45"
add-type -path "M2Mqtt.Net.dll"

####################################################
$MqttClient = [uPLibrary.Networking.M2Mqtt.MqttClient]($mqtthost)
$lastsend = (get-date).AddSeconds(-120)


while ($true){
$isON = ((ls -path Registry::HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\webcam\NonPackaged\| Get-ItemProperty | ? LastUsedTimeStop -eq "0") -ne $null)
$mqttclient.Connect([guid]::NewGuid(), $null, $null, 0, 0, 1, $topic, "Test", 1, $false )|Out-Null
$mqttclient.Connect([guid]::NewGuid(), "$mqttlogin","$mqttpass")|Out-Null
$delta = ((get-date)-$lastsend).totalseconds
if (($isON -eq $true -and $delta -gt 240 ) -or ($isON -eq $true -and $isOFF -eq $true )){

$MqttClient.Publish($topic, [System.Text.Encoding]::UTF8.GetBytes("ON"))|Out-Null
$isOFF = $false
$send = $false
$lastsend = (get-date)
}
Elseif ($isON -eq $false -and $delta -lt 240 -and $send -eq $false ) {

$MqttClient.Publish($topic, [System.Text.Encoding]::UTF8.GetBytes("OFF")) |Out-Null
$isOFF = $true
$send = $true
}
$MqttClient.Disconnect()
Start-Sleep -Seconds 5
}

