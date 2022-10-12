//
//  BPPopupXbsWhyViewCollectionViewCell.swift
//  quote
//
//  Created by 景彬 on 2022/8/8.
//  Copyright © 2022 景彬. All rights reserved.
//

import UIKit

/// 发布弹窗
@objc protocol IdeaSendEditViewDelegate {

    func commentSend(content:String)

    func commentDismiss(dismissClick view: IdeaSendEditView, sender: UIButton?)

}
class IdeaSendEditView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .colorBlack0d6
        
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(viewTouched))
        addGestureRecognizer(tapGesture)
        addSubview(backView)
//        backView.addSubview(addPhotoBtn)
        backView.addSubview(tipsLabel)
        backView.addSubview(sendBtn)
        backView.addSubview(editBackView)
        editBackView.addSubview(commentTextView)
//        editBackView.addSubview(commentPhotoView)
        editBackView.addSubview(tipsLabel222)

        
        if (Screen.width > Screen.height) {
            // 横屏布局
            backView.snp.remakeConstraints{ make in
                make.left.equalToSuperview().offset(kSafeAreaHeightAllways)
                make.right.equalToSuperview().offset(-kSafeAreaHeightAllways)
                make.width.equalTo(Screen.width-2*kSafeAreaHeightAllways)
                make.bottom.equalToSuperview()
            }
        } else {
            // 竖屏布局
            backView.snp.remakeConstraints{ make in
                make.left.right.bottom.equalToSuperview()
                make.width.equalTo(Screen.width)
            }
        }
        
        sendBtn.snp.makeConstraints { make in
            make.right.equalTo(-15)
            make.bottom.equalTo(-10)
//            make.centerY.equalToSuperview()
            make.height.equalTo(28)
            make.width.equalTo(54)
        }
        
        tipsLabel.snp.makeConstraints { make in
            make.left.equalTo(15)
            make.bottom.equalTo(-10)
            make.height.equalTo(35)
            make.width.equalTo(35)
        }
        
        editBackView.snp.makeConstraints { make in
            make.left.top.equalTo(15)
            make.right.equalTo(-15)
            make.bottom.equalTo(-48)
        }
//        commentTextView.snp.makeConstraints { make in
//            make.left.equalTo(15)
//            make.right.equalTo(-15)
//            make.height.equalTo(58)
//            make.width.equalTo(kScreenWidth - 30)
//            make.top.equalToSuperview()
//        }
        tipsLabel222.snp.makeConstraints{make in
            make.width.equalTo(kScreenWidth)
            make.bottom.equalTo(-10)
            make.top.equalTo(commentTextView.snp.bottom).offset(10)
            make.height.equalTo(1)
        }
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
        backView.snp.updateConstraints { make in
            make.bottom.equalTo(-margin)
        }
        UIView.animate(withDuration: duration) {
            self.layoutIfNeeded()
        }
    }
        
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    @objc func viewTouched(_ sender: UITapGestureRecognizer) {
        let location = sender.location(in: backView)
        if location.y < 0 {
//            close()
            delegate?.commentDismiss(dismissClick: self, sender: nil)
        }
    }
    
    /// 发送
    @objc func sendBtnClik(_ sender: UIButton) {
//        delegate?.commentSend(sendBtnClik: self, sender: sender)
        let content = commentTextView.text.trimmingCharacters(in: .whitespaces)
        if content.count > 0 {
            delegate?.commentSend(content: content)
        }
    }
    
    @objc public weak var delegate: IdeaSendEditViewDelegate?

    
    /// 发布内容
    @objc lazy var commentTextView: UITextView = {
        let textView = UITextView(frame: CGRect(x: 0, y: 0, width: kScreenWidth - 30, height: 58))
        textView.backgroundColor = .clear
        textView.font = .font14
        textView.textColor = UIColor.init(lightColor: .color32,darkColor: .white)
        textView.textContainerInset = UIEdgeInsets(top: 10, left: 5, bottom: 10, right: 10)
        textView.cm_placeholder = "现在的想法是..."
        textView.cm_placeholderColor = .colorB5
        textView.cm_maxNumberOfLines = 15
        textView.delegate = self
        textViewDidChange(textView)
        return textView
    }()
    
    /// 线，不可删
    lazy var tipsLabel222: UILabel = {
        let label = UILabel()
//        label.font = .font14
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
    
    /// 添加图片按钮
    @objc lazy var addPhotoBtn: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "comment_add"), for: .normal)
//        button.addTarget(self, action: #selector(addPhotoBtnClik(_:)), for: .touchUpInside)
//        button.setEnlargeEdgeWithTop(20, right: 20, bottom: 20, left: 20)
        return button
    }()
    
    /// 发送按钮
    @objc lazy var sendBtn: UIButton = {
        let button = UIButton(type: .custom)
        button.backgroundColor = .colorF7
        button.setTitle("记录", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 14
        button.titleLabel?.font = UIFont.font13
//        button.titleLabel?.font = UIFont.mediumSystemFont(ofSize: 14)
        button.addTarget(self, action: #selector(sendBtnClik(_:)), for: .touchUpInside)
        return button
    }()
    
    /// 编辑区底部view
    @objc lazy var editBackView: UIView = {
        let icon = UIView()
        icon.layer.cornerRadius = 10
        icon.backgroundColor = UIColor.init(lightColor: .colorF6, darkColor: .color151517)
        return icon
    }()
    
    /// 底部view
    @objc lazy var backView: UIView = {
        let uiView = UIView()
        uiView.backgroundColor = UIColor(lightColor: .white, darkColor: .black)
        uiView.layer.cornerRadius = 14
        uiView.corners = [.topLeft, .topRight]
        return uiView
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
    
    // 隐藏弹框
    public func hideSendView(clearText:Bool){
        if clearText {
            // 是否清空输入框
            commentTextView.text = ""
            sendBtn.backgroundColor = UIColor(lightColor: .colorF7, darkColor: .color151517)
            sendBtn.isUserInteractionEnabled = false
        }
        endEditing(true)
        isHidden = true
    }
}

extension IdeaSendEditView: UITextViewDelegate {
    
    func textViewDidChange(_ textView: UITextView) {
        
        let strings = textView.text.trimmingCharacters(in: .whitespaces)
        if strings.count >= 20 {
//            tipsLabel.text = "真棒！发送后获得更多回复哟～"
        } else {
//            let string = String.init(format: "再评%lu字可被更多人回复", 20 - strings.count)
//            tipsLabel.attributedText = NSAttributedString(string: string,
//                                                          lineHeight: 14,
//                                                          font: .font14,
//                                                          textColor: .color50,
//                                                          rangString: String.init(format: "%lu", 20 - strings.count),
//                                                          rangeFont: .font14,
//                                                          rangeColor: .new_purple)
        }
                
        if String.isEmpty(strings) {
            sendBtn.backgroundColor = UIColor(lightColor: .colorF7, darkColor: .color151517)
            sendBtn.isUserInteractionEnabled = false
        } else {
            sendBtn.backgroundColor = .colorTheme
            sendBtn.isUserInteractionEnabled = true
        }        
    }
    
}

// MARK: UICollectionViewDataSource
//extension XbsCommentEditView: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        images?.count ?? 0
//    }
    
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        let cell = collectionView.dequeueReusableCell(with: BPSingleImageDelCell.self, for: indexPath) as! BPSingleImageDelCell
//        cell.label.isHidden = true
//
//        let imageDic = images?.safeObject(at: indexPath.item)
//
//        if let image = imageDic?.values.first as? Data {
//
//            cell.imageView.image = UIImage(data: image)
//        } else if let image = imageDic?.values.first as? String {
//
//            cell.imageView.sd_setImage(with: URL(string: image), placeholderImage: GoodsImagePlaceholder)
//        } else {
//            cell.imageView.image = GoodsImagePlaceholder
//        }
//        cell.deleteButtonClickedBlock = {[weak self] cell, sender in
//            sender.isUserInteractionEnabled = false
//            self?.deleteImage(at: indexPath.item)
//            sender.isUserInteractionEnabled = true
//        }
//
//        return cell
//    }
    
    /// 删除图片
//    func deleteImage(at index: Int) {
//        if images?.count ?? 0 > index {
//            images?.remove(at: index)
//            commentPhotoView.reloadData()
//            delegate?.commentDelete(deleteClick: self, index: index)
//        }
//        if images?.count == 0 {
//            commentPhotoView.snp.updateConstraints { make in
//                make.height.equalTo(0)
//            }
//        }
//    }
//}
