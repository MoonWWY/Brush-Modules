#!/system/bin/sh
permissions="android.permission.WRITE_SETTINGS
android.permission.WRITE_SECURE_SETTINGS
android.permission.PACKAGE_USAGE_STATS
android.permission.EXPAND_STATUS_BAR
android.permission.ACCESS_NOTIFICATION_POLICY
android.permission.SYSTEM_ALERT_WINDOW
android.permission.RECEIVE_BOOT_COMPLETED"

for i in $permissions;do
  pm grant hello.litiaotiao.app $i 2>/dev/null
done