# GitHub常用命令

####GitHub安装(mac环境)
1.先安装homebrew
homebrew安装非常简单,在终端输入以下命令,回车执行
> ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"

2.homebrew使用:(搜索,安装,卸载)
brew search 软件名
brew install 软件名
brew remove 软件名

3.安装git
> brew install git

4.设置用户名
> git config --global user.name "zaintan"
> git config --global user.email "tzytclzxh@qq.com"

####创建Git版本库
cd 到待设的目录路径下
> cd /Users/tanzhenyu/Desktop/DDZProject
执行初始化git版本库目录 (目录可以非空)
> git init 

####添加文件
> git add help.txt

####提交文件(与svn ci命令类似 支持一次提交多个操作)
> git commit -m "添加帮助文件"


