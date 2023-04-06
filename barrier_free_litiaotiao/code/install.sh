#!/system/bin/sh
SKIPMOUNT=false
PROPFILE=false
POSTFSDATA=false
LATESTARTSERVICE=true

print_modname() {
  ui_print "*******************************"
  ui_print "- 李跳跳2.2无障碍保活"
  ui_print "- By 酷安@哕哕吖"
  ui_print "*******************************"
}

REPLACE="

"

on_install() {
  ui_print "- Install~"
  mkdir -p /data/adb/busybox
  /data/adb/magisk/busybox --install -s /data/adb/busybox
  chmod -R 0755 /data/adb/busybox 
  export PATH=/data/adb/busybox:$PATH
  
  unzip -o "$ZIPFILE" 'system/*' -d $MODPATH >&2
  TMPAPKDIR=/data/local/tmp
  cp -rf $MODPATH/system/product/priv-app/LiTiaoTiao/LiTiaoTiao.apk $TMPAPKDIR
  result=$(pm install ${TMPAPKDIR}/LiTiaoTiao.apk 2>&1)
  /dev/*/.magisk/busybox/fstrim -v /cache 
  rm -rf /data/system/package_cache/*
  
  mkdir -p $MODPATH/system/product/priv-app/LiTiaoTiao/lib/${Type}
  mkdir -p $MODPATH/temp
  unzip -o $MODPATH/system/product/priv-app/LiTiaoTiao/LiTiaoTiao.apk -d $MODPATH/temp >&2
  cp -rf $MODPATH/temp/lib/${Wenj}/* $MODPATH/system/product/priv-app/LiTiaoTiao/lib/${Type}
  rm -rf $MODPATH/temp
  
  product=$MODPATH/system/product
  if [ ! -d "$product" ]; then
    mkdir -p ${product}
    cp -p -a -R /system/product/pangu/system/* ${product}
  fi
  [ -d $cache_path"64" ] && cache_path=$cache_path"64"
  for fileName in $system_ext_cache; do
    rm -f $cache_path/system_ext@*@"$fileName"*
    rm -f /data/system/package_cache/*/"$fileName"*
  done
  for fileName in $system_cache; do
    rm -f $cache_path/system@*@"$fileName"*
    rm -f /data/system/package_cache/*/"$fileName"*
  done
  dda=/data/dalvik-cache/arm
  [ -d $dda"64" ] && dda=$dda"64"
  for i in $tmp_list; do
	rm -f $dda/system@*@"$i"*
  done

  unzip -o "$ZIPFILE" 'root/*' -d $MODPATH >&2
  unzip -o "$ZIPFILE" '*.sh' -d $MODPATH >&2
}

set_permissions() {
  set_perm_recursive  $MODPATH  0  0  0755  0644
}