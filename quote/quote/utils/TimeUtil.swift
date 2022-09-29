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
    static func getDateFormatString(timeStamp:String?) ->String{
        if (timeStamp == nil) {
            return ""
        }
        let interval:TimeInterval=TimeInterval.init(timeStamp!)!
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
    
//    func getWeekDay(dateTime:String)->Int{
//        let dateFmt = DateFormatter()
//        dateFmt.dateFormat = "yyyy-MM-dd HH:mm:ss"
//        let date = dateFmt.date(from: dateTime)
//        date?.description
//        var interval = Int(date!.timeIntervalSince1970)+(Int(NSTimeZone.localTimeZone.secondsFromGMT) ?? 0)
//        let days = Int(interval/86400) // 24*60*60
//        let weekday = ((days + 4)%7+7)%7
//        return weekday == 0 ? 7 : weekday
//    }
    

}
extension String {
    func featureWeekday() -> String {
            let dateFormatter = DateFormatter()
            dateFormatter.locale = Locale.current
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            guard let formatDate = dateFormatter.date(from: self) else { return "" }
            let calendar = Calendar.current
            let weekDay = calendar.component(.weekday, from: formatDate)
            switch weekDay {
            case 1:
                return "星期日"
            case 2:
                return "星期一"
            case 3:
                return "星期二"
            case 4:
                return "星期三"
            case 5:
                return "星期四"
            case 6:
                return "星期五"
            case 7:
                return "星期六"
            default:
                return ""
            }
        }
    }

