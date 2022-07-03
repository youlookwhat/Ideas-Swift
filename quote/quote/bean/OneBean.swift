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
    var weather:AuthorBean? = nil
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
    var pic_info:String? = nil
    var author:AuthorBean? = nil
    required init() {}
}

class AuthorBean:Decodable {
    // 日期
    var date:String? = nil
    var user_name:String? = nil
    var desc:String? = nil
    var summary:String? = nil
    var web_url:String? = nil
    required init() {}
}

class ItemOneBean {
    var sizeMode: MagazineLayoutItemSizeMode? = nil
    var category:String? = nil
    var img_url:String? = nil
    var forward:String? = nil
    var title:String? = nil
    var words_info:String? = nil
    var share_url:String? = nil
    var author:AuthorBean? = nil
}
