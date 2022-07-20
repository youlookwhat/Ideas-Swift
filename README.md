# flomo-offline

浮墨-离线版:

用于免费使用快捷指令存到App里(同时备份到备忘录)，然后存到足够多的条数时，同步到flomo里。这样可以一直使用快捷指令，而且不用长时间开会员。

### 特性
 - 1.使用快捷指令存到flomo里，不需要会员。
 - 2.可离线使用快捷指令
 - 3.不用担心数据丢失，因为备份了一份到备忘录。
 - 4.同步依赖flomo的会员API功能，一天可同步100条。


### 技术

 - [SDWebImage](https://github.com/SDWebImage/SDWebImage)：图片加载
 - [SDWebImageWebPCoder](https://github.com/SDWebImage/SDWebImageWebPCoder)：图片加载webp
 - [MJRefresh 3.2.2](https://github.com/CoderMJLee/MJRefresh)：下拉刷新，加载更多
 - [SnapKit](https://github.com/SnapKit/SnapKit)：自动布局
 - [AFNetworking 4.0](https://github.com/AFNetworking/AFNetworking)：数据请求
 - [MBProgressHUD](https://github.com/jdg/MBProgressHUD)：底部有页面，加载中的Progress
 - [YYModel](https://github.com/ibireme/YYModel)：json转bean


---

## Api
 - [quotes](https://github.com/vv314/quotes)：收集了一些每日一句的接口与网站。
 - ONE：一个的首页数据：[http://v3.wufazhuce.com:8000/api/channel/one/0/0](http://v3.wufazhuce.com:8000/api/channel/one/0/0)

----

### 安装MagazineLayout方法
> https://github.com/airbnb/MagazineLayout

首先安装`CocoaPods`

To install MagazineLayout using CocoaPods, add pod 'MagazineLayout' to your Podfile, then follow the integration tutorial [here](https://guides.cocoapods.org/using/using-cocoapods.html).

 - 1、使用 `cd` 进入项目根目录
 - 2、然后使用 `pod init` ，会创建一个 Podfile 文件
 - 3、然后安装三方的库，2种方式。使用 vim Podfile 打开文件：
	- `pod 'MagazineLayout'`
	- `pod 'SnapKit','~>3.0.2'`
 - 4、使用 `pod install` 安装
 - 5、最后 打开 `xcworkspace`文件

### xcode11新项目删除main.storyboard
> https://www.jianshu.com/p/e255303d11b8

指定项目打开的第一个页面：

 - 1、首先 选中工程文件选项，之后删除 Genaral -> Deployment Info -> Main Interface选项里的Main
 - 2、接着 删除在`info.plist`里的Application Scene Manifest条目
 - 3、注释：`application()-> UISceneConfiguration`、`application(,Set<UISceneSession>)`两个方法
 - 4、添加
```
window = UIWindow(frame: UIScreen.main.bounds)
let navigationController = UINavigationController(rootViewController: ViewController())
window?.rootViewController = navigationController
window?.makeKeyAndVisible()
```
 - 5、删除`main.storyboard `和`SceneDelegate.swift`，应该也可不删除


### 命令行配置
```
git config --global https.proxy http://127.0.0.1:1087
git config --global http.proxy http://127.0.0.1:1087
git config --global http.proxy socks5://127.0.0.1:1086
git config --global https.proxy socks5://127.0.0.1:1086

git config --global --unset http.proxy 
git config --global --unset https.proxy
```

### 问题

#### 1、解决不能执行`curl -L get.rvm.io | bash -s stable`问题：

https://github.com/hawtim/hawtim.github.io/issues/10

新增host，选择3.5.8版本
https://www.macwk.com/soft/switchhosts

#### 2、iOS-Xcode解决【workspace integrity couldn't load project'】

https://www.cnblogs.com/wangkejia/p/9835230.html

鼠标右击.xcodeproj文件 —>显示包内容 —>打开project.pbxproj文件，比较以前的版本号进行修改（比如：把objecVersion=50修改objecVersion=48即可打开工程）。


#### 3、安装ruby
 - 安装镜像 brew：https://zhuanlan.zhihu.com/p/90508170
 - 然后安装ruby
 - [安装cocoapods](https://wayou.github.io/2020/10/22/gem-install-%E6%97%B6%E6%9D%83%E9%99%90%E9%97%AE%E9%A2%98%E7%9A%84%E4%BF%AE%E6%AD%A3/)：gem cocoapods --user-install
 - pod install --verbose
	 - 出现问题：`curl: (7) Received invalid version in initial SOCKS5 response.`
		 - 	解决：https://blog.csdn.net/toopoo/article/details/123910453
		 -  或：https://blog.csdn.net/qxqxqzzz/article/details/105565213


#### 4、出现问题：`curl: (7) Received invalid version in initial SOCKS5 response.`

查看代理：`git config --global -l`
会发现SOCKS5的地址可能是不对的，然后再通过`git config --global https.proxy socks5://127.0.0.1:1086`配置正确的SOCKS5地址



#### 5、卡住在 Cloning spec repo ‘cocoapods‘ from ‘https://github.com/CocoaPods/Specs.git‘

`pod install --verbose`卡出在

```
Cloning spec repo `cocoapods-1` from `https://github.com/CocoaPods/Specs.git`
  $ /usr/bin/git clone https://github.com/CocoaPods/Specs.git -- cocoapods-1
  Cloning into 'cocoapods-1'...
```

部分参考：https://blog.csdn.net/csdn2314/article/details/116599288

解决方法：手动替换仓库

1、去国内镜像地址手动下载
`https://github.com/CocoaPods/Specs`
但是由于科学上网的原因，下载的异常慢，可以去国内镜像地址下载：
`https://gitee.com/mirrors/CocoaPods-Specs`

2、然后解压 放到
![cocoapods地址](https://img-blog.csdnimg.cn/47c884bbb43e47c89fddd2d2fca70855.png)

3、终端进入
`cd /Users/jingbin/.cocoapods/repos/cocoapods `

4、git 初始化
`git init`

会出现：
```
jingbin@jingbindeMBP cocoapods % git init
Initialized empty Git repository in /Users/jingbin/.cocoapods/repos/cocoapods/.git/
```

5、关联仓库
`git remote add origin https://github.com/CocoaPods/Specs`

6、查看是否正常
查看 `.git/config`里的配置
![](https://img-blog.csdnimg.cn/c9b6c50b8b574418a13b1755a03847b2.png)


#### 6、Сocoapods trunk URL couldn't be downloaded
如果替换了`Podfile`文件里的

```
source 'https://github.com/CocoaPods/Specs.git'
# source 'https://cdn.cocoapods.org/'
```
还是使用cdn出现：Сocoapods trunk URL couldn't be downloaded

则
`pod repo remove trunk`
再
`pod install --verbose`

### 7、Command PhaseScriptExecution failed with a nonzero exit code

After trying all the solutions, I was missing is to enable this option in:

**Targets -> Build Phases -> Embedded pods frameworks**

In newer versions it may be listed as:

**Targets -> Build Phases -> Bundle React Native code and images**

- 选中 Show enironment variables build log 
- 选中 Run script only when installing


 

### 9、升级系统后 git 不同
```
jingbin@jingbindeMBP ~ % git
xcrun: error: invalid active developer path (/Library/Developer/CommandLineTools), missing xcrun at: /Library/Developer/CommandLineTools/usr/bin/xcrun
jingbin@jingbindeMBP ~ % xcode-select --install 
xcode-select: note: install requested for command line developer tools
jingbin@jingbindeMBP ~ % 
```
使用`xcode-select --install`