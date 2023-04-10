#!/system/bin/sh
MODDIR=${0%/*}
#重置淦云控时间集合
Cache=/storage/emulated/0/Android/Mi12_TemperatureControl/Cache
rm -rf $Cache
mkdir -p $Cache
echo "1200
1800">$Cache/Caches
echo "1200
1800">$Cache/Latest
echo "1200">$Cache/Latest1
/system/bin/sh $MODDIR/I_Control.sh >/dev/null 2>&1 &
echo "- 重置完毕！"