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
ui_print "———————————————————————————"
ui_print "- 模块信息"
ui_print "- 名称: $name"
ui_print "- 版本: $version"
ui_print "- 作者：$author"
ui_print "———————————————————————————"
}

function Ifff() {
ui_print "——————————————————————————————————————————————————————"
ui_print "- 特此声明："
ui_print "- 本模块已适配自动调度云控温控功能"
ui_print "- 请在配置文件中添加你需要的游戏"
ui_print "- 配置目录："
ui_print "/storage/emulated/0/Android/Mi12_TemperatureControl/配置文件.conf"
ui_print "——————————————————————————————————————————————————————"
sleep 1
ui_print "- 准备安装模块~"
}

function Install() {
Config_add=/storage/emulated/0/Android/Mi12_TemperatureControl
sleep 1
ui_print "- Install~"

ui_print "- 💞初始化模块环境"
function install_magisk_busybox() {
mkdir -p /data/adb/busybox
	/data/adb/magisk/busybox --install -s /data/adb/busybox
	chmod -R 0755 /data/adb/busybox 
export PATH=/data/adb/busybox:$PATH
}
install_magisk_busybox
product=$MODPATH/system/product
if [ ! -d "$product" ]; then
  mkdir -p ${product}
  cp -p -a -R /system/product/pangu/system/* ${product}
fi
script_name="/system/bin/sh /data/adb/modules/Mi12_TemperatureControl/Dynamic_cloud_control.sh"
lastID=$(pgrep -f "$script_name")
if [ "$lastID" != "" ]; then
  kill -KILL $lastID
fi
sed -i "/^description=/c description=当前模式：[ NULL | -等待重启- ] ，Mi·淦掉温控：不跳电淦温控，淦掉云控，满血快充(会阶梯式充电，也会受机身48℃温度墙影响)，游戏不掉帧，兼容A12/A13，MIUI13/MIUI14。" $MODPATH/module.prop

ui_print "- 🚀生成配置文件" 
if [ -d "/data/adb/modules/Mi12_TemperatureControl/" ];then
  versionCode="`grep_prop versionCode /data/adb/modules/Mi12_TemperatureControl/module.prop`"
  if [ "$versionCode" -lt "230905" ]; then
    if [ -d "${Config_add}/" ];then
      rm -rf ${Config_add}/*
    else
      mkdir -p ${Config_add}/
    fi
    cp -rf $MODPATH/配置文件.conf ${Config_add}/
    cp -rf $MODPATH/免重启更新配置.sh ${Config_add}/
  fi
else
  mkdir -p ${Config_add}/
  cp -rf $MODPATH/免重启更新配置.sh ${Config_add}/
  cp -rf $MODPATH/配置文件.conf ${Config_add}/
fi

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
