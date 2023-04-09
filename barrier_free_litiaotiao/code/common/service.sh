#!/system/bin/sh
MODDIR=${0%/*}
chmod -R 777 $MODDIR/root
crond -c $MODDIR/root
if [ -f "$MODDIR/clear_cache" ];then
  rm -rf /date/dalvik-cache/* | rm -rf /date/system/package_cache/*
  rm -f $MODDIR/clear_cache
fi
sleep 10s
AppVersion=`pm dump hello.litiaotiao.app | grep "versionName" | cut -d "=" -f2 | sed -n '1p'`
sed -i "/^description=/c description=保活策略：重启后将李跳跳转化为系统应用＋开机自启动李跳跳无障碍服务，用crond自动保活。当前李跳跳版本:[ $AppVersion ]" $MODDIR/module.prop
/system/bin/sh $MODDIR/permissions.sh
/system/bin/sh $MODDIR/barrier_free_litiaotiao.sh