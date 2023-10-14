#!/system/bin/sh
function Uninstall_modules(){
chattr -R -i /data/vendor/thermal/config
chmod -R 777 /data/vendor/thermal/config
rm -rf /data/vendor/thermal/config/*
chattr -R -i /data/system/mcd
chmod 755 /data/system/mcd
rm -rf /data/adb/modules/Mi12_TemperatureControl/
rm -rf /storage/emulated/0/Android/Mi12_TemperatureControl/
}
Uninstall_modules
script_name="/system/bin/sh /data/adb/modules/Mi12_TemperatureControl/Dynamic_cloud_control.sh"
lastID=$(pgrep -f "$script_name")
if [ "$lastID" != "" ]; then
  kill -KILL $lastID
fi