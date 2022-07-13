//
//  DCSidebar.swift
//  quote
//
//  Created by 景彬 on 2022/7/13.
//  Copyright © 2022 景彬. All rights reserved.
//

import UIKit

class DCSidebar: UIView {
    
    private var width:CGFloat
    private let myWindow = UIApplication.shared.keyWindow
    private let myBounds = UIScreen.main.bounds
    
    public var showAnimationsTime = 0.5
    public var hideAnimationsTime = 0.5
    
    private var menuView: UIView = {
        let meV = UIView()
        meV.backgroundColor = UIColor.blue
        return meV
    }()
    
    private let maskingView: UIView = {
        let maV = UIView()
        maV.backgroundColor = UIColor.gray
        maV.alpha = 0.0
        return maV
    }()
    
    init(sideView: UIView) {
        let frame = sideView.frame
        
        menuView = sideView
        
        width = frame.width
        
        maskingView.frame = CGRect(x: width, y: 0, width: myBounds.size.width, height: myBounds.size.height)
        
        super.init(frame: CGRect(x: myBounds.origin.x-width, y: myBounds.origin.y, width: myBounds.size.width+width, height: myBounds.size.height))
        
        self.addSubview(menuView)
        self.addSubview(maskingView)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapMaskingAction))
        let pan = UIPanGestureRecognizer(target: self, action: #selector(panMaskingAction(pan:)))
        
        maskingView.addGestureRecognizer(tap)
        maskingView.addGestureRecognizer(pan)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - maskingViewAction
    @objc private func tapMaskingAction() {
        self.hide()
    }
    
    private var beginLocation: CGPoint?
    private var endLocation: CGPoint?
    
    @objc private func panMaskingAction(pan: UILongPressGestureRecognizer) {
        
        if pan.state == .began {
            print("begin")
            beginLocation = pan.location(in: maskingView)
        } else if pan.state == .ended {
            print("end")
            endLocation = pan.location(in: maskingView)
            
            if self.frame.origin.x < -self.width/3 {
                UIView.animate(withDuration: self.hideAnimationsTime, animations: {
                    self.frame.origin.x -= self.width + self.frame.origin.x
                    self.maskingView.alpha = 0.0
                }) { (isFinish) in
                    self.removeFromSuperview()
                }
            } else {
                UIView.animate(withDuration: self.showAnimationsTime, animations: {
                    self.frame.origin.x += -self.frame.origin.x
                    self.maskingView.alpha = 0.7
                }, completion: nil)
            }
        } else {
            let curLocation = pan.location(in: maskingView)
            
            if (self.frame.origin.x < 0 || (self.frame.origin.x == 0 && curLocation.x-(beginLocation?.x)! < 0)) && self.frame.origin.x > -width {
                
                if (self.frame.origin.x + curLocation.x-(beginLocation?.x)!) > 0 {
                    self.frame.origin.x = 0
                } else {
                    self.frame.origin.x += curLocation.x-(beginLocation?.x)!
                }
                
                self.maskingView.alpha = 0.7-0.7*(-self.frame.origin.x/width)
                
            } else {
                
                beginLocation = curLocation
            }
        }
    }
    
    //MARK: - SidebarAction
    public func show() {
        myWindow?.addSubview(self)
        
        self.frame.origin.x = -self.width
        
        UIView.animate(withDuration: showAnimationsTime, animations: {
            self.frame.origin.x += self.width
            self.maskingView.alpha += 0.7
        }, completion: nil)
    }
    
    public func hide() {
        UIView.animate(withDuration: hideAnimationsTime, animations: {
            self.frame.origin.x -= self.width
            self.maskingView.alpha -= 0.7
        }) { (isFinish) in
            self.removeFromSuperview()
        }
    }
}
