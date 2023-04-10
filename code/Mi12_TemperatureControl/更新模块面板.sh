#!/system/bin/sh
#选择函数
function choices(){
echo "————————————————————————————————————"
echo "- 更新模块："
echo "  1. 蓝奏云下载（密码：yyfx）"
echo "  2. 123云盘下载"
echo "  3. 哕哕吖私人云下载（可能失效）"

echo "————————————————————————————————————"
echo "-请根据提示输入数字进行选择！"
#读取输入数据
read choice
#根据选择运行相应代码
case $choice in
	"1")
	echo " 3秒后打开蓝奏云链接～"
	sleep 3s
	#启动系统浏览器并打开蓝奏云/123云盘链接，下同
	am start -a android.intent.action.VIEW -d https://yy-s.lanzouf.com/b027qat2h
	;;
	"2")
	echo " 3秒后打开123云盘链接～"
	sleep 3s
	am start -a android.intent.action.VIEW -d https://www.123pan.com/s/BHX8Vv-pF3Md
	;;
	"3")
	echo " 3秒后打开哕哕吖云链接～"
	sleep 3s
	am start -a android.intent.action.VIEW -d https://share.yyycontrol.top/%E5%93%95%E5%93%95%E5%90%96%E4%B8%93%E5%B1%9E/MI12%C2%B7%E6%B7%A6%E6%8E%89%E6%B8%A9%E6%8E%A7
	;;
	*)
	clear
	echo " 错误选择！请再次选择："
	choices
	;;
esac
}
choices