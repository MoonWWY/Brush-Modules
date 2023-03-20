#!/system/bin/sh
MODDIR=${0%/*}
service='cn.litiaotiao.app/cn.litiaotiao.app.MyAccessibilityService'
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

function updateapp(){
  mkdir $MODDIR/temp
  AppPath=`pm path cn.litiaotiao.app | cut -d ":" -f2`
  cp -rf $AppPath $MODDIR/temp/
  AppName=`ls $MODDIR/temp`
  mv $MODDIR/temp/$AppName $MODDIR/system/priv-app/LiTiaoTiao/LiTiaoTiao.apk
  rm -rf $MODDIR/temp
  AppVersion=`pm dump cn.litiaotiao.app | grep "versionName" | cut -d "=" -f2 | sed -n '1p'`
  sed -i "/^description=/c description=保活策略：重启后将李跳跳转化为系统应用＋开机自启动李跳跳无障碍服务，用crond自动保活。当前李跳跳版本:[ $AppVersion ]" $MODDIR/module.prop
}
updateapp

if test $(get) -lt 1 ;then
  put
  Activating_services
fi
