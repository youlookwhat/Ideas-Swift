# ByQuoteAppSwift
每日一句App，用于使用Swift开发iOS App


### 问题：解决不能执行`curl -L get.rvm.io | bash -s stable`问题：

https://github.com/hawtim/hawtim.github.io/issues/10

新增host，选择3.5.8版本
https://www.macwk.com/soft/switchhosts

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


### 问题：iOS-Xcode解决【workspace integrity couldn't load project'】


> https://www.cnblogs.com/wangkejia/p/9835230.html

> 鼠标右击.xcodeproj文件 —>显示包内容 —>打开project.pbxproj文件，比较以前的版本号进行修改（比如：把objecVersion=50修改objecVersion=48即可打开工程）。


 - [SDWebImage](https://github.com/SDWebImage/SDWebImage)：图片加载
 - [SDWebImageWebPCoder]()
 - [MJRefresh](https://github.com/CoderMJLee/MJRefresh)：下拉刷新，加载更多
 - [MagiRefresh](swift下拉刷新)：https://github.com/AnRanScheme/MagiRefresh
 - [SnapKit]()：自动布局
 - [Moya]()：数据请求
 - Alamofire-5.5.0
 - SwiftyJSON-5.0.1(可不用)











 

