//
//  OnePresent.swift
//  quote
//
//  Created by 景彬 on 2022/5/1.
//  Copyright © 2022 景彬. All rights reserved.
//

import UIKit
import Alamofire
import RealmSwift

/*
 * Flomo首页
 */
class FlomoPresent {

    var navigation :FlomoNavigation?
    var num : Int = 0
    
    init(navigation :FlomoNavigation) {
        self.navigation = navigation
    }
    
    // 一个
    public func getOneData() {
        // 看是否要放在异步获取
        let notes = DatabaseUtil.getSortedNotes()
        var list = [NoteBean]()
        for note in notes {
            list.append(note)
        }
        navigation?.onDataSuccess(bean: list)
    }
    
    // 刷新数据
    func refresh(){
        getOneData()
    }
    
}
