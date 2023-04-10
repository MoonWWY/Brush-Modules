#!/system/bin/sh
MODDIR=${0%/*}
chmod -R 777 $MODDIR/root
chmod 777 $MODDIR/*.sh
#重启后更新模块信息
Install_time=`cat $MODDIR/Install_time`
sed -i "/^description=/c description=淦掉云控：[ -📱⏰60s- ] 不跳电淦温控，满血快充(会阶梯式充电，也会受机身48℃温度墙影响)，游戏不掉帧，兼容A12/A13，MIUI13/MIUI14。安装日期：[ $Install_time ] | 使用时长：[ -🖥️计算中- ]" $MODDIR/module.prop
sleep 1m
#调用执行防跳电脚本
if [ -f "$MODDIR/Repair_jump.sh" ];then
  /system/bin/sh $MODDIR/Repair_jump.sh
fi
#创建crond定时任务，不想定时可注释掉以下两行，可能出现的问题就是游戏不稳帧
crond -c $MODDIR/root
/system/bin/sh $MODDIR/I_Control.sh
