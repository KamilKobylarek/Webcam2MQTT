# Webcam2MQTT


## How to install

1. Run this in PowerShell(Admin)

    ````
    invoke-WebRequest "https://dist.nuget.org/win-x86-commandline/latest/nuget.exe" -OutFile "C:\Windows\nuget.exe"  
    nuget sources add -Name "nuget.org" -Source "https://api.nuget.org/v3/index.json"
    nuget install M2Mqtt -o c:\lib
    `````

2. Copy Webcam2MQTT.ps1 to C:\
3. Edit first 4 lines and save

   ````` 
   $topic= "MyPC/Webcam"
   $mqtthost = "mqtt.example.com"
   $mqttLogin = "MQTTLogin"
   $mqttPass= "MQTTPass"
    `````

4. Create a Task to startup srcipt at logon. You can use PowerShell to do this

    ```
    $Action = New-ScheduledTaskAction -Execute 'pwsh.exe' -Argument '-WindowStyle Hidden -file "C:\Webcam2MQTT.ps1" -ExecutionPolicy Bypass -WindowStyle Hidden -noProfile -noInteractive'
    $Trigger = New-ScheduledTaskTrigger -AtLogon -User $env:UserName
    $Settings = New-ScheduledTaskSettingsSet
    $Task = New-ScheduledTask -Action $Action -Trigger $Trigger -Settings $Settings
    Register-ScheduledTask -TaskName 'Webcam2MQTT' -InputObject $Task
    ````
## To create Binary sensor in HA just use this code:
 `````
 binary_sensor:
   - platform: mqtt
    name: "MyPC Webcam"
    state_topic: "MyPC/Webcam"
    payload_on: "ON"
    payload_off: "OFF"
    device_class: "safety"
    force_update: true
 
