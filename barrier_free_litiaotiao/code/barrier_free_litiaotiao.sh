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

if test $(get) -lt 1 ;then
  put
  Activating_services
fi
