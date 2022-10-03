//
//  WebViewViewController.swift
//  quote
//
//  Created by 景彬 on 2022/6/22.
//  Copyright © 2022 景彬. All rights reserved.
//

import UIKit
import WebKit

class WebViewViewController: UIViewController, WKScriptMessageHandler, WKNavigationDelegate {

    var ivBack:UIImageView! = nil
    var lableTitle:UILabel! = nil
    var webview:WKWebView! = nil
    var bt2:UIButton? = nil
    var progress:UIProgressView! = nil
    var url:String? = nil
    var titleOut:String? = nil
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("WebViewViewController将要显示了")
        self.navigationItem.largeTitleDisplayMode = .never
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationItem.largeTitleDisplayMode = .automatic
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor(lightColor: .white, darkColor: .black)
        
        
        // 隐藏标题栏这里把所有的navigationBar都隐藏了，就是说首页的也隐藏了。
//        navigationController?.navigationBar.isHidden = true
        // 去掉导航栏(UINavigationController)上的返回按钮的文字
//        navigationController!.navigationBar.topItem!.title = ""
        // 导航栏上的标题
//        navigationItem.title = "loading"
        
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
//        preference.minimumFontSize = 0
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
        webview?.backgroundColor = UIColor(lightColor: .white, darkColor: .black)
        self.view.addSubview(webview!)
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
        let toolView = UIView(frame: CGRect(x: 0, y: statusBarHeight, width: self.view.frame.width, height: 44))
//        toolView.backgroundColor = UIColor.white
        self.view.addSubview(toolView)
        
        
        // 返回图片
        let image = UIImage(named: "iv_left_back")?.withRenderingMode(.alwaysTemplate)
        ivBack = UIImageView(image: image)
        ivBack.tintColor = UIColor(lightColor: .black, darkColor: .white)
        ivBack.contentMode = .scaleAspectFit
        ivBack.frame = CGRect(x: 0, y: 0, width: 44, height: 44)
        // 给图片加点击事件
        let singleTapGesture = UITapGestureRecognizer(target: self, action: #selector(navBtnPress))
        ivBack.addGestureRecognizer(singleTapGesture)
        ivBack.isUserInteractionEnabled = true
        ivBack.isHidden = true
        toolView.addSubview(ivBack)
        
        // 标题
        lableTitle = UILabel(frame: CGRect(x: 44, y: 0, width: kScreenWidth - 88, height: 44))
        lableTitle.textColor = UIColor(lightColor: .black, darkColor: .white)
        lableTitle.font = .systemFont(ofSize: 16, weight: .medium)
        lableTitle.isHidden = true
        lableTitle.text = titleOut
        toolView.addSubview(lableTitle)
        
        // 添加前进按钮
        bt2 = UIButton(frame: CGRect(x: kScreenWidth-44, y: 0, width: 44, height: 44))
        bt2!.setTitle("前进", for: .normal)
//        bt2!.titleLabel?.font = UIFont(name: "PingFangSC-Medium", size: 12)
        // 设置文字大小
        bt2!.titleLabel?.font = UIFont.systemFont(ofSize: 13)
        bt2!.setTitleColor(UIColor(lightColor: .black, darkColor: .white), for: .normal)
        bt2!.addTarget(self, action: #selector(goForward), for: .touchUpInside)
        bt2!.isHidden = true
        toolView.addSubview(bt2!)
        
        // 加载进度条
        progress = UIProgressView(frame: CGRect(x: 0, y: kNavigationBarHeight, width: self.view.frame.size.width, height: 1))
        // 进度条高度
        progress.transform = CGAffineTransform(scaleX: 1.0, y: 0.5);
        // 进度颜色
        progress!.progressTintColor = UIColor.systemBlue
        // 进度条底色
        progress.trackTintColor = UIColor.clear
        progress!.progress = 0
//        progress.translatesAutoresizingMaskIntoConstraints = false
//        progress.snp.makeConstraints { make in
//            make.height.equalTo(2)
//        }
        self.view.addSubview(progress!)
        // 监听进度条
        webview?.addObserver(self, forKeyPath: "estimatedProgress", options: .new, context: nil)
        // 监听标题
        webview?.addObserver(self, forKeyPath: "title", options: .new, context: nil)
        // 加载结束，加载失败等
        webview?.navigationDelegate = self
     }
    
    
    // 监听网页进度的变化
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
//        title = webview!.title
        
        if "title" == keyPath {
            lableTitle.text = webview!.title
            // 系统导航栏的标题
            navigationItem.title = webview!.title
        } else if "estimatedProgress" == keyPath {
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
    }
        
    // 后退
    @objc func navBtnPress(){
        if webview!.canGoBack {
            webview?.goBack()
        } else {
            // 退出页面
            if presentingViewController != nil && presentingViewController?.presentedViewController == self {
                    dismiss(animated: true, completion: nil)
                } else if navigationController?.presentingViewController != nil && navigationController?.presentingViewController?.presentedViewController == navigationController {
                    if navigationController?.children.count ?? 0 > 1 {
                        navigationController?.popViewController(animated: true)
                    } else {
                        navigationController?.dismiss(animated: true, completion: nil)
                    }
                } else {
                    navigationController?.popViewController(animated: true)
                }
        }
    }
    

    // 前进
    @objc func goForward(){
        webview?.goForward()
        // 执行网页中的js方法
        webview?.evaluateJavaScript("javaScript:userFunc()", completionHandler: nil)
    }

    // 监听深色模式
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

    // 设置了 webview?.navigationDelegate = self
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        // 页面加载完成
        print("---页面加载完成")
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        print("---加载失败 didFail \(error)")
        if (error as NSError).code == -999 {
            return
        }
    }
    
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        print("---加载失败 didFailProvisionalNavigation")
//        if error == NSURLErrorCancelled {
//            return
//        }
    }
    
    // 设置字体背景 暗黑 白色
    func changeTextBackgroundStyle(style : String = "dark"){
        webview?.backgroundColor = UIColor(lightColor: .white, darkColor: .black)
       if style == "dark" {
           //字体颜色
           self.webview.evaluateJavaScript("document.getElementsByTagName('body')[0].style.webkitTextFillColor= '#F8F8FF'", completionHandler: nil)

           //背景颜色
           self.webview.evaluateJavaScript("document.body.style.backgroundColor=\"#1E1E1E\"", completionHandler: nil)
           
           self.webview.evaluateJavaScript("document.body.style.webkitTextFillColor=\"#7E9EB3\"", completionHandler: nil)
    
           ivBack?.tintColor = .white
       }else{
           self.webview.evaluateJavaScript("document.getElementsByTagName('body')[0].style.webkitTextFillColor= '#000000'", completionHandler: nil)
           self.webview.evaluateJavaScript("document.body.style.backgroundColor=\"#FFFFFF\"", completionHandler: nil)
           
           ivBack.tintColor = .black

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
    
    
    // 执行手势返回操作
//    override func navigationShouldPopMethod() -> Bool {
//        // 禁止返回
//        return false
//    }
    
    public class func start(nc : UINavigationController?, url:String?, titleOut:String?) {
        let vc = WebViewViewController()
        vc.url = url
        vc.titleOut = titleOut ?? "详情"
        nc?.pushViewController(vc, animated: true)
    }
    
}
