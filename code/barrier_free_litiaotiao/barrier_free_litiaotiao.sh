#!/system/bin/sh
MODDIR=${0%/*}
service='hello.litiaotiao.app/hello.litiaotiao.app.MyAccessibilityService'
getservice=$(settings get secure enabled_accessibility_services|grep -v 'null')

function Activating_services(){
  am startservice -n $service
}

function put(){
  settings put secure accessibility_enabled 1
  settings put secure enabled_accessibility_services "$service:$getservice"
}

function get(){
  settings get secure enabled_accessibility_services | grep -v 'null' | grep $service | wc -l
}

function message(){
AppVersion=`pm dump hello.litiaotiao.app | grep "versionName" | cut -d "=" -f2 | sed -n '1p'`
sed -i "/^description=/c description=保活策略：重启后将李跳跳转化为系统应用＋开机自启动李跳跳无障碍服务，用crond自动保活。当前李跳跳版本:[ $AppVersion ]" $MODDIR/module.prop
}
message

if test $(get) -lt 1 ;then
  put
  Activating_services
fi
