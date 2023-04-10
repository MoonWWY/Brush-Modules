#!/system/bin/sh
Cache=/storage/emulated/0/Android/Mi12_TemperatureControl/Cache
ModuleAdd=/data/adb/modules/Mi12_TemperatureControl
Config_add=/storage/emulated/0/Android/Mi12_TemperatureControl
Cloud_jump_thermals="/mi_thermald/"
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
thermal_files="thermal-4k.conf
thermal-8k.conf
thermal-abnormal.conf
thermal-arvr.conf
thermal-camera.conf
thermal-chg-only.conf
thermal-class0.conf
thermal-engine.conf
thermal-hp-mgame.conf
thermal-hp-normal.conf
thermal-huanji.conf
thermal-iec-4k.conf
thermal-iec-abnormal.conf
thermal-iec-camera.conf
thermal-iec-class0.conf
thermal-iec-huanji.conf
thermal-iec-mgame.conf
thermal-iec-navigation.conf
thermal-iec-nolimits.conf
thermal-iec-normal.conf
thermal-iec-per-class0.conf
thermal-iec-per-navigation.conf
thermal-iec-per-normal.conf
thermal-iec-per-video.conf
thermal-iec-phone.conf
thermal-iec-tgame.conf
thermal-iec-video.conf
thermal-iec-videochat.conf
thermal-k1a-phone.conf
thermal-map.conf
thermal-mgame.conf
thermal-navigation.conf
thermal-nolimits.conf
thermal-normal.conf
thermal-per-camera.conf
thermal-per-class0.conf
thermal-per-huanji.conf
thermal-per-navigation.conf
thermal-per-normal.conf
thermal-per-video.conf
thermal-phone.conf
thermal-region-map.conf
thermal-tgame.conf
thermal-video.conf
thermal-videochat.conf
thermald-devices.conf"

function Alter_temperature_control(){
mkdir -p $ModuleAdd/thermal
for files in $thermal_files; do
  touch $ModuleAdd/thermal/$files
done
Cloud_thermals=`ls /data/vendor/thermal/config`
for Cloud_thermal in $Cloud_thermals; do
  echo $Cloud_jump_thermals | grep "$Cloud_thermal" && {
    cp -rf /data/vendor/thermal/config/$Cloud_thermal $ModuleAdd/thermal/
  } || {
    if [ ! -f "$ModuleAdd/thermal/$Cloud_thermal" ]; then
      touch $ModuleAdd/thermal/$Cloud_thermal
    fi
  }
done
chattr -R -i /data/vendor/thermal/config
rm -rf /data/vendor/thermal/config/*
cp -rf $ModuleAdd/thermal/* /data/vendor/thermal/config/
chmod 644 /data/vendor/thermal/config/*
chmod 644 /data/vendor/thermal/config
chattr -R +i /data/vendor/thermal/config

thermals=`ls /system/bin/*thermal* /system/etc/init/*thermal* /system/etc/perf/*thermal* /system/vendor/bin/*thermal* /system/vendor/etc/*thermal* /system/vendor/etc/powerhint* /system/vendor/etc/init/*_thermal* /system/vendor/etc/perf/*thermal* /system/vendor/lib/hw/thermal* /system/vendor/lib64/hw/thermal* 2>/dev/null | grep -v mi_thermald | grep -v thermal-engine.conf | grep -v thermal-normal.conf | grep -v thermal-map.conf | grep -v thermal-engine | grep -v thermalserviced | grep -v "*.so"`
for thermal in $thermals; do
  [[ ! -d $ModuleAdd/thermals/${thermal%/*} ]] && mkdir -p $ModuleAdd/thermals/${thermal%/*}
  touch $ModuleAdd/thermals/$thermal
done
systems="/system/bin /system/etc/init /system/etc/perf /system/vendor/bin /system/vendor/etc /system/vendor/etc /system/vendor/etc/init /system/vendor/etc/perf /system/vendor/lib/hw /system/vendor/lib64/hw"
for system in $systems; do
  if [ -d "$system" ];then
    mkdir -p $ModuleAdd/$system
  fi
done
cp -rf $ModuleAdd/thermals/system/ $ModuleAdd
rm -rf $ModuleAdd/thermals/
}

function Disable_cloud(){
if [ $Lock_screen_state == "false" ]; then
  for i in ${clouds};do
    pm disable ${i}
  done
  for i in ${clears};do
    pm clear ${i}
  done
  pm suspend com.miui.analytics
  pm hide com.miui.analytics
  pm enable com.miui.powerkeeper/com.miui.powerkeeper.ui.CloudInfoActivity
  pm enable com.xiaomi.joyose/com.xiaomi.joyose.smartop.SmartOpService
  pm enable com.xiaomi.joyose/com.xiaomi.joyose.cloud.LocalCtrlActivity
  for i in ${Cloud_address};do
    iptables -A OUTPUT -m string --string "$i" --algo bm --to 65535 -j DROP
    iptables -A INPUT -m string --string "$i" --algo bm --to 65535 -j DROP
  done
  if [ ! -f "$Config_add/kill_state" ];then
    touch $Config_add/kill_state
  fi
fi
}

function Enable_the_cloud(){
if [ -f "$Config_add/kill_state" ];then
  for i in ${clouds};do
    pm enable ${i}
  done
  pm unsuspend com.miui.analytics
  pm unhide com.miui.analytics
  pm disable com.miui.powerkeeper/com.miui.powerkeeper.ui.CloudInfoActivity
  for i in ${Cloud_address};do
    iptables -D OUTPUT -m string --string "$i" --algo bm --to 65535 -j DROP
    iptables -D INPUT -m string --string "$i" --algo bm --to 65535 -j DROP
  done
  rm $Config_add/kill_state
fi
}
function Update_information(){
KillLog_time=`date +"%H:%M:%S"`
Mod_information=/data/adb/modules/Mi12_TemperatureControl/module.prop
Install_time=`cat $Config_add/Install_time`
NowTime_Ymd=`date +"%Y%m%d"`
NowTime_H=`date +"%H"`
Time_Ymd=`cat $Config_add/Time_Ymd`
Time_H=`cat $Config_add/Time_H`
Time_Day=`expr $NowTime_Ymd - $Time_Ymd`
Time_Hr=`expr $NowTime_H - $Time_H`
if [ "$Earliest2" -gt "0000" ]; then
  sed -i "/^description=/c description=淦掉云控：[ ⏰<$Latest11,$Latest22>,<$Earliest11,$Earliest22> 🔪| $KillLog_time | ] 不跳电淦温控，满血快充(会阶梯式充电，也会受机身48℃温度墙影响)，游戏不掉帧，兼容A12/A13，MIUI13/MIUI14。安装日期：[ $Install_time ] | 使用时长：[ ${Time_Day}天 ${Time_Hr}小时 ]" "$Mod_information"
else
  sed -i "/^description=/c description=淦掉云控：[ ⏰<$Latest11,$Latest22> 🔪| $KillLog_time | ] 不跳电淦温控，满血快充(会阶梯式充电，也会受机身48℃温度墙影响)，游戏不掉帧，兼容A12/A13，MIUI13/MIUI14。安装日期：[ $Install_time ] | 使用时长：[ ${Time_Day}天 ${Time_Hr}小时 ]" "$Mod_information" "$Mod_information"
fi
}

Lock_screen_state=`dumpsys window policy | grep mIsShowing | cut -d"=" -f2`
H_time=`date +"%H%M"`
if [ $Lock_screen_state == "false" ]; then
  echo "$H_time">>${Cache}/Caches
  if [ "$H_time" -ge "0000" ] && [ "$H_time" -le "0700" ]; then
    echo "$H_time">>${Cache}/Earliest
    echo "0000">${Cache}/Earliest1
    cat ${Cache}/Earliest | sort -u -n | sed -n '$p' >${Cache}/Earliest2
    cat ${Cache}/Caches | sort -u -n | sed -n '$p' >${Cache}/Latest2
  else
    echo "$H_time">>${Cache}/Latest
    cat ${Cache}/Latest | sort -u -n | sed -n '1p' >${Cache}/Latest1
    cat ${Cache}/Caches | sort -u -n | sed -n '$p' >${Cache}/Latest2
  fi
fi

Earliest1=`cat ${Cache}/Earliest1`
Earliest2=`cat ${Cache}/Earliest2`
Latest1=`cat ${Cache}/Latest1`
Latest2=`cat ${Cache}/Latest2`
hundred=100
Earliest11=`expr $Earliest1 / $hundred`
Earliest22=`expr $(expr $Earliest2 / $hundred) + 1`
Latest11=`expr $Latest1 / $hundred`
if [ "$Latest2" -ge "2300" ]; then
  Latest22="0"
else
  Latest22=`expr $(expr $Latest2 / $hundred) + 1`
fi

if [ "$H_time" -ge "0000" ] && [ "$H_time" -le "0700" ]; then
  if [ "$H_time" -ge "Earliest1" ] && [ "$H_time" -le "Earliest2" ]; then
    Disable_cloud
  elif [ "$H_time" -ge "0700" ] && [ "$H_time" -le "Latest2" ]; then
    Disable_cloud
  else
    Enable_the_cloud
  fi
else
  if [ "$H_time" -ge "Latest1" ] && [ "$H_time" -le "Latest2" ]; then
    Disable_cloud
  else
    Enable_the_cloud
  fi
fi
Alter_temperature_control
Update_information
