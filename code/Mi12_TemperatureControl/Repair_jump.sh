#!/system/bin/sh
function Strategy_no1(){
Serious_files=`find /data/adb/modules/*/system -type f -name "mi_thermald";find /data/adb/modules/*/system -type f -name "thermal-map.conf";find /data/adb/modules/*/system -type f -name "thermal-engine.conf";find /data/adb/modules/*/system -type f -name "thermal-normal.conf";find /data/adb/modules/*/system -type f -name "*.so"`
if [ -n "$Serious_files" ]; then
  for Serious_file in $Serious_files; do
    rm -f ${Serious_file}
  done
fi
killall mi_thermald
nohup /system/vendor/bin/mi_thermald >/dev/null 2>&1 &
}

function Strategy_no2(){
clears="com.miui.powerkeeper
com.miui.analytics
com.xiaomi.joyose
com.miui.daemon"

for i in ${clears}; do
  pm clear ${i}
  pm enable ${i}
done
}

function Strategy_no3(){
resetprop -p sys.thermal.data.path /data/vendor/thermal/
resetprop -p vendor.sys.thermal.data.path /data/vendor/thermal/
chattr -R -i "/data/vendor/thermal"
rm -rf "/data/vendor/thermal"
mkdir -p "/data/vendor/thermal/config"
chmod -R 0771 "/data/vendor/thermal"
chown -R root:system "/data/vendor/thermal"
chcon -R "u:object_r:vendor_data_file:s0" "/data/vendor/thermal"
}

Strategy_no1
Strategy_no2
Strategy_no3

dumpsys battery reset