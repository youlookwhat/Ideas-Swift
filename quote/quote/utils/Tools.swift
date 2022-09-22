//
//  Tools.swift
//  quote
//
//  Created by 景彬 on 2022/9/22.
//  Copyright © 2022 景彬. All rights reserved.
//

import Foundation

class Tools {
    
    // 复制内容
    static func copy(text:String?) ->Void{
        if text != nil {
            //通用粘贴板
            let pBoard = UIPasteboard.general
            
            //有时候只想取UILabel得text中一部分
            pBoard.string = text
            
        }
    }
}
