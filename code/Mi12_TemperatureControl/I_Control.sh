#!/system/bin/sh
Cache=/storage/emulated/0/Android/Mi12_TemperatureControl/Cache
ModuleAdd=/data/adb/modules/Mi12_TemperatureControl
Config_add=/storage/emulated/0/Android/Mi12_TemperatureControl
#将会导致跳电的云温控文件名填入下方Cloud_jump_thermals=""中，以/分开
Cloud_jump_thermals="/mi_thermald/"
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
#默认的空云控目录文件
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

#调整温控文件，下次重启生效
function Alter_temperature_control(){
#根据配置文件生成默认温控文件
mkdir -p $ModuleAdd/thermal
for files in $thermal_files; do
  touch $ModuleAdd/thermal/$files
done
#匹配机型的云控空文件到thermal目录下
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
#拷贝空温度云控文件到系统云控文件目录下
chattr -R -i /data/vendor/thermal/config
rm -rf /data/vendor/thermal/config/*
cp -rf $ModuleAdd/thermal/* /data/vendor/thermal/config/
#cp -rf $ModuleAdd/system/* /data/vendor/thermal/config/
#chattr +i增加限制系统写入，避免云控更改
chmod 644 /data/vendor/thermal/config/*
chmod 644 /data/vendor/thermal/config
chattr -R +i /data/vendor/thermal/config

#查找system目录下所有温控文件，排除导致跳电问题的mi_thermald等
thermals=`ls /system/bin/*thermal* /system/etc/init/*thermal* /system/etc/perf/*thermal* /system/vendor/bin/*thermal* /system/vendor/etc/*thermal* /system/vendor/etc/powerhint* /system/vendor/etc/init/*_thermal* /system/vendor/etc/perf/*thermal* /system/vendor/lib/hw/thermal* /system/vendor/lib64/hw/thermal* 2>/dev/null | grep -v mi_thermald | grep -v thermal-engine.conf | grep -v thermal-normal.conf | grep -v thermal-map.conf | grep -v thermal-engine | grep -v thermalserviced | grep -v "*.so"`
#创建温控空文件
for thermal in $thermals; do
  [[ ! -d $ModuleAdd/thermals/${thermal%/*} ]] && mkdir -p $ModuleAdd/thermals/${thermal%/*}
  touch $ModuleAdd/thermals/$thermal
done
#备份system目录，创建system空文件夹
systems="/system/bin /system/etc/init /system/etc/perf /system/vendor/bin /system/vendor/etc /system/vendor/etc /system/vendor/etc/init /system/vendor/etc/perf /system/vendor/lib/hw /system/vendor/lib64/hw"
for system in $systems; do
  if [ -d "$system" ];then
    mkdir -p $ModuleAdd/$system
  fi
done
cp -rf $ModuleAdd/thermals/system/ $ModuleAdd
#删除创建的空温控文件/目录
rm -rf $ModuleAdd/thermals/
}

#禁用云控
function Disable_cloud(){
if [ $Lock_screen_state == "false" ]; then
#禁用
  for i in ${clouds};do
    pm disable ${i}
  done
#清除应用数据
  for i in ${clears};do
    pm clear ${i}
  done
#Analytics，禁用服务和隐藏应用
  pm suspend com.miui.analytics
  pm hide com.miui.analytics
#打开云控界面，避免异常，下同
  pm enable com.miui.powerkeeper/com.miui.powerkeeper.ui.CloudInfoActivity
#打开Joyose智能服务
  pm enable com.xiaomi.joyose/com.xiaomi.joyose.smartop.SmartOpService
  pm enable com.xiaomi.joyose/com.xiaomi.joyose.cloud.LocalCtrlActivity
#屏蔽MIUI云控，防止电量和性能接收云控数据。
  for i in ${Cloud_address};do
    iptables -A OUTPUT -m string --string "$i" --algo bm --to 65535 -j DROP
    iptables -A INPUT -m string --string "$i" --algo bm --to 65535 -j DROP
  done
  if [ ! -f "$Config_add/kill_state" ];then
    touch $Config_add/kill_state
  fi
fi
}

#恢复云控
function Enable_the_cloud(){
if [ -f "$Config_add/kill_state" ];then
#启用
  for i in ${clouds};do
    pm enable ${i}
  done
#解除隐藏Analytics
  pm unsuspend com.miui.analytics
  pm unhide com.miui.analytics
#关闭云控界面
  pm disable com.miui.powerkeeper/com.miui.powerkeeper.ui.CloudInfoActivity
#解除屏蔽MIUI云控，电量和性能接收云控数据。
  for i in ${Cloud_address};do
    iptables -D OUTPUT -m string --string "$i" --algo bm --to 65535 -j DROP
    iptables -D INPUT -m string --string "$i" --algo bm --to 65535 -j DROP
  done
  rm $Config_add/kill_state
fi
}
#更新module.prop信息
function Update_information(){
#获取当前时间
KillLog_time=`date +"%H:%M:%S"`
Mod_information=/data/adb/modules/Mi12_TemperatureControl/module.prop
#安装时间
Install_time=`cat $Config_add/Install_time`
#现在时间 年月日/时
NowTime_Ymd=`date +"%Y%m%d"`
NowTime_H=`date +"%H"`
Time_Ymd=`cat $Config_add/Time_Ymd`
Time_H=`cat $Config_add/Time_H`
#计算使用时长
Time_Day=`expr $NowTime_Ymd - $Time_Ymd`
Time_Hr=`expr $NowTime_H - $Time_H`
#判断凌晨0点以后是否有过使用，做出相应信息更改
if [ "$Earliest2" -gt "0000" ]; then
  sed -i "/^description=/c description=淦掉云控：[ ⏰<$Latest11,$Latest22>,<$Earliest11,$Earliest22> 🔪| $KillLog_time | ] 不跳电淦温控，满血快充(会阶梯式充电，也会受机身48℃温度墙影响)，游戏不掉帧，兼容A12/A13，MIUI13/MIUI14。安装日期：[ $Install_time ] | 使用时长：[ ${Time_Day}天 ${Time_Hr}小时 ]" "$Mod_information"
else
  sed -i "/^description=/c description=淦掉云控：[ ⏰<$Latest11,$Latest22> 🔪| $KillLog_time | ] 不跳电淦温控，满血快充(会阶梯式充电，也会受机身48℃温度墙影响)，游戏不掉帧，兼容A12/A13，MIUI13/MIUI14。安装日期：[ $Install_time ] | 使用时长：[ ${Time_Day}天 ${Time_Hr}小时 ]" "$Mod_information" "$Mod_information"
fi
}

#获取手机锁屏状态，false：已解锁 true：锁屏
Lock_screen_state=`dumpsys window policy | grep mIsShowing | cut -d"=" -f2`
H_time=`date +"%H%M"`
#判断解锁状态，记录使用的时间集合
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

#Earliest1凌晨0点固定0000，Earliest2凌晨8点之前最晚使用时间，Latest1早上8点之后最早的时间点，Latest2是使用时间0点之前最迟的时候
Earliest1=`cat ${Cache}/Earliest1`
Earliest2=`cat ${Cache}/Earliest2`
Latest1=`cat ${Cache}/Latest1`
Latest2=`cat ${Cache}/Latest2`
#做一个除运算，把时间"时分"换算成"时"，+1是为了准确时间集合范围
hundred=100
Earliest11=`expr $Earliest1 / $hundred`
Earliest22=`expr $(expr $Earliest2 / $hundred) + 1`
Latest11=`expr $Latest1 / $hundred`
if [ "$Latest2" -ge "2300" ]; then
  Latest22="0"
else
  Latest22=`expr $(expr $Latest2 / $hundred) + 1`
fi

#在常用时间&&亮屏才运行。判断当前时候解锁设备。
#解锁：再判断当前时间是否是0-7点/7-使用最晚时间之间。在：执行淦云控脚本。不在：打开淦云控的所有禁止。
#未解锁：判断是否在白天常用时间点。在：执行淦云控脚本。不在：打开淦云控的所有禁止。
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
#调用函数调整温控文件
Alter_temperature_control
#调用函数更新模块信息
Update_information