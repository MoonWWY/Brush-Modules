#!/system/bin/sh
function Initialization_file(){
ModuleAdd=/data/adb/modules/Mi12_TemperatureControl
thermals=`ls /system/bin/*thermal* /system/etc/init/*thermal* /system/etc/perf/*thermal* /system/vendor/bin/*thermal* /system/vendor/etc/*thermal* /system/vendor/etc/powerhint* /system/vendor/etc/init/*_thermal* /system/vendor/etc/perf/*thermal* /system/vendor/lib/hw/thermal* /system/vendor/lib64/hw/thermal* 2>/dev/null | grep -v mi_thermald | grep -v thermal-engine.conf | grep -v thermal-normal.conf | grep -v thermal-map.conf | grep -v thermal-engine | grep -v thermalserviced | grep -v "*.so"`

for thermal in $thermals; do
  [[ ! -d $ModuleAdd/thermals/${thermal%/*} ]] && mkdir -p $ModuleAdd/thermals/${thermal%/*}
  touch $ModuleAdd/thermals/$thermal
done

systems="/system/bin /system/etc/init /system/etc/perf /system/vendor/bin /system/vendor/etc /system/vendor/etc /system/vendor/etc/init /system/vendor/etc/perf /system/vendor/lib/hw /system/vendor/lib64/hw"
for system in $systems; do
  if [ -d "$system" ];then
    mkdir -p $ModuleAdd/$system
  fi
done

cp -rf $ModuleAdd/thermals/system/ $ModuleAdd
rm -rf $ModuleAdd/thermals/
}
Initialization_file

chattr -R -i /data/system/mcd
mkdir /data/system/mcd
chmod 755 /data/system/mcd