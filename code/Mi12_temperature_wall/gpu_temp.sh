#!/system/bin/sh
#根据自动查找GPU文件，修改GPU温度墙
temps=`cat /data/media/0/Android/Mi12_temperature_wall/temp`
value=`cat /data/media/0/Android/Mi12_temperature_wall/value`

if [ $temps = "false000" ] ; then
echo $value > /data/media/0/Android/Mi12_temperature_wall/temp
fi
if [ "$temps" -ge "115000" ]; then
echo $value > /data/media/0/Android/Mi12_temperature_wall/temp
echo "- GPU温度>=115℃会导致手机黑屏重启"
echo "- 已阻止你修改！！！"
fi

temp=`cat /data/media/0/Android/Mi12_temperature_wall/temp`
for i in $(cat /data/media/0/Android/Mi12_temperature_wall/GPU温度墙路径.log)
do
chmod -R 0777 $i
echo $temp > $i
chmod 0644 $i
done