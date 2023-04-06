#!/system/bin/sh
rm -rf /data/adb/modules/barrier_free_litiaotiao
rm -rf /date/system/package_cache
dda=/data/dalvik-cache/arm
[ -d $dda"64" ] && dda=$dda"64"
for i in $tmp_list; do
	rm -f $dda/system@*@"$i"*
done