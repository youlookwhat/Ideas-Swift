//
//  ColorProvider.swift
//  quote
//
//  Created by 景彬 on 2022/7/20.
//  Copyright © 2022 景彬. All rights reserved.
//

import Foundation
import UIKit

public protocol ColorProvider {
    var uiColor: UIColor { get }
    var cgColor: CGColor { get }
}

extension ColorProvider {
   public var cgColor: CGColor {
        return uiColor.cgColor
    }
}

/// 16进制数值
public struct HexAColor {
   public let hex: Int
   public let alpha: CGFloat
   public init(hex: Int, alpha: CGFloat = 1.0) {
        self.alpha = alpha
        self.hex = hex
    }
}

/// 16进制字符串
public struct StrHexColor {
   public let hex: String
   public let alpha: CGFloat
   public init(hex: String, alpha: CGFloat = 1.0) {
        self.alpha = alpha
        self.hex = hex
    }
}

/// RGB
public struct RGBAColor {
   let red: Int
   let green: Int
   let blue: Int
   let alpha: CGFloat
   public init(red: Int, green: Int, blue: Int, alpha: CGFloat = 1.0) {
        self.alpha = alpha
        self.blue = blue
        self.green = green
        self.red = red
    }
}

/// HEX 16进制
extension HexAColor: ColorProvider {
    public var uiColor: UIColor {
        let red   =  Double((hex & 0xFF0000) >> 16) / 255.0
        let green =  Double((hex & 0xFF00)   >> 8 ) / 255.0
        let blue  =  Double( hex & 0xFF   ) / 255.0
        return UIColor.init(red: CGFloat(red), green: CGFloat(green), blue: CGFloat(blue), alpha: alpha)
    }
}

/// HEX 字符串
extension StrHexColor: ColorProvider {
    public var uiColor: UIColor {
        return hex.getColor(alpha: alpha)
    }
}

/// RGB
extension RGBAColor: ColorProvider {
    public var uiColor: UIColor {
        UIColor(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: alpha)
    }
}

extension UIColor: ColorProvider {
    public var uiColor: UIColor {
        return self
    }
}

extension Int: ColorProvider {
    public var uiColor: UIColor {
        let red   =  Double((self & 0xFF0000) >> 16) / 255.0
        let green =  Double((self & 0xFF00)   >> 8 ) / 255.0
        let blue  =  Double( self & 0xFF   ) / 255.0
        return UIColor.init(red: CGFloat(red), green: CGFloat(green), blue: CGFloat(blue), alpha: 1)
    }
}

extension String: ColorProvider {
    public var uiColor: UIColor {
        return getColor(alpha: 1)
    }
    
    func getColor(alpha: CGFloat) -> UIColor {
        var cstr = trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).uppercased() as NSString
        if cstr.length < 6 { return .clear }
        if cstr.hasPrefix("0X") {
            cstr = cstr.substring(from: 2) as NSString
        } else if cstr.hasPrefix("#") {
          cstr = cstr.substring(from: 1) as NSString
        }
         if cstr.length != 6 { return .clear }
        var range = NSRange.init()
        range.location = 0
        range.length = 2
        //r
        let rStr = cstr.substring(with: range);
        //g
        range.location = 2
        let gStr = cstr.substring(with: range)
        //b
        range.location = 4
        let bStr = cstr.substring(with: range)
        var r :UInt32 = 0x0
        var g :UInt32 = 0x0
        var b :UInt32 = 0x0
        Scanner.init(string: rStr).scanHexInt32(&r)
        Scanner.init(string: gStr).scanHexInt32(&g)
        Scanner.init(string: bStr).scanHexInt32(&b)
        return UIColor.init(red: CGFloat(r)/255.0, green: CGFloat(g)/255.0, blue: CGFloat(b)/255.0, alpha: alpha)
    }
}

extension UIColor {
  /// rgb来颜色,不用再除255, 如  UIColor(red: 129, green: 21, blue: 12)
   ///
   /// - Parameters:
   ///   - red: red component.
   ///   - green: green component.
   ///   - blue: blue component.
   ///   - transparency: optional transparency value (default is 1).
   convenience public init?(red: Int, green: Int, blue: Int, transparency: CGFloat = 1) {
       guard red >= 0 && red <= 255 else { return nil }
       guard green >= 0 && green <= 255 else { return nil }
       guard blue >= 0 && blue <= 255 else { return nil }
       
       var trans = transparency
       if trans < 0 { trans = 0 }
       if trans > 1 { trans = 1 }
   
       self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: trans)
   }

   /// 随机色
   public static var random: UIColor {
       let red = Int.random(in: 0...255)
       let green = Int.random(in: 0...255)
       let blue = Int.random(in: 0...255)
       return UIColor(red: red, green: green, blue: blue)!
   }
}

extension UIColor {

    /// 便利构造函数(配合cssHex函数使用 更好)
    /// - Parameters:
    ///   - lightThemeColor: 明亮主题的颜色
    ///   - darkThemeColor: 黑暗主题的颜色
    public convenience init(lightThemeColor: UIColor, darkThemeColor: UIColor? = nil) {
        if #available(iOS 13.0, *) {
            self.init { (traitCollection) -> UIColor in
                switch traitCollection.userInterfaceStyle {
                    case .light:
                        return lightThemeColor
                    case .unspecified:
                        return lightThemeColor
                    case .dark:
                        return darkThemeColor ?? lightThemeColor
                   @unknown default:
                        fatalError()
                    }
                }
            } else {
                self.init(cgColor: lightThemeColor.cgColor)
            }
        }
}

// 管理应用中所有的颜色值
@objc
extension UIColor {
    static let colorTheme = "#48B07B".uiColor
    static let colorF3F3F3 = "#F3F3F3".uiColor
}
