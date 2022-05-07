//
//  OneBean.swift
//  quote
//
//  Created by 景彬 on 2022/4/30.
//  Copyright © 2022 景彬. All rights reserved.
//

import MagazineLayout
import Foundation
import HandyJSON

// 注意 bean 名称不能轻易用Data名字

class OneBean : Decodable {
    var res:Int? = nil
    var data:OneData? = nil
    required init() {}
}

class OneData : Decodable{
    var id:String? = nil
    var content_list:[OneContentListBean]? = nil
    required init() {}
}

// 列表
class OneContentListBean : Decodable {
    
    var category:String? = nil
    var img_url:String? = nil
    var forward:String? = nil
    var title:String? = nil
    var words_info:String? = nil
    var share_url:String? = nil
    var author:AuthorBean? = nil
    required init() {}
}

class AuthorBean:Decodable {
    var user_name:String? = nil
    var desc:String? = nil
    var summary:String? = nil
    var web_url:String? = nil
    required init() {}
}

class ItemOneBean {
    let sizeMode: MagazineLayoutItemSizeMode? = nil
    var content_list:[OneContentListBean]? = nil
}
