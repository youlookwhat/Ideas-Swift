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
 * Ideas首页
 */
class IdeasPresent {

    var navigation :IdeasNavigation?
    var page : Int = 1
    
    init(navigation :IdeasNavigation) {
        self.navigation = navigation
    }
    
    public func getDBData() {
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
        getDBData()
    }
    
}
