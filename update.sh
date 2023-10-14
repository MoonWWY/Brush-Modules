#git clone https://github.com/MoonWWY/Brush-Modules.git
git init | echo "初始化"
git add . | echo "添加文件到暂存区"
git commit -m "update" | echo "提交到git仓库"
git branch -M main | echo "上传到main分支"
git remote add origin https://github.com/MoonWWY/Brush-Modules.git | echo "和远程仓库连接"
git push -u origin main | echo "上传远程仓库"
git pull https://github.com/MoonWWY/Brush-Modules.git | echo "同步：仓库->本地"
echo "上传完成！"