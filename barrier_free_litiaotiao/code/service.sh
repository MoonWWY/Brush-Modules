#!/system/bin/sh
MODDIR=${0%/*}
chmod -R 777 $MODDIR/root
crond -c $MODDIR/root
sleep 10s
/system/bin/sh $MODDIR/permissions.sh
/system/bin/sh $MODDIR/barrier_free_litiaotiao.sh