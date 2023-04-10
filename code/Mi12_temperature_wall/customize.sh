#!/system/bin/sh
#修改GPU墙温度
#此修改非常危险，你需要知道:修改可能无法正常使用，甚至无法开机
#如果需要的话请填对应数字
#例如95℃，就填写Gpu_Temp=95
#默认不修改，就填Gpu_Temp=false
#建议90-110之间，绝不能大于115！！！
#
Gpu_Temp=false
#
name="`grep_prop name $TMPDIR/module.prop`"
author="`grep_prop author $TMPDIR/module.prop`"
description="`grep_prop description $TMPDIR/module.prop`"

echo "*********************"
echo "- 模块信息"
echo "- 名称: $name"
echo "- 作者：$author"
echo "- $description"
echo "*********************"

#芯片为高通8gen1
soc=$(cat /sys/devices/soc0/machine | tr 'A-Z' 'a-z')
if [[ "$soc" != "waipio" ]]; then
  echo "- 此模块仅适用于骁龙8gen1平台！！！"
  echo "- "
  echo "- 别傻逼！装了重启神仙都救不了你！"
  echo "- 已经阻止你安装！！！"
  exit 2
fi

#机型为2201123C(小米12)
model=$(getprop ro.product.model)
if [[ "$model" != "2201123C" ]]; then
  echo "- 你的机型为:$model"
  echo "- 此模块仅支持机型:2201123C！！！"
  echo "- "
  echo "- 别傻逼！装了重启神仙都救不了你！"
  echo "- 已经阻止你安装！！！"
  exit 2
fi

#不同安卓版本需要不同的devcfg
a_version=$(getprop ro.build.version.release)
if [ $a_version == "12" ]; then
img='a12/a12devcfg.mbn'
elif [ $a_version == "13" ]; then
img='a13/a13devcfg.mbn'
fi

echo "————————————————————————————————————"
echo "- 温馨提示：此模块存在一定风险"
echo "- 可能导致你的手机无法开机，黑砖等等"
echo "- 请你慎重决定是否继续安装"
echo "  + 音量加：是，自行承担后果，继续安装"
echo "  - 音量减：否，退出安装"
echo "————————————————————————————————————"
volume=1
action=1
sleep 0.5
echo "- 请根据提示按音量键进行选择！"
while [ $volume == 1 ]; do
action=`getevent -lqc 1`
if [[ "${action}" == "*KEY_VOLUMEUP*" ]];then 
volume=0
echo "- 为你安装！！！"
echo "- 出问题请自行负责！"
elif [[ "${action}" == "*KEY_VOLUMEDOWN*" ]];then
volume=0
echo "- 退出安装！！！"
exit 2
fi
done

unzip -o "$ZIPFILE" '*.sh' -d $MODPATH >&2
unzip -o "$ZIPFILE" 'devcfg.img' -d $MODPATH >&2
unzip -o "$ZIPFILE" '配置.prop' -d $MODPATH >&2


mkdir /data/media/0/Android/Mi12_temperature_wall
echo "sh /data/adb/modules/Mi12_temperature_wall/gpu_temp.sh
sh /data/adb/modules/Mi12_temperature_wall/refresh.sh" > /data/media/0/Android/Mi12_temperature_wall/免重启更新GPU温度墙.sh
echo "修改/data/media/0/Android/Mi12_temperature_wall/temp文件里的值(比如95℃就在里边直接填'95000')然后ROOT执行同目录下的'免重启更新GPU温度墙.sh'脚本文件就可以了，不需要重启手机。需要恢复官方温度，卸载模块重启手机即可。" > /data/media/0/Android/Mi12_temperature_wall/看我教你配置.txt
rm /data/media/0/Android/Mi12_temperature_wall/GPU温度墙路径.log | echo "${Gpu_Temp}000" > /data/media/0/Android/Mi12_temperature_wall/temp
echo "——————————————————————————————————————————
- 修改GPU温度墙温度为:$Gpu_Temp℃(false为不修改)
- GPU温度墙无需重启也生效
- GPU温度墙信息(有就是支持，没有就是不支持)
- 显示格式为: 名字 | 阈值(温度×1000) | 路径"

for i in $(ls -d /sys/class/thermal/thermal_zone*/*point_3_temp)
do
name=`cat "${i%/*}/type" | grep -Ei 'gpu|gpuss'`
value=`cat "${i}"`
if test "${name}" != "" ;then
	echo -e "- ${name} | ${value} | ${i}"
	echo "${i}">>/data/media/0/Android/Mi12_temperature_wall/GPU温度墙路径.log
	echo "${value}">/data/media/0/Android/Mi12_temperature_wall/value
fi
done
value=`cat /data/media/0/Android/Mi12_temperature_wall/value`
if [ "$Gpu_Temp" -ge "115" ]; then
echo $value > /data/media/0/Android/Mi12_temperature_wall/temp
echo "- GPU温度>=115℃会导致手机黑屏重启"
echo "- 将为你修改为系统默认"
fi
#根据自动查找GPU文件，修改GPU温度墙
sh gpu_temp.sh | echo "- GPU温度墙修改成功！"
chmod 777 /data/media/0/Android/Mi12_temperature_wall/*
echo "- 刷入立即生效！重启手机的60秒后才会生效！"

echo "——————————————————————————————————————————"

#当前系统卡槽
slot=$(getprop ro.boot.slot_suffix)
echo "- 修改CPU温度墙温度为:95℃"
echo "- 当前系统插槽：$slot"

if [[ -f $MODPATH/$img && -e /dev/block/by-name/devcfg$slot ]]; then
  dd if=$MODPATH/$img of=/dev/block/by-name/devcfg$slot
  echo "- CPU温度墙修改成功！"
  echo "- 刷入重启生效！更新系统才会失效！"
else
  echo "- 必要文件路径无法访问，CPU温度修改失败！"
  exit 2
fi
echo "——————————————————————————————————————————"
echo "- 安装完毕~"
echo "- 注意:"
echo "- 请使用'GPU GFLOPS'软件测试GPU温度墙是否修改成功。"
echo "- 请使用'Scene5'软件测试CPU温度墙是否修改成功。"
echo "- 安装此模块危险性较高，请及时备份数据后再重启手机"