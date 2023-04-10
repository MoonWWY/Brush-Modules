#!/system/bin/sh
function Strategy_no1(){
Serious_files=`find /data/adb/modules/*/system -type f -name "mi_thermald";find /data/adb/modules/*/system -type f -name "thermal-map.conf";find /data/adb/modules/*/system -type f -name "thermal-engine.conf";find /data/adb/modules/*/system -type f -name "thermal-normal.conf";find /data/adb/modules/*/system -type f -name "*.so"`
if [ -n "$Serious_files" ];then
  for Serious_file in $Serious_files; do
    rm -f ${Serious_file}
  done
fi
killall mi_thermald
nohup /system/vendor/bin/mi_thermald >/dev/null 2>&1 &
touch $Config_add/Strategy_no1
}

function Strategy_no2(){
clouds="com.miui.powerkeeper/com.miui.powerkeeper.cloudcontrol.CloudUpdateReceiver
com.miui.powerkeeper/com.miui.powerkeeper.cloudcontrol.CloudUpdateJobService
com.miui.powerkeeper/com.miui.powerkeeper.ui.CloudInfoActivity
com.miui.powerkeeper/com.miui.powerkeeper.statemachine.PowerStateMachineService
com.xiaomi.joyose
com.miui.analytics
com.miui.powerkeeper
com.xiaomi.joyose/com.xiaomi.joyose.JoyoseJobScheduleService
com.xiaomi.joyose/com.xiaomi.joyose.cloud.CloudServerReceiver
com.xiaomi.joyose/com.xiaomi.joyose.predownload.PreDownloadJobScheduler
com.xiaomi.joyose/com.xiaomi.joyose.smartop.gamebooster.receiver.BoostRequestReceiver"
clears="com.miui.powerkeeper
com.miui.analytics
com.xiaomi.joyose"

for i in ${clouds};
do
  pm enable ${i}
done
for i in ${clears};
do
  pm clear ${i}
done
pm clear com.xiaomi.powerchecker
touch $Config_add/Strategy_no2
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
touch $Config_add/Strategy_no3
}

Config_add=/storage/emulated/0/Android/Mi12_TemperatureControl
touch $Config_add/Strategy_no1 | touch $Config_add/Strategy_no2 | touch $Config_add/Strategy_no3
if [ ! -f "$Config_add/Strategy_no1" ];then
  Strategy_no1
else
  if [ ! -f "$Config_add/Strategy_no2" ];then
    Strategy_no2
  else
    if [ ! -f "$Config_add/Strategy_no3" ];then
      Strategy_no3
    else
      rm -f Repair_jump.sh
      exit 1
    fi
  fi
fi
