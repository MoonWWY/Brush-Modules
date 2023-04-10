#!/system/bin/sh
SKIPMOUNT=false
PROPFILE=true
POSTFSDATA=false
LATESTARTSERVICE=true
DUBUG_FLAG=true
SKIPUNZIP=0
ASH_STANDALONE=0

function Information() {
name="`grep_prop name $TMPDIR/module.prop`"
version="`grep_prop version $TMPDIR/module.prop`"
author="`grep_prop author $TMPDIR/module.prop`"
description="`grep_prop description $TMPDIR/module.prop`"
ui_print "********************"
ui_print "- 模块信息"
ui_print "- 名称: $name"
ui_print "- 版本: $version"
ui_print "- 作者：$author"
ui_print "- $description"
ui_print "********************"
}

function Ifff() {
model=$(getprop ro.product.model)
a_version=$(getprop ro.build.version.release)
lastVersion=$(getprop ro.build.version.incremental)
ui_print "————————————————————————————————————"
ui_print "- 温馨提醒："
ui_print "- 此模块仅为机型代号:2201123C(小米12)提供完美支持"
ui_print "- 已适配安卓12/13，MIUI13/MIUI14"
ui_print "- 理论MIUI全系可用"
if [[ "2201123C" =~ $model ]]; then
  ui_print "- 目前已适配你的机型！放心安装！"
  ui_print "- 如有问题请反馈"
else
  ui_print "- 可能不适配你的设备:$model($lastVersion)/A$a_version"
  ui_print "- 作者资源有限，如果需要可联系作者帮助适配"
  ui_print "- 如需安装，是否可用请自测！"
  ui_print "- 请先确定刷好了救砖模块"
fi
ui_print "————————————————————————————————————"
ui_print "- 删温控的风险请自知"
ui_print "- 请先细读README.txt内容后，根据需要再做选择："
ui_print "  + 音量加：同意安装"
ui_print "  - 音量减：拒绝安装"
ui_print "————————————————————————————————————"
volume=1
action=1
ui_print "- 请根据提示按音量键进行选择！"
while [ $volume == 1 ]; do
  action=`getevent -lqc 1`
  if [[ "${action}" == "*KEY_VOLUMEUP*" ]];then 
    volume=0
    ui_print "- 为你安装！！！"
    ui_print "- 出问题请自行负责！"
    ui_print "————————————————————————————————————"
  elif [[ "${action}" == "*KEY_VOLUMEDOWN*" ]];then
    volume=0
    ui_print "- 退出安装！！！"
    ui_print "————————————————————————————————————"
    exit 2
  fi
done
}
function Install() {
sleep 0.5
ui_print "- Install~"

ui_print "- 🚙备份温控文件"
Config_add=/storage/emulated/0/Android/Mi12_TemperatureControl
First_install_bak=${Config_add}/First_install_bak
Jump_thermals="/system/vendor/bin/mi_thermald
/system/vendor/etc/thermal-engine.conf
/system/vendor/etc/thermal-normal.conf
/system/vendor/etc/thermal-map.conf
/system/vendor/bin/thermal-engine
/system/bin/thermalserviced"
Cloud_thermals=`ls /data/vendor/thermal/config`
if [ ! -d "$First_install_bak" ]; then
  mkdir -p ${First_install_bak}/cloud_thermals
  mkdir -p ${First_install_bak}/Jump_thermals
  for Cloud_thermal in $Cloud_thermals; do
    cp -rf /data/vendor/thermal/config/$Cloud_thermal ${First_install_bak}/cloud_thermals
  done
  for Jump_thermal in $Jump_thermals; do
    if [ -s "$Jump_thermal" ]; then
      cp -rf $Jump_thermal $First_install_bak/Jump_thermals
    fi
  done
fi

ui_print "- 💞初始化模块文件"
function install_magisk_busybox() {
mkdir -p /data/adb/busybox
	/data/adb/magisk/busybox --install -s /data/adb/busybox
	chmod -R 0755 /data/adb/busybox 
export PATH=/data/adb/busybox:$PATH
}
install_magisk_busybox 2>/dev/null
Cache=/storage/emulated/0/Android/Mi12_TemperatureControl/Cache
mkdir -p $Cache
echo "1200
1800">>$Cache/Caches
echo "1200
1800">>$Cache/Latest
echo "1200">$Cache/Latest1
mkdir -p $MODPATH/root
echo "#每20分钟执行一次I_Control.sh，淦云控
*/20 * * * * sh /data/adb/modules/Mi12_TemperatureControl/I_Control.sh">$MODPATH/root/root
product=$MODPATH/system/product
if [ ! -d "$product" ]; then
  mkdir -p ${product}
  cp -p -a -R /system/product/pangu/system/* ${product}
fi
Install_time=`date +"%Y.%m.%d %H:%M:%S"`
echo "$Install_time">$Config_add/Install_time
echo "$Install_time">$MODPATH/Install_time
Time_Ymd=`date +"%Y%m%d"`
Time_H=`date +"%H"`
echo "$Time_Ymd">$Config_add/Time_Ymd
echo "$Time_H">$Config_add/Time_H
sed -i "/^description=/c description=淦掉云控：[ -等待重启- ] 不跳电淦温控，满血快充(会阶梯式充电，也会受机身48℃温度墙影响)，游戏不掉帧，兼容A12/A13，MIUI13/MIUI14。安装日期：[ $Install_time ] | 使用时长：[ -请重启- ]" $MODPATH/module.prop

ui_print "- ✍🏻️写入温控文件"
/system/bin/sh $MODPATH/I_Control.sh >/dev/null 2>&1 &

ui_print "- 🐾尝试清除缓存，修复异常"
cache_path=/data/dalvik-cache/arm
[ -d $cache_path"64" ] && cache_path=$cache_path"64"
for fileName in $system_ext_cache; do
  rm -f $cache_path/system_ext@*@"$fileName"*
  rm -f /data/system/package_cache/*/"$fileName"*
done
for fileName in $system_cache; do
  rm -f $cache_path/system@*@"$fileName"*
  rm -f /data/system/package_cache/*/"$fileName"*
done

ui_print "- 👾设置权限"
set_perm_recursive $MODPATH 0 0 0755 0644
}
Information
Ifff
Install
