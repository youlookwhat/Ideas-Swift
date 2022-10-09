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
    public func setContentView(_ vc:IdeaEditViewController, _ view:UIView) {
        
        uiHeaderView.addSubview(timeLabel)
        // 输入框
        uiHeaderView.addSubview(commentTextView)
        // 头部的布局
        view.addSubview(uiHeaderView)
        
        // 底部栏
        uiBottomView = UIView()
        uiBottomView.backgroundColor = UIColor(lightColor: .white, darkColor: UIColor.color151517)
        
        uiBottomView.addSubview(lineLabel)
        uiBottomView.addSubview(jinLabel)
        uiBottomView.addSubview(sendBtn)
        view.addSubview(uiBottomView)
        
        
        uiHeaderView.snp.remakeConstraints{ make in
            // 减去安全区域的宽度
            make.width.equalTo(Screen.width-30-2*kSafeAreaInset.left)
            make.left.equalToSuperview().offset(kSafeAreaInset.left+15)
            make.right.equalToSuperview().offset(-kSafeAreaInset.right-15)
            make.top.equalToSuperview().offset(kNavigationBarHeight+10)
            // 这里设置才能使输入框一直在底部栏之上
            make.bottom.equalTo(uiBottomView.snp.top).offset(-10)
        }
        timeLabel.snp.remakeConstraints{ make in
            make.top.equalToSuperview().offset(15)
            make.left.equalTo(15)
            make.right.equalTo(-15)
        }
        commentTextView.snp.makeConstraints{ make in
            make.top.equalTo(timeLabel.snp.bottom).offset(15)
            // 这里设置才能使输入框一直在底部栏之上
            make.bottom.equalToSuperview().offset(-1)
            make.width.equalTo(Screen.width-28-30)
            make.left.equalTo(14)
            make.right.equalTo(-14)
        }
        
        uiBottomView.snp.makeConstraints{ make in
            make.height.equalTo(50)
            make.width.equalTo(Screen.width)
            // 要处理指示器的高度，需要单独在uiBottomView底部设置
            make.bottom.equalToSuperview()
            make.left.equalToSuperview().offset(kSafeAreaInset.left)
            make.right.equalToSuperview().offset(-kSafeAreaInset.right)
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
        
        sendBtn.backgroundColor = .colorTheme
        sendBtn.isUserInteractionEnabled = true
        // 点击发布监听
        sendBtn.addTarget(self, action: #selector(sendBtnClik(_:)), for: .touchUpInside)
        // 编辑框的监听
        commentTextView.delegate = vc
        // 键盘监听
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
        label.backgroundColor = .lightGray
        label.alpha = 0.1
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
        textView.font = .font18
//        textView.textColor = .color32
        
//        textView.textContainerInset = UIEdgeInsets(top: 10, left: 5, bottom: 10, right: 10)
        
//        textView.cm_placeholder = "现在的想法是..."
//        textView.cm_placeholderColor = .colorB5
//        textView.cm_maxNumberOfLines = 0
//        textView.cm_autoLineBreak = true;
//        textView.delegate = self
//        textViewDidChange(textView)
        return textView
    }()
    
    lazy var uiHeaderView: UIView = {
        let label = UIView(frame: viewBounds())
        label.layer.cornerRadius = 6
        label.backgroundColor = UIColor(lightColor: .white, darkColor: UIColor.color151517)
        return label
    }()
    
    lazy var timeLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.textColor = .gray
        label.font = UIFont.systemFont(ofSize: 12)
        return label
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

// 基于ViewController的扩展
extension IdeaEditViewController :UITextViewDelegate {
        
    public func textViewDidChange(_ textView: UITextView) {
        // 改变按钮的样式
        let strings = textView.text.trimmingCharacters(in: .whitespaces)
        if String.isEmpty(strings) {
            self.present?.sendBtn.backgroundColor = UIColor(lightColor: .colorF7, darkColor: .color151517)
            self.present?.sendBtn.isUserInteractionEnabled = false
        } else {
            self.present?.sendBtn.backgroundColor = .colorTheme
            self.present?.sendBtn.isUserInteractionEnabled = true
        }
    }
    
}
