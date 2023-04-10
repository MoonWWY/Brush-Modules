#!/system/bin/sh
MODDIR=${0%/*}
#修改替换文件修改CPU温度墙
slot=$(getprop ro.boot.slot_suffix)
a_version=$(getprop ro.build.version.release)
if [ $a_version == "12" ]; then
img='a12/a12devcfg.mbn'
elif [ $a_version == "13" ]; then
img='a13/a13devcfg.mbn'
fi
if [[ -f /data/adb/modules/Mi12_temperature_wall/$img && -e /dev/block/by-name/devcfg$slot ]]; then
  dd if=/data/adb/modules/Mi12_temperature_wall/$img of=/dev/block/by-name/devcfg$slot
else
  exit 2
fi
#开机修改GPU温度墙
sleep 30
sh /data/adb/modules/Mi12_temperature_wall/gpu_temp.sh
sh /data/adb/modules/Mi12_temperature_wall/refresh.sh