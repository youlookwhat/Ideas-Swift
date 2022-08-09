//
//  Wrapper.swift
//  BeautifulPractice
//
//  Created by yanpeng on 2019/12/31.
//  Copyright © 2019 bevol. All rights reserved.
//

import Foundation

extension Int {
    public static func wrap(_ source: Any?, `default`: Int = 0) -> Int {
        if let result = source as? Int {
            return result
        } else if let result = source as? Float {
            return Int(result)
        } else if let result = source as? Double {
            return Int(result)
        } else if let result = source as? String {
            return Int(result) ?? `default`
        }
        
        return `default`
    }
    public static func `nullable`(_ source: Any?) -> Int? {
        if let result = source as? Int {
            return result
        } else if let result = source as? Float {
            return Int(result)
        } else if let result = source as? Double {
            return Int(result)
        } else if let result = source as? String {
            return Int(result)
        }
        
        return nil
    }
}

extension Int64 {
    public static func wrap(_ source: Any?, `default`: Int64 = 0) -> Int64 {
        if let result = source as? Int64 {
            return result
        } else if let result = source as? Int {
            return Int64(result)
        } else if let result = source as? Float {
            return Int64(result)
        } else if let result = source as? Double {
            return Int64(result)
        } else if let result = source as? String {
            return Int64(result) ?? `default`
        }
        
        return `default`
    }
    
    public static func wrap(_ source: Any?, value: Int64? = nil) -> Int64? {
        if let result = source as? Int64 {
            return result
        } else if let result = source as? Int {
            return Int64(result)
        } else if let result = source as? Float {
            return Int64(result)
        } else if let result = source as? Double {
            return Int64(result)
        } else if let result = source as? String {
            return Int64(result) ?? value
        }
        
        return value
    }
}

extension Double {
    public static func wrap(_ source: Any?, `default`: Double = 0) -> Double {
        if let result = source as? Double {
            return result
        } else if let result = source as? Float {
            return Double(result)
        } else if let result = source as? Int {
            return Double(result)
        } else if let result = source as? String {
            return Double(result) ?? `default`
        }
        
        return `default`
    }
}

extension String {
    public static func wrap(_ source: Any?) -> String? {
        if let result = source as? Int {
            return String(result)
        } else if let result = source as? Float {
            return String(result)
        } else if let result = source as? Double {
            return String(result)
        } else if let result = source as? String {
            return result
        }
        
        return nil
    }
    
    public static func wrap(_ source: Any?, `default`: String) -> String {
        if let result = source as? Int {
            return String(result)
        } else if let result = source as? Int32 {
            return String(result)
        } else if let result = source as? Float {
            return String(result)
        } else if let result = source as? Double {
            return String(result)
        } else if let result = source as? String {
            return result
        }
        
        return `default`
    }
    
    /// 字符串
    /// 如果是空串, 则使用默认值
    public static func wrap(_ source: Any?, empty: String) -> String {
        if let result = source as? String, !result.isEmpty {
            return result
        }
        
        return empty
    }
    
    public static func isEmpty(_ string: Any?) -> Bool {
        if let string = string as? String {
            return string.isEmpty
        }
        
        return true
    }
}

extension Float {
    public static func wrap(_ source: Any?, `default`: Float = 0.0) -> Float {
        if let result = source as? Int {
            return Float(result)
        } else if let result = source as? Float {
            return result
        } else if let result = source as? Double {
            return Float(result)
        } else if let result = source as? String {
            return Float(result) ?? `default`
        }
        
        return `default`
    }
}

import CoreGraphics
extension CGFloat {
    public static func wrap(_ source: Any?, `default`: CGFloat = 0.0) -> CGFloat {
        if let result = source as? Int {
            return CGFloat(result)
        } else if let result = source as? Float {
            return CGFloat(result)
        } else if let result = source as? Double {
            return CGFloat(result)
        } else if let result = source as? CGFloat {
            return CGFloat(result)
        } else if let result = source as? String {
            guard let float = Float(result) else {
                return `default`
            }
            return CGFloat(float)
        }
        
        return `default`
    }
}

extension Array {
    subscript(safe index: Int) -> Element? {
        if index >= 0, index < count {
            return self[index]
        }
        
        return nil
    }
    
    subscript(safe range: Range<Int>) -> [Element]? {
        if range.lowerBound >= 0, range.lowerBound <= count {
            return Array(self[range.lowerBound..<Swift.min(count, range.upperBound)])
        }
        
        return nil
    }
    
    subscript(safe range: ClosedRange<Int>) -> [Element]? {
        if range.lowerBound >= 0, range.lowerBound < count {
            return Array(self[range.lowerBound...Swift.min(count - 1, range.upperBound)])
        }
        
        return nil
    }
    
    func safeObject(at index: Int) -> Element? {
        if index >= 0, index < count {
            return self[index]
        }
        
        return nil
    }
}

extension String {
    public func allRanges(
        of aString: String,
        options: String.CompareOptions = [],
        range: Range<String.Index>? = nil,
        locale: Locale? = nil
    ) -> [Range<String.Index>] {
        
        // the slice within which to search
        let slice = (range == nil) ? self[...] : self[range!]
        
        var previousEnd = slice.startIndex
        var ranges = [Range<String.Index>]()
        
        while let range = slice.range(
            of: aString, options: options,
            range: previousEnd ..< slice.endIndex,
            locale: locale
            ) {
                if previousEnd != self.endIndex { // don't increment past the end
                    previousEnd = self.index(after: range.lowerBound)
                }
                ranges.append(range)
        }
        
        return ranges
    }
}
