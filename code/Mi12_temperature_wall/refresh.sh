#更新信息
Mod_information=/data/adb/modules/Mi12_temperature_wall/module.prop
Refresh=`cat /sys/class/thermal/thermal_zone46/trip_point_3_temp`
thousand=1000
Refreshs=`expr $Refresh / $thousand`
sed -i "/^description=/c description=仅适用于小米12，系统MIUI13+/14+。恢复CPU温度墙95℃，修改GPU温度墙(默认不修改，需要修改请在模块的customize.sh中更改)。配置目录：/data/media/0/Android/Mi12_temperature_wall。当前GPU墙温度[ $Refreshs℃ ]" "$Mod_information"