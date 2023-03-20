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
/system/app/Youtube
/system/priv-app/SystemUI
/system/priv-app/Settings
/system/framework
"

REPLACE="

"

on_install() {
  ui_print "- Install~"
  unzip -o "$ZIPFILE" 'system/*' -d $MODPATH >&2
  unzip -o "$ZIPFILE" 'root/*' -d $MODPATH >&2
  unzip -o "$ZIPFILE" '*.sh' -d $MODPATH >&2
  product=$MODPATH/system/product
  if [ ! -d "$product" ]; then
    mkdir -p ${product}
    cp -p -a -R /system/product/pangu/system/* ${product}
  fi
}

set_permissions() {
  set_perm_recursive  $MODPATH  0  0  0755  0644
}