# Ideas-Swift

[![macOS 12.6+](https://img.shields.io/badge/macOS-12.6+-blue.svg)](https://support.apple.com/en-hk/HT213444/)
[![Xcode 14.0+](https://img.shields.io/badge/Xcode-14.0+-blue.svg)](https://developer.apple.com/xcode/)
[![iOS 12.0+](https://img.shields.io/badge/iOS-12.0+-blue.svg)](https://support.apple.com/zh-cn/HT209084/)
[![Swift 12.0+](https://img.shields.io/badge/Swift-5-blue.svg)](https://developer.apple.com/swift/)
[![CocoaPods](https://img.shields.io/badge/CocoaPods-compatible-brightgreen.svg)](https://github.com/cocoapods/cocoapods/)

iOS 使用 Swift5 开发的想法记录App。


## Screenshots
![](https://raw.githubusercontent.com/youlookwhat/Ideas-Swift/main/file/image.png)
![](https://raw.githubusercontent.com/youlookwhat/Ideas-Swift/main/file/image2.png)


## Features 特性
- 1.使用`RealmSwift`的增删改查
- 2.横竖屏的页面适配
- 3.深色模式
- 4.使用 ONE/金山词霸/扇贝单词/一言 Api
- 5.大标题导航栏的使用


### 用到的第三方库

 - [SDWebImage](https://github.com/SDWebImage/SDWebImage)：图片加载
 - [realm-swift](https://github.com/realm/realm-swift)：移动端数据库
 - [MJRefresh 3.2.2](https://github.com/CoderMJLee/MJRefresh)：下拉刷新，加载更多
 - [SnapKit](https://github.com/SnapKit/SnapKit)：自动布局
 - [AFNetworking 4.0](https://github.com/AFNetworking/AFNetworking)：数据请求



<!--
 - [YYModel](https://github.com/ibireme/YYModel)：json转bean
 - [SDWebImageWebPCoder](https://github.com/SDWebImage/SDWebImageWebPCoder)：图片加载webp
-->


### 打开项目
#### 1、安装cocoapods
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

#### 2、去项目根目录执行：`pod install`

#### 3、打开：`quote.xcworkspace`
如果找不到 snp 等，就单独引入 : `import SnapKit`


### Documents

- [开发中的问题记录](https://github.com/youlookwhat/Ideas-Swift/blob/main/file/ideas-questions.md)
- [quotes](https://github.com/vv314/quotes)：收集了一些每日一句的接口与网站。

## About me
 - **QQ：** 770413277
 - **简书：**[Jinbeen](https://www.jianshu.com/u/e43c6e979831)
 - **Blog：**[http://jinbeen.com](http://jinbeen.com)
