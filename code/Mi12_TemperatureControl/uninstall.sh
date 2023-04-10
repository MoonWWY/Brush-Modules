#!/system/bin/sh
function Uninstall_modules(){
chmod -R 777 /data/vendor/thermal/config
chattr -R -i /data/vendor/thermal/config
rm -rf /data/vendor/thermal/config/*
cp -rf /storage/emulated/0/Android/Mi12_TemperatureControl/First_install_bak/cloud_thermals/* /data/vendor/thermal/config/
clouds="com.miui.powerkeeper/com.miui.powerkeeper.cloudcontrol.CloudUpdateReceiver
com.miui.powerkeeper/com.miui.powerkeeper.cloudcontrol.CloudUpdateJobService
com.miui.powerkeeper/com.miui.powerkeeper.ui.CloudInfoActivity
com.miui.powerkeeper/com.miui.powerkeeper.statemachine.PowerStateMachineService
com.xiaomi.joyose
com.miui.analytics
com.xiaomi.joyose/com.xiaomi.joyose.JoyoseJobScheduleService
com.xiaomi.joyose/com.xiaomi.joyose.cloud.CloudServerReceiver
com.xiaomi.joyose/com.xiaomi.joyose.predownload.PreDownloadJobScheduler
com.xiaomi.joyose/com.xiaomi.joyose.smartop.gamebooster.receiver.BoostRequestReceiver"
clears="com.miui.powerkeeper
com.miui.analytics
com.xiaomi.joyose"
Cloud_address="jupiter.rus.sys.miui.com
jupiter.india.sys.miui.com
jupiter.intl.sys.miui.com
jupiter.sys.miui.com
preview-jupiter.sys.miui.com
preview-jupiter.india.sys.miui.com
preview-jupiter.intl.sys.miui.com
preview-jupiter.rus.sys.miui.com
rom.pt.miui.srv
cc.sys.intl.xiaomi.com
ccc.sys.intl.xiaomi.com
cc.sys.miui.com
ccc.sys.miui.com"
for i in ${clouds};
do
  pm enable ${i}
done
for i in ${clears};
do
  pm clear ${i}
done
for i in ${Cloud_address};do
  iptables -D OUTPUT -m string --string "$i" --algo bm --to 65535 -j DROP
  iptables -D INPUT -m string --string "$i" --algo bm --to 65535 -j DROP
done
pm unsuspend com.miui.analytics
pm unhide com.miui.analytics
rm -rf /data/user/0/com.miui.powerkeeper/*
rm -rf /data/system/package_cache/*
rm -rf /data/app/com.miui.powerkeeper/*
chmod -R 644 /data/vendor/thermal/config
rm -rf /data/adb/modules/Mi12_TemperatureControl/
rm -rf /storage/emulated/0/Android/Mi12_TemperatureControl/
}
Uninstall_modules
