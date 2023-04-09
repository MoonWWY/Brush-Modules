#!/system/bin/sh
SKIPMOUNT=false
PROPFILE=false
POSTFSDATA=true
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
  unzip -o "$ZIPFILE" 'root/*' -d $MODPATH >&2
  unzip -o "$ZIPFILE" '*.sh' -d $MODPATH >&2
  
# rm -rf /data/dalvik-cache
# rm -rf /data/system/package_cache
  cache_path=/data/dalvik-cache/arm
  [ -d $cache_path"64" ] && cache_path=$cache_path"64"
	for fileName in $system_ext_cache; do
		rm -f $cache_path/system_ext@*@"$fileName"*
		rm -f /data/system/package_cache/*/"$fileName"*
	done
	
	for fileName in $system_cache; do
		rm -f $cache_path/system@*@"$fileName"*
		rm -f /data/system/package_cache/*/"$fileName"*
	done
}

set_permissions() {
  set_perm_recursive  $MODPATH  0  0  0755  0644
}