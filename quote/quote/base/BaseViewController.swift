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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // 创建工具条
        toolView = UIView(frame: CGRect(x: 0, y: statusBarHeight, width: self.view.frame.width, height: 44))
        self.view.addSubview(toolView)
        
        
        // 返回图片
        let image = UIImage(named: "iv_left_back")?.withRenderingMode(.alwaysTemplate)
        ivBack = UIImageView(image: image)
        ivBack.tintColor = UIColor(lightThemeColor: .black, darkThemeColor: .white)
        ivBack.contentMode = .scaleAspectFit
        ivBack.frame = CGRect(x: 0, y: 0, width: 44, height: 44)
        // 给图片加点击事件
        let singleTapGesture = UITapGestureRecognizer(target: self, action: #selector(navBtnPress))
        ivBack.addGestureRecognizer(singleTapGesture)
        ivBack.isUserInteractionEnabled = true
        ivBack.isHidden = false
        toolView.addSubview(ivBack)
    }
    
    public func hideTitleLayout(){
        toolView.isHidden = true
    }
    
    // 后退
    @objc func navBtnPress(){
        finish()
    }

    func finish(){
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
