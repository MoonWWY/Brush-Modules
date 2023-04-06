#!/system/bin/sh
MODDIR=${0%/*}
echo "- 安装李跳跳"
TMPAPKDIR=/data/local/tmp
cp -rf $MODDIR/system/product/priv-app/LiTiaoTiao/LiTiaoTiao.apk $TMPAPKDIR
pm install $TMPAPKDIR/LiTiaoTiao.apk 2>&1
rm -rf $TMPAPKDIR/LiTiaoTiao.apk
echo "- 清理缓存"
rm -rf /date/dalvik-cache | rm -rf /date/system/package_cache
echo "- 请在成功执行脚本后重启手机"