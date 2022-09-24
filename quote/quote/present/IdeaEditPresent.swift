//
//  OnePresent.swift
//  quote
//
//  Created by 景彬 on 2022/5/1.
//  Copyright © 2022 景彬. All rights reserved.
//

import UIKit

/*
 * Idea编辑页
 */
class IdeaEditPresent{

    
    // 设置布局
    public func setContentView(_ view:UIView) {
        // 输入框
        view.addSubview(commentTextView)
        
        // 底部栏
        let uiView = UIView()
        uiView.backgroundColor = .white
        uiView.addSubview(lineLabel)
        uiView.addSubview(tipsLabel)
        uiView.addSubview(sendBtn)
        view.addSubview(uiView)
        
        commentTextView.snp.makeConstraints{ make in
            make.height.equalTo(kScreenHeight-kNavigationBarHeight-kBottomMargin-58)
            make.width.equalTo(Screen.width)
            make.top.equalToSuperview().offset(kNavigationBarHeight)
        }
        
        uiView.snp.makeConstraints{ make in
            make.height.equalTo(59)
            make.width.equalTo(Screen.width)
//            make.bottom.equalToSuperview().offset(kBottomMargin)
            make.left.right.bottom.equalToSuperview()
        }
        
        lineLabel.snp.makeConstraints { make in
            make.height.equalTo(lineHeight)
            make.width.equalTo(Screen.width)
            // 一定要设置top位置
            make.top.equalToSuperview()
        }
        tipsLabel.snp.makeConstraints { make in
            make.height.equalTo(58)
            make.width.equalTo(58)
            make.top.equalTo(lineLabel.snp.bottom)
        }
        sendBtn.snp.makeConstraints { make in
            make.right.equalTo(-15)
//            make.bottom.equalTo(-10)
            make.height.equalTo(28)
            make.width.equalTo(54)
            make.centerY.equalToSuperview()
//            make.top.equalTo(lineLabel.snp.bottom)
        }
//        backView.snp.makeConstraints { make in
//            make.left.right.bottom.equalToSuperview()
//        }
        
    }
    
    /// 线
    lazy var lineLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = .gray
        return label
    }()
    
    /// 井号
    lazy var tipsLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.text = "#"
        label.font = .font20M
        label.textColor = .colorB5
        label.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(clickJin)))
        label.isUserInteractionEnabled = true
        return label
    }()
    
    
    /// 发送按钮
    @objc var sendBtn: UIButton = {
        let button = UIButton(type: .custom)
        button.backgroundColor = .colorF7
        button.setTitle("记录", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 14
        button.titleLabel?.font = UIFont.font13
//        button.titleLabel?.font = UIFont.mediumSystemFont(ofSize: 14)
//        button.addTarget(self, action: #selector(sendBtnClik(_:)), for: .touchUpInside)
        return button
    }()
    
    /// 编辑区底部view
    @objc lazy var editBackView: UIView = {
        let icon = UIView()
        icon.layer.cornerRadius = 10
        icon.backgroundColor = .colorF6
        return icon
    }()
 
    /// 发布内容
    @objc var commentTextView: UITextView = {
        let textView = UITextView(frame: CGRect(x: 0, y: kNavigationBarHeight, width: kScreenWidth - 30, height: kScreenHeight-kNavigationBarHeight-kBottomMargin))
        textView.backgroundColor = .clear
        textView.font = .font14
        textView.textColor = .color32
//        textView.textContainerInset = UIEdgeInsets(top: 10, left: 5, bottom: 10, right: 10)
        
//        textView.cm_placeholder = "现在的想法是..."
//        textView.cm_placeholderColor = .colorB5
//        textView.cm_maxNumberOfLines = 0
//        textView.cm_autoLineBreak = true;
//        textView.delegate = self
//        textViewDidChange(textView)
        return textView
    }()
    

    
    @objc func clickJin(){
        // 加上井号
        let strings = commentTextView.text.trimmingCharacters(in: .whitespaces)
        if strings.count>0 {
            commentTextView.text = "\(strings) #"
        } else {
            commentTextView.text = "\(strings)#"
        }
    }
}

extension UITextView: UITextViewDelegate {
        
    public func textViewDidChange(_ textView: UITextView,sendBtn: UIButton ) {
        
        let strings = textView.text.trimmingCharacters(in: .whitespaces)
        if String.isEmpty(strings) {
            sendBtn.backgroundColor = .colorF7
            sendBtn.isUserInteractionEnabled = false
        } else {
            sendBtn.backgroundColor = .colorTheme
            sendBtn.isUserInteractionEnabled = true
        }
    }
    
}
