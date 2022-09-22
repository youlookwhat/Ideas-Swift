//
//  CopyLabel.swift
//  quote
//
//  Created by 景彬 on 2022/9/22.
//  Copyright © 2022 景彬. All rights reserved.
//

import Foundation
import UIKit
import ObjectiveC

private var is_copyEnabled = false
// label.isCopyEnabled = true 即可
extension UILabel {
    
    var isCopyEnabled: Bool {
        get{
            return objc_getAssociatedObject(self, &is_copyEnabled) as! Bool
        }
        set{
            objc_setAssociatedObject(self, &is_copyEnabled, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN)
            attachTapHandler()
        }
    }
    
    open override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        return action == #selector(UILabel.copyText(sender:))
    }
    
    func attachTapHandler() {
        self.isUserInteractionEnabled = true
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(UILabel.handleTap(ges:)))
        self.addGestureRecognizer(longPress)
    }
    
    @objc fileprivate func handleTap(ges: UIGestureRecognizer) {
        if ges.state == .began {
            becomeFirstResponder()
            let item = UIMenuItem(title: "复制全文", action: #selector(UILabel.copyText(sender:)))
            UIMenuController.shared.menuItems = [item]
            //计算label真实frame，让复制显示在中间
            let rect = (text! as NSString).boundingRect(with: CGSize(width: CGFloat(MAXFLOAT), height:self.bounds.size.height), options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: self.font], context: nil)
            let width = rect.size.width > self.bounds.size.width ? self.bounds.size.width : rect.size.width
            let frame = CGRect(x: self.frame.origin.x, y: self.frame.origin.y, width: width, height: self.frame.size.height)
            UIMenuController.shared.setTargetRect(frame, in: self.superview!)
            UIMenuController.shared.setMenuVisible(true, animated: true)
        }
        
    }
    
    @objc fileprivate func copyText(sender: Any) {
        //通用粘贴板
        let pBoard = UIPasteboard.general
        
        //有时候只想取UILabel得text中一部分
        if objc_getAssociatedObject(self, "expectedText") != nil {
            pBoard.string = objc_getAssociatedObject(self, "expectedText") as! String?
        } else {
            if self.text != nil {
                pBoard.string = self.text
            } else {
                pBoard.string = self.attributedText?.string
            }
        }
    }
    
    open override var canBecomeFirstResponder: Bool{
        return isCopyEnabled
    }
    
}
