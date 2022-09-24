//
//  OnePresent.swift
//  quote
//
//  Created by 景彬 on 2022/9/24.
//  Copyright © 2022 景彬. All rights reserved.
//

import UIKit

/*
 * Idea编辑页
 */
class IdeaEditPresent {

    var navigation :IdeaEditNavigation?
    
    init(_ navigation : IdeaEditNavigation) {
        self.navigation = navigation
    }
    
    var uiBottomView:UIView!
    
    // 设置布局
    public func setContentView(_ view:UIView) {
        // 输入框
        view.addSubview(commentTextView)
        
        // 底部栏
        uiBottomView = UIView()
        uiBottomView.backgroundColor = .white
        uiBottomView.addSubview(lineLabel)
        uiBottomView.addSubview(jinLabel)
        uiBottomView.addSubview(sendBtn)
        view.addSubview(uiBottomView)

        commentTextView.snp.makeConstraints{ make in
            make.top.equalToSuperview().offset(kNavigationBarHeight)
            // 这里设置才能使输入框一直在底部栏之上
            make.bottom.equalTo(uiBottomView.snp.top).offset(1)
            make.width.equalTo(Screen.width)
        }
        
        uiBottomView.snp.makeConstraints{ make in
            make.height.equalTo(50)
            make.width.equalTo(Screen.width)
            // 要处理指示器的高度，需要单独在uiBottomView底部设置
            make.left.right.bottom.equalToSuperview()
        }
        
        lineLabel.snp.makeConstraints { make in
            make.height.equalTo(lineHeight)
            make.width.equalTo(Screen.width)
            // 一定要设置top位置
            make.top.equalToSuperview()
        }
        // #号
        jinLabel.snp.makeConstraints { make in
            make.height.equalTo(49)
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
        
        // 点击发布
        sendBtn.addTarget(self, action: #selector(sendBtnClik(_:)), for: .touchUpInside)
        // 监听键盘
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillAppear(notification:)), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)

        
    }
    
    @objc func keyboardWillAppear(notification: NSNotification) {
        keyboardWillChangeFrame(notifi: notification as Notification)
    }
    
    @objc func keyboardWillChangeFrame(notifi: Notification) {
        // 1.获取动画执行的时间
        let duration = notifi.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as! TimeInterval
        // 2.获取键盘最终 Y值
        let endFrame = (notifi.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        let y = abs(endFrame.origin.y)
        // 3计算工具栏距离底部的间距
        let margin = UIScreen.main.bounds.height - y
        // 4.执行动画
        uiBottomView?.snp.updateConstraints { make in
            make.bottom.equalTo(-margin)
        }
        UIView.animate(withDuration: duration) {
            self.uiBottomView?.layoutIfNeeded()
        }
    }
    
    /// 线
    lazy var lineLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = .gray
        return label
    }()
    
    /// 井号
    lazy var jinLabel: UILabel = {
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
//        button.addTarget(viewController, action: #selector(sendBtnClik(_:)), for: .touchUpInside)
        return button
    }()
    
    /// 发送
    @objc func sendBtnClik(_ sender: UIButton) {
        let content = commentTextView.text.trimmingCharacters(in: .whitespaces)
        if content.count > 0 {
            navigation?.onSend(content: content)
        }
    }
    
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
