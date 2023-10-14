#!/system/bin/sh
ModuleAdd=/data/adb/modules/Mi12_TemperatureControl
Config_add=/storage/emulated/0/Android/Mi12_TemperatureControl

function Set_default(){
rm -rf /cache/miui-thermal/*
chattr -R -i /data/vendor/thermal/config
rm -rf /data/vendor/thermal/config/*
echo "local_default">/data/vendor/thermal/config/thermal.current.ini
cmd activity broadcast --user 0 -a update_profile com.miui.powerkeeper/com.miui.powerkeeper.cloudcontrol.CloudUpdateReceiver
}

function Set_extreme(){
rm -rf /cache/miui-thermal/*
chattr -R -i /data/vendor/thermal/config
cp -rf $ModuleAdd/extreme/* /data/vendor/thermal/config/
chmod -R 644 /data/vendor/thermal/config/
chown -R root:system '/data/vendor/thermal'
chcon -R 'u:object_r:thermal_data_file:s0' '/data/vendor/thermal'
chattr -R +i /data/vendor/thermal/config
stop mi_thermald
start mi_thermald
}

function Set_danger(){
rm -rf /cache/miui-thermal/*
chattr -R -i /data/vendor/thermal/config
cp -rf $ModuleAdd/danger/* /data/vendor/thermal/config/
chmod -R 644 /data/vendor/thermal/config/
chown -R root:system '/data/vendor/thermal'
chcon -R 'u:object_r:thermal_data_file:s0' '/data/vendor/thermal'
chattr -R +i /data/vendor/thermal/config
stop mi_thermald
start mi_thermald
}

function Update_information(){
Mod_information=${ModuleAdd}/module.prop
battery=$(find /sys/devices/ -iname "battery" -type d)
Temp=$(cat $battery/temp)
Degree=$((Temp/10)).$((Temp%10))
KillLog_time=`date +"%H:%M:%S"`
sed -i "/^description=/c description=实时状态：【 🛸MOD:[ ${Current_pattern} ] 🌡️[ ${Degree}℃ ] 🔪[ $KillLog_time ] 】 模块功能：淦掉温控，满血快充，淦掉云控，游戏全性能。配置目录：/storage/emulated/0/Android/Mi12_TemperatureControl/配置文件.conf" "$Mod_information"
}

function Dynamic_control(){
while true; do
if [ -f "/data/vendor/thermal/config/thermal.current.ini" ]; then
  Modular_mode=`cat /data/vendor/thermal/config/thermal.current.ini`
else
  Modular_mode="local_default"
fi
Lock_screen_state=`dumpsys window policy | grep mIsShowing | cut -d"=" -f2`
Charging_state=`dumpsys battery | egrep "status" | sed -n 's/.*status: //g;$p'`
if [ $Charging_state == "2" ]; then
  Current_pattern="danger"
else
  if [ $Lock_screen_state == "true" ]; then
    Current_pattern="default"
  else
    games=`cat ${Config_add}/配置文件.conf | grep -v "^#" | grep -v "^$"`
    for game in ${games}; do
      Current_pattern="extreme"
      if ps -A | grep -E "$game">/dev/null;then
        Current_pattern="danger"
        break
      fi
    done
  fi
fi
Battery_capacity=`dumpsys battery | egrep "level" | sed -n 's/.*status: //g;$p'`
if [ "$Battery_capacity" -le "20" ]; then
  Current_pattern="cool"
fi

if [ "$Current_pattern" = "danger" ]; then
  if [ "$Modular_mode" != "local_danger" ]; then
    Set_danger
  fi
elif [ "$Current_pattern" = "extreme" ]; then
  if [ "$Modular_mode" != "local_extreme" ]; then
    Set_extreme
  fi
elif [ "$Current_pattern" = "cool" ]; then
  if [ "$Modular_mode" != "local_cool" ]; then
    Set_extreme
  fi
else
  if [ "$Modular_mode" != "local_default" ]; then
    Set_default
  fi
fi
Update_information
sleep 3s
done
}

Dynamic_control
