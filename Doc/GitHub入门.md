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
单个文件:
> git add help.txt
多个文件:在根目录
> git add .

####提交文件(与svn ci命令类似 支持一次提交多个操作)
> git commit -m "添加帮助文件"
ps:注意工作区与缓存区的概念 在每次的`git commit`之前先调用`git add`是个好习惯(每次修改，如果不add到暂存区，那就不会加入到commit中)
与svn不一样的是,git是分布式的,svn是集中式的,所以git有个暂存区的概念,本地所做的commit会提交的暂存区,再与其他分布仓库同步----

####查看当前版本库的状态
> git status

####查看上次修改内容
> git diff filename

#####查看历史记录
> git log

####回退版本--撤销缓存区的修改  注意工作区如果有更改也会被清掉
> git reset --hard 版本号
版本号 支持两种方式 
一种是通过git log可以查看到的版本号(一个很大的数值 `3628164...882e1e0` 之类的)
另一种是 通过相对当前版本 在Git中，用`HEAD`表示当前版本,上一个版本就是`HEAD^`，上上一个版本就是`HEAD^^`，当然往上100个版本写100个^比较容易数不过来，所以写成`HEAD~100`

####撤销工作区的修改
> git checkout -- file
ps: `--`很重要,没有`--`,就变了切换分支命令

###远程仓库
1. 命令行输入`ssh-keygen -t rsa -C "tzytclzxh@qq.com"`
2. 3个回车得到两个文件`id_rsa`和`id_rsa.pub`  
3. 登录github,`Settings`->`SSH and GPG keys`->`New SSH key` title随意输入,Key文本框里粘贴`id_rsd.pub`文件内容`
4. `New repository`,输入仓库名字,其他默认，然后点击`create repository`
5. 在本地仓库根目录下 命令行输入`git remote add origin git@github.com:zaintan/DDZProject.git`   这样就将本地仓库与远程仓库关联起来了 
6. 使用命令`git push -u origin master` 第一次推送master分支的所有内容 以后的提交不必再加-u参数

####从远程仓库下载
使用`git clone https://github.com/zaintan/DDZProject.git`命令

