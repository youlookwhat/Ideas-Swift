//
//  TimeUtils.swift
//  quote
//
//  Created by 景彬 on 2022/7/21.
//  Copyright © 2022 景彬. All rights reserved.
//

import UIKit

class TimeUtil {

    // 时间戳转换时间格式
    static func getDateFormatString(timeStamp:String) ->String{

        let interval:TimeInterval=TimeInterval.init(timeStamp)!

        let date = Date(timeIntervalSince1970: interval)

        let dateformatter = DateFormatter()

        //自定义日期格式

        dateformatter.dateFormat = "yyyy-MM-dd HH:mm:ss"

        return dateformatter.string(from: date)

    }

    // 当前的时间戳字符串
    static func getCurrentTimeStamp() ->String{

        let nowDate = Date.init()

        //10位数时间戳

        let interval = Int(nowDate.timeIntervalSince1970)

        //13位数时间戳 (13位数的情况比较少见)

        // let interval = CLongLong(round(nowDate.timeIntervalSince1970*1000))

        return "\(interval)"

    }

    

}
