//
//  Defines.swift
//  BeautifulPractice
//
//  Created by Chris on 2019/9/19.
//  Copyright © 2019 bevol. All rights reserved.
//

import Foundation
import UIKit

@objc
extension UIFont {
    static let font8 = UIFont.systemFont(ofSize: 8.0)
    static let font10 = UIFont.systemFont(ofSize: 10.0)
    static let font11 = UIFont.systemFont(ofSize: 11.0)
    static let font12 = UIFont.systemFont(ofSize: 12.0)
    static let font13 = UIFont.systemFont(ofSize: 13.0)
    static let font14 = UIFont.systemFont(ofSize: 14.0)
    static let font15 = UIFont.systemFont(ofSize: 15.0)
    static let font16 = UIFont.systemFont(ofSize: 16.0)
    static let font18 = UIFont.systemFont(ofSize: 18.0)
    static let font20 = UIFont.systemFont(ofSize: 20.0)
    static let font24 = UIFont.systemFont(ofSize: 24.0)
    
    static let font8M  = UIFont.systemFont(ofSize: 8.0, weight: .medium)
    static let font10M = UIFont.systemFont(ofSize: 10.0, weight: .medium)
    static let font11M = UIFont.systemFont(ofSize: 11.0, weight: .medium)
    static let font12M = UIFont.systemFont(ofSize: 12.0, weight: .medium)
    static let font13M = UIFont.systemFont(ofSize: 13.0, weight: .medium)
    static let font14M = UIFont.systemFont(ofSize: 14.0, weight: .medium)
    static let font15M = UIFont.systemFont(ofSize: 15.0, weight: .medium)
    static let font16M = UIFont.systemFont(ofSize: 16.0, weight: .medium)
    static let font17M = UIFont.systemFont(ofSize: 17.0, weight: .medium)
    static let font18M = UIFont.systemFont(ofSize: 18.0, weight: .medium)
    static let font20M = UIFont.systemFont(ofSize: 20.0, weight: .medium)
    
//    static let font8MR = UIFont.systemFont(ofSize: bp_ratio414(8.0), weight: .medium)
//    static let font10MR = UIFont.systemFont(ofSize: bp_ratio414(10.0), weight: .medium)
//    static let font11MR = UIFont.systemFont(ofSize: bp_ratio414(11.0), weight: .medium)
//    static let font12MR = UIFont.systemFont(ofSize: bp_ratio414(12.0), weight: .medium)
//    static let font13MR = UIFont.systemFont(ofSize: bp_ratio414(13.0), weight: .medium)
//    static let font14MR = UIFont.systemFont(ofSize: bp_ratio414(14.0), weight: .medium)
//    static let font15MR = UIFont.systemFont(ofSize: bp_ratio414(15.0), weight: .medium)
//    static let font16MR = UIFont.systemFont(ofSize: bp_ratio414(16.0), weight: .medium)
//    static let font18MR = UIFont.systemFont(ofSize: bp_ratio414(18.0), weight: .medium)
//    static let font20MR = UIFont.systemFont(ofSize: bp_ratio414(20.0), weight: .medium)
//
//    static let font10R = UIFont.systemFont(ofSize: bp_ratio414(10.0))
//    static let font11R = UIFont.systemFont(ofSize: bp_ratio414(11.0))
//    static let font12R = UIFont.systemFont(ofSize: bp_ratio414(12.0))
//    static let font13R = UIFont.systemFont(ofSize: bp_ratio414(13.0))
//    static let font14R = UIFont.systemFont(ofSize: bp_ratio414(14.0))
//    static let font15R = UIFont.systemFont(ofSize: bp_ratio414(15.0))
//    static let font16R = UIFont.systemFont(ofSize: bp_ratio414(16.0))
}

/// 用户默认头像
//let UserAvaterPlaceholder = UserAvaterDefault()

/// Banner默认图
let BannerImagePlaceholder = UIImage(named: "bg_loading_failed.jpg")

/// 屏幕高度
let kScreenHeight = UIScreen.main.bounds.size.height

/// 屏幕宽度
let kScreenWidth = UIScreen.main.bounds.size.width

let viewCenterX = kScreenWidth / 2

/// 屏幕中间点
let viewCenter = CGPoint(x: viewCenterX, y: kScreenHeight / 2)

/// 宽度适配比例
let KscaleW = kScreenWidth / 375.0

var statusBarHeight: CGFloat {
    Screen.statusBarHeight()
}
var isIPhoneXAll: Bool {
    Int(statusBarHeight) > 20
}
var kTopMargin: CGFloat {
    max(Screen.statusBarHeight() - 20, 0)
}

// 安全区域，可以通过.left适配横竖屏，ios11以上。top或left就是状态栏高度
var kSafeAreaInset: UIEdgeInsets {
    UIApplication.shared.delegate?.window??.safeAreaInsets ?? UIEdgeInsets.zero
}

// 顶部或侧边的高度，指的是刘海的高度
var kSafeAreaHeightAllways: CGFloat {
    max(kSafeAreaInset.top, kSafeAreaInset.left)
}

// 底部的高度
var kBottomMargin: CGFloat {
    isIPhoneXAll ? 24 : 0
}
// 顶部的高度
var kNavigationBarHeight: CGFloat {
    statusBarHeight + 44
}

var kTabBarHeight: CGFloat {
    isIPhoneXAll ? 49.0 + 34.0 : 49.0
}

// 1像素的线高
var lineHeight : CGFloat {
    1 / UIScreen.main.scale
}

@objc
class Screen: NSObject {
    // 当前屏幕尺寸
    class func statusBarHeight() -> CGFloat {
        if #available(iOS 13.0, *) {
            return UIApplication.shared.windows.first?.windowScene?.statusBarManager?.statusBarFrame.height ?? 0
        } else {
            return UIApplication.shared.statusBarFrame.height
        }
    }
    class func navigationBarHeight() -> CGFloat { Screen.statusBarHeight() + 44 }
    class func topMargin() -> CGFloat { max(Screen.statusBarHeight() - 20, 0) }
    static let width = UIScreen.main.bounds.size.width
    static let height = UIScreen.main.bounds.size.height
    static let size = UIScreen.main.bounds.size
    // 状态栏+导航栏高度（导航栏可能有大标题，所以不是固定的44）
    class func navigationBarHeight(_ nv:UINavigationController?) -> CGFloat { kSafeAreaHeightAllways + (nv?.navigationBar.frame.size.height ?? 44) 
 }
}

@objc
extension UIColor {
    /// 导航栏背景颜色 紫色
//    static let nav_purple = UIColor(rgb: 0xAC69FE)
//    /// 新的 紫色
//    static let new_purple = UIColor(rgb: 0xB76EFF)
//    /// 淡紫色
//    static let light_purple = UIColor(rgb: 0xF5ECFF)
//    static let color99 = UIColor(rgb: 0x999999)
//    static let color86 = UIColor(rgb: 0x868686)
//    static let color66 = UIColor(rgb: 0x666666)
//    static let color50 = UIColor(rgb: 0x505050)
//    static let color40 = UIColor(rgb: 0x404040)
//    static let color4D = UIColor(rgb: 0x4D4D4D)
//    static let color33 = UIColor(rgb: 0x333333)
//    static let color32 = UIColor(rgb: 0x323232)
//    static let color3B = UIColor(rgb: 0x3B3B3B)
//    static let color11 = UIColor(rgb: 0x111111)
//    static let color21 = UIColor(rgb: 0x212121)
//    static let color5E = UIColor(rgb: 0x5E5E5E)
//    static let colorEB = UIColor(rgb: 0xEBEBEB)
//    static let line    = UIColor(rgb: 0xF7F7F7)
//    static let colorF0 = UIColor(rgb: 0xF0F0F0)
//    static let colorFA = UIColor(rgb: 0xFAFAFA)
//    static let colorE7 = UIColor(rgb: 0xE7E7E7)
//    static let colorEA = UIColor(rgb: 0xEAEAEA)
//    static let colorF3 = UIColor(rgb: 0xF3F3F3)
//    static let colorF4 = UIColor(rgb: 0xF4F4F4)
//    static let colorF5 = UIColor(rgb: 0xF5F5F5)
//    static let colorF6 = UIColor(rgb: 0xF6F6F6)
//    static let colorF7 = UIColor(rgb: 0xF7F7F7)
//    static let colorF8 = UIColor(rgb: 0xF8F8F8)
//    static let colorF9 = UIColor(rgb: 0xF9F9F9)
//    static let colorB5 = UIColor(rgb: 0xB5B5B5)
//    static let colorD8 = UIColor(rgb: 0xD8D8D8)
//    static let colorCA = UIColor(rgb: 0xCACACA)
//    static let new_blue = UIColor(rgb: 0x804BDE)
//    static let new_pink = UIColor(rgb: 0xE04DFF)
}

public func print(_ items: Any..., separator: String = " ", terminator: String = "\n") {
    #if DEBUG
    items.forEach {
        Swift.print($0, separator: separator, terminator: terminator)
    }
    #endif
}

public func viewBounds(top: CGFloat = 0.0, bottom: CGFloat = 0.0) -> CGRect {
    CGRect(x: 0,
           y: kNavigationBarHeight + top,
           width: kScreenWidth,
           height: kScreenHeight - kNavigationBarHeight - top - bottom)
}

func == (lhs: (String, String, Int), rhs: (String, String, Int)) -> Bool {
    return lhs.0 == rhs.0 && lhs.1 == rhs.1 && lhs.2 == rhs.2
}

import CoreLocation
func locationServicesEnabled() -> Bool {
    CLLocationManager.locationServicesEnabled() && (
        CLLocationManager.authorizationStatus() == .authorizedWhenInUse
            || CLLocationManager.authorizationStatus() == .authorizedAlways)
}



/// 导航返回协议
@objc protocol NavigationProtocol {
    /// 导航将要返回方法
    ///
    /// - Returns: true: 返回上一界面， false: 禁止返回
    @objc optional func navigationShouldPopMethod() -> Bool
}

extension UIViewController: NavigationProtocol {
    func navigationShouldPopMethod() -> Bool {
        print("NavigationProtocol 执行手势返回操作")
        return true
    }
}

extension UINavigationController: UINavigationBarDelegate, UIGestureRecognizerDelegate {
    
    public func navigationBar(_ navigationBar: UINavigationBar, shouldPop item: UINavigationItem) -> Bool {
        if viewControllers.count < (navigationBar.items?.count)! {
            return true
        }
        var shouldPop = false
        let vc: UIViewController = topViewController!
        if vc.responds(to: #selector(navigationShouldPopMethod)) {
            shouldPop = vc.navigationShouldPopMethod()
        }
        if shouldPop {
            DispatchQueue.main.async {
                self.popViewController(animated: true)
            }
        } else {
            for subview in navigationBar.subviews {
                if 0.0 < subview.alpha && subview.alpha < 1.0 {
                    UIView.animate(withDuration: 0.25) {
                        subview.alpha = 1.0
                    }
                }
            }
        }
        return false
    }
    
    public func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
            if children.count == 1 {
                return false
            } else {
                if topViewController?.responds(to: #selector(navigationShouldPopMethod)) != nil {
                    return topViewController!.navigationShouldPopMethod()
                }
                return true
            }
        }

    
}

//MARK: - LightMode与DarkMode的颜色思路
//extension UIColor {
//
//    /// 便利构造函数(配合cssHex函数使用 更好)
//    /// - Parameters:
//    ///   - lightThemeColor: 明亮主题的颜色
//    ///   - darkThemeColor: 黑暗主题的颜色
//    public convenience init(lightThemeColor: UIColor, darkThemeColor: UIColor? = nil) {
//        if #available(iOS 13.0, *) {
//            self.init { (traitCollection) -> UIColor in
//                switch traitCollection.userInterfaceStyle {
//                    case .light:
//                        return lightThemeColor
//                    case .unspecified:
//                        return lightThemeColor
//                    case .dark:
//                        return darkThemeColor ?? lightThemeColor
//                   @unknown default:
//                        fatalError()
//                    }
//                }
//            } else {
//                self.init(cgColor: lightThemeColor.cgColor)
//            }
//        }
//}
