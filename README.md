# ByQuoteAppSwift
每日一句App，用于使用Swift开发iOS App


 - [SDWebImage](https://github.com/SDWebImage/SDWebImage)：图片加载
 - [SDWebImageWebPCoder]()
 - [MJRefresh](https://github.com/CoderMJLee/MJRefresh)：下拉刷新，加载更多
 - [MagiRefresh](https://github.com/AnRanScheme/MagiRefresh)：swift下拉刷新
 - [SnapKit]()：自动布局
 - [Moya]()：数据请求
 - Alamofire-5.5.0
 - SwiftyJSON-5.0.1(可不用)


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









 

