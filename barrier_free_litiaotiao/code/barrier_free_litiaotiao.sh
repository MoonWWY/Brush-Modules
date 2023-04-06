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

function updateapp(){
  litiaotiaoapp=`pm list packages | grep "hello.litiaotiao.app"`
  if [ -n $litiaotiaoapp ]; then  
    mkdir $MODDIR/temp
    AppPath=`pm path hello.litiaotiao.app | cut -d ":" -f2 |awk -F'base.apk' '{print$1}'`
    cp -rf $AppPath $MODDIR/temp/
    AppName=`ls $MODDIR/temp`
    mv $MODDIR/temp/$AppName $MODDIR/temp/LiTiaoTiao/
    cp -rf $MODDIR/temp/LiTiaoTiao $MODDIR/system/product/priv-app/
    if [ -f "$MODDIR/system/product/priv-app/LiTiaoTiao/base.apk" ];then
      rm -rf $MODDIR/system/product/priv-app/LiTiaoTiao/LiTiaoTiao.apk
      mv $MODDIR/system/product/priv-app/LiTiaoTiao/base.apk $MODDIR/system/product/priv-app/LiTiaoTiao/LiTiaoTiao.apk
    fi
    rm -rf $MODDIR/temp
  fi
    
  AppVersion=`pm dump hello.litiaotiao.app | grep "versionName" | cut -d "=" -f2 | sed -n '1p'`
  sed -i "/^description=/c description=保活策略：重启后将李跳跳转化为系统应用＋开机自启动李跳跳无障碍服务，用crond自动保活。当前李跳跳版本:[ $AppVersion ]" $MODDIR/module.prop
}
updateapp

if test $(get) -lt 1 ;then
  put
  Activating_services
fi
