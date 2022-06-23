//
//  WebViewViewController.swift
//  quote
//
//  Created by 景彬 on 2022/6/22.
//  Copyright © 2022 景彬. All rights reserved.
//

import UIKit
import WebKit

class WebViewViewController: UIViewController, WKScriptMessageHandler {

    var webview:WKWebView! = nil
    var bt1:UIButton? = nil
    var bt2:UIButton? = nil
    var progress:UIProgressView! = nil
    var url:String? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.tabBarItem.title = "网页"
        view.backgroundColor = UIColor(lightThemeColor: .white, darkThemeColor: .black)
        

        // Do any additional setup after loading the view.
        
//        self.tabBarItem.badgeValue = "新消息"
//        self.tabBarItem.badgeColor = UIColor.orange
        
        initWKWebView()
        addToolView()
    }
    
    func initWKWebView(){
        // 创建网页配置
        let config = WKWebViewConfiguration()

        
        // 配置线程池
//        let pool = WKProcessPool()
//        config.processPool = pool
        
        // 偏好配置
        let preference =  WKPreferences()
        // 网页界面的最小字体
        preference.minimumFontSize = 0
        // 是否支持js交互
        preference.javaScriptEnabled = true
        // 是否允许不经过用户交互由js代码自动打开窗口
        preference.javaScriptCanOpenWindowsAutomatically = true
        config.preferences = preference
        
        // 原生与js交互配置
        let useController = WKUserContentController()
        useController.add(self, name: "ios")
        
        // 向网页注入一段js代码
        let jsString = "function userFunc(){window.webkit.messageHandlers.ios.postMessage({\"name\":\"jingbin\"})};userFunc()"
        // forMainFrameOnly 是否只在主界面注入
        let userScript = WKUserScript(source: jsString, injectionTime: .atDocumentStart, forMainFrameOnly: false)
        useController.addUserScript(userScript)
        config.userContentController = useController
    
        // 要将config配置后再传入进来
        webview = WKWebView(frame: viewBounds(top: 0, bottom: kBottomMargin), configuration: config)
        webview?.isOpaque = false
        webview?.backgroundColor = UIColor(lightThemeColor: .white, darkThemeColor: .black)
        self.view.addSubview(webview!)
//        let url = URL(string: "https://jinbeen.com")
        let url = URL(string: url!)
        let request = URLRequest(url: url!)
        webview!.load(request)
        
        webview.isHidden = true
        
        // 执行网页中的js方法
//        webview?.evaluateJavaScript("javaScript:userFunc()", completionHandler: nil)
    }
    
    
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        // { name = jingbin;} ios
        // 如果是 班级：景彬，会是\U9ad8字样
        print(message.body,message.name)
    }
    
    
    func addToolView(){
        // 创建工具条
        let toolView = UIView(frame: CGRect(x: 0, y: self.view.frame.size.height-120, width: self.view.frame.width, height: 30))
        toolView.backgroundColor = UIColor.purple
        self.view.addSubview(toolView)
        // 添加返回按钮
        bt1 = UIButton(frame: CGRect(x: 30, y: 0, width: 70, height: 30))
        bt1!.setTitle("后退", for: .normal)
        bt1!.setTitleColor(UIColor.lightGray, for: .disabled)
        bt1!.addTarget(self, action: #selector(back), for: .touchUpInside)
        // 添加前进按钮
        bt2 = UIButton(frame: CGRect(x: 130, y: 0, width: 70, height: 30))
        bt2!.setTitle("前进", for: .normal)
        bt2!.setTitleColor(UIColor.lightGray, for: .disabled)
        bt2!.addTarget(self, action: #selector(goForward), for: .touchUpInside)
        toolView.addSubview(bt1!)
        toolView.addSubview(bt2!)
        
        toolView.isHidden = true
        
        // 加载进度条
        progress = UIProgressView(frame: CGRect(x: 0, y: kNavigationBarHeight, width: self.view.frame.size.width, height: 1))
        // 进度颜色
        progress!.progressTintColor = UIColor.systemBlue
        // 进度条底色
        progress.trackTintColor = UIColor.clear
        progress!.progress = 0
        self.view.addSubview(progress!)
        webview?.addObserver(self, forKeyPath: "estimatedProgress", options: .new, context: nil)
        
     }
    
    
    // 监听网页进度的变化
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        progress?.progress = Float(webview!.estimatedProgress)
        print("----进度 \(progress!.progress)")
        if progress!.progress==1 {
            // 延迟2秒显示webview
            webview.isHidden = false
            
            progress.isHidden = true
            if #available(iOS 13.0, *) {
                if (traitCollection.userInterfaceStyle == .dark){
                    changeTextBackgroundStyle()
                } else {
                    changeTextBackgroundStyle(style: "light")
                }
            }
        } else {
            progress.isHidden = false
        }
    }
        
    // 后退
    @objc func back(){
        if webview!.canGoBack {webview?.goBack()}
    }

    // 前进
    @objc func goForward(){
        webview?.goForward()
        // 执行网页中的js方法
        webview?.evaluateJavaScript("javaScript:userFunc()", completionHandler: nil)
    }

    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        if #available(iOS 13.0, *) {
            if (traitCollection.userInterfaceStyle == .dark){
                changeTextBackgroundStyle()
            } else {
                changeTextBackgroundStyle(style: "light")
            }
        }
    }

    // 设置字体背景 暗黑 白色
    func changeTextBackgroundStyle(style : String = "dark"){
        webview?.backgroundColor = UIColor(lightThemeColor: .white, darkThemeColor: .black)
       if style == "dark" {
           //字体颜色
           self.webview.evaluateJavaScript("document.getElementsByTagName('body')[0].style.webkitTextFillColor= '#F8F8FF'", completionHandler: nil)

           //背景颜色
           self.webview.evaluateJavaScript("document.body.style.backgroundColor=\"#1E1E1E\"", completionHandler: nil)
           
           self.webview.evaluateJavaScript("document.body.style.webkitTextFillColor=\"#7E9EB3\"", completionHandler: nil)
    
       }else{
           self.webview.evaluateJavaScript("document.getElementsByTagName('body')[0].style.webkitTextFillColor= '#000000'", completionHandler: nil)
           self.webview.evaluateJavaScript("document.body.style.backgroundColor=\"#FFFFFF\"", completionHandler: nil)

       }
   }
    
    // 已经从屏幕中移除 如果使用viewWillDisappear，左滑的时候会执行
    override func viewDidDisappear(_ animated: Bool) {
        progress.isHidden = true
        // 移除，消除音频声音
        webview.removeFromSuperview()
        webview.stopLoading()
        webview = nil
    }
    
}
