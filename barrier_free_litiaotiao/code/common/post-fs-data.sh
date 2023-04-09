MODDIR=${0%/*}
lastVersion=$(getprop ro.build.version.incremental)
lastVersionFilePath=$MODDIR/lastVersion
productDirPath=$MODDIR/system/product
if [ ! -f $lastVersionFilePath ] || [ ! -d "$productDirPath"  ] || [ $(cat $lastVersionFilePath) != $lastVersion ] ; then
   mkdir -p ${productDirPath}
   cp -p -a -R /system/product/pangu/system/* ${productDirPath}
   echo "$lastVersion" >$lastVersionFilePath
fi

litiaotiaoapp=`pm list packages | grep "litiaotiao"`
if [ -n $litiaotiaoapp ]; then
  mkdir $MODDIR/temp
  AppPath=`pm path hello.litiaotiao.app | cut -d ":" -f2 |awk -F'base.apk' '{print$1}'`
  cp -rf $AppPath $MODDIR/temp/
  AppName=`ls $MODDIR/temp`
  mv $MODDIR/temp/$AppName $MODDIR/temp/LiTiaoTiao/
  cp -rf $MODDIR/temp/LiTiaoTiao $MODDIR/system/priv-app/
  if [ -f "$MODDIR/system/priv-app/LiTiaoTiao/base.apk" ];then
    rm -rf $MODDIR/system/priv-app/LiTiaoTiao/LiTiaoTiao.apk
    mv $MODDIR/system/priv-app/LiTiaoTiao/base.apk $MODDIR/system/priv-app/LiTiaoTiao/LiTiaoTiao.apk
  fi
  rm -rf $MODDIR/temp
fi