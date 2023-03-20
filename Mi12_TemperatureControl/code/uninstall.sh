#!/system/bin/sh
#卸载模块函数
function Uninstall_modules(){
#去除云控目录阻止写入限制
chmod -R 777 /data/vendor/thermal/config
chattr -R -i /data/vendor/thermal/config
#拷贝备份文件到云控目录
rm -rf /data/vendor/thermal/config/*
cp -rf /storage/emulated/0/Android/Mi12_TemperatureControl/First_install_bak/cloud_thermals/* /data/vendor/thermal/config/
#禁/启用app/服务列表，就不一一说明了
#如果游戏还是不能稳帧，请将以下去掉注释加到下列列表中
#com.miui.powerkeeper
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
#清理列表：MIUI的电量和性能，Analytics和Joyose
clears="com.miui.powerkeeper
com.miui.analytics
com.xiaomi.joyose"
#云控的域名/ip地址
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
#根据参数解除所以云控禁止，清除数据以便继续云控正常使用
#启用
for i in ${clouds};
do
  pm enable ${i}
done
#清理数据
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
#删除所有模块缓存目录
rm -rf /data/adb/modules/Mi12_TemperatureControl/
rm -rf /storage/emulated/0/Android/Mi12_TemperatureControl/
}
#调用卸载函数
Uninstall_modules