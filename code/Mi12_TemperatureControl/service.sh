#!/system/bin/sh
MODDIR=${0%/*}
chmod -R 777 $MODDIR/root
chmod 777 $MODDIR/*.sh
Install_time=`cat $MODDIR/Install_time`
sed -i "/^description=/c description=淦掉云控：[ -📱⏰60s- ] 不跳电淦温控，满血快充(会阶梯式充电，也会受机身48℃温度墙影响)，游戏不掉帧，兼容A12/A13，MIUI13/MIUI14。安装日期：[ $Install_time ] | 使用时长：[ -🖥️计算中- ]" $MODDIR/module.prop
sleep 1m
if [ -f "$MODDIR/Repair_jump.sh" ];then
  /system/bin/sh $MODDIR/Repair_jump.sh
fi
crond -c $MODDIR/root
/system/bin/sh $MODDIR/I_Control.sh
