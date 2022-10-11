//
//  BaseViewController.swift
//  quote
//
//  Created by 景彬 on 2022/7/13.
//  Copyright © 2022 景彬. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController {

    var ivBack:UIImageView! = nil
    var toolView:UIView! = nil
    var indicatorView:UIActivityIndicatorView?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // 创建工具条
        toolView = UIView(frame: CGRect(x: 0, y: statusBarHeight, width: self.view.frame.width, height: 44))
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
        ivBack.isHidden = false
        toolView.addSubview(ivBack)
    }
    
    // 隐藏标题栏
    public func hideTitleLayout(){
        toolView.isHidden = true
        toolView.removeFromSuperview()
    }
    
    // 点击返回
    @objc func navBtnPress(){
        finish()
    }

    // 退出页面
    func finish(){
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
    
    // 显示加载菊花
    func showLoading() {
        if indicatorView == nil {
            indicatorView = UIActivityIndicatorView (style: .gray)
            indicatorView?.color = .gray;
            self.view.addSubview(indicatorView!)
            indicatorView?.snp.remakeConstraints { make in
                make.left.right.top.bottom.equalToSuperview()
            }
        }
        if !indicatorView!.isAnimating {
            indicatorView?.startAnimating()
        }
    }
    // 取消加载
    func stopLoading(){
        if indicatorView != nil {
            if indicatorView!.isAnimating {
                indicatorView?.stopAnimating()
            }
            indicatorView?.removeFromSuperview()
            indicatorView = nil
        }
    }

}

import SafariServices

extension BaseViewController {
    
    func openUrl(urlString:String){
        if let url = URL(string: urlString) {
            // 使用浏览器打开 根据iOS系统版本，分别处理
//            if #available(iOS 10, *) {
//                UIApplication.shared.open(url, options: [:],completionHandler: {(success) in})
//            } else {
//                UIApplication.shared.openURL(url)
//            }
            // 应用内使用Safari打开
            let safariVC = SFSafariViewController(url: url)
            self.present(safariVC, animated: true, completion: nil)
        }
    }
}
