#!/system/bin/sh
if [ "$(id -u)" != "0" ]; then
  echo "- 请用root权限执行脚本"
  exit 1
fi
echo "——————————————————————"
echo "一键更新重启配置"
echo "——————————————————————"
script_name="/system/bin/sh /data/adb/modules/Mi12_TemperatureControl/Dynamic_cloud_control.sh"
lastID=$(pgrep -f "$script_name")
echo "检测脚本运行状态："
if [ "$lastID" != "" ]; then
  echo -e "运行状态：\e[32m正在运行……\e[0m"
  echo -e "重启脚本：\e[32m重启成功！\e[0m"
  kill -KILL $lastID
  /system/bin/sh /data/adb/modules/Mi12_TemperatureControl/Dynamic_cloud_control.sh > /dev/null 2>&1 &
  exit 0
else
  echo -e "运行状态：\e[31m没有运行……\e[0m"
  echo -e "重启脚本：\e[32m重启成功！\e[0m"
  /system/bin/sh /data/adb/modules/Mi12_TemperatureControl/Dynamic_cloud_control.sh > /dev/null 2>&1 &
  exit 0
fi