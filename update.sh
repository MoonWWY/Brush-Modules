echo "初始化"
git init
echo "添加文件到暂存区"
git add .
echo "提交到git仓库"
git commit -m "update"
echo "上传到main分支"
git branch -M main
#echo "和远程仓库连接"
#git remote add origin https://github.com/yys5014/Brush-Modules
echo "上传远程仓库
git push -u origin main
echo "上传完成！"