#!/system/bin/sh
MODDIR=${0%/*}
until [ $(getprop sys.boot_completed) == 1 ]; do
  sleep 1
done
chmod a+x $MODDIR/*.sh
Time=20
while [ $Time -ge 0 ]; do
  sed -i "/^description=/c description=等待重启：[ -⏰${Time}s- ] ，Mi·淦掉温控：不跳电淦温控，淦掉云控，满血快充(会阶梯式充电，也会受机身48℃温度墙影响)，游戏不掉帧，兼容A12/A13，MIUI13/MIUI14。" $MODDIR/module.prop
  sleep 1
  Time=$((Time-1))
done
/system/bin/sh $MODDIR/Repair_jump.sh
/system/bin/sh $MODDIR/Restore.sh
rm -rf /data/system/mcd
mkdir /data/system/mcd
chmod 444 /data/system/mcd
chattr +i /data/system/mcd
/system/bin/sh $MODDIR/Flashrate.sh
/system/bin/sh $MODDIR/Dynamic_cloud_control.sh >/dev/null 2>&1 &