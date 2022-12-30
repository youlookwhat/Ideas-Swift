//
//  OneBean.swift
//  quote
//
//  Created by 景彬 on 2022/4/30.
//  Copyright © 2022 景彬. All rights reserved.
//


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
    // 图片链接
    var img_url:String? = nil
    // 正文，对应的是词霸的note
    var forward:String? = nil
    // 对应的是一个第一个cell的图片下面一行话
    var title:String? = nil
    // 对应的是第一个最后一行的作者
    var words_info:String? = nil
    var share_url:String? = nil
    var pic_info:String? = nil
    var author:AuthorBean? = nil
    // 不能为Int，要为Int?。数据类型：0一个 1词霸 2扇贝
    var typeContent:Int? = 0
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
    var category:String? = nil
    var img_url:String? = nil
    var forward:String? = nil
    var title:String? = nil
    var words_info:String? = nil
    var share_url:String? = nil
    var author:AuthorBean? = nil
}


// 词霸
class CiBaBean : Decodable {
    // 英文
    var content:String? = nil
    // 中文
    var note:String? = nil
    // 词霸每日一句
    var caption:String? = nil
    // 图片
    var picture2:String? = nil
    required init() {}
}

// 扇贝
class ShanBeiBean : Decodable {
    // 英文
    var content:String? = nil
    // 中文
    var translation:String? = nil
    // 扇贝每日一句，不能直接写死？
//    var caption:String = "扇贝每日一句"
    var author:String? = nil
    // 图片集合
    var origin_img_urls:[String]? = nil
    required init() {}
}

// 一言
class YiYanBean : Decodable {
    // 鲁迅日记
    var from:String? = nil
    // 鲁迅
    var from_who:String? = nil
    // 中文
    var hitokoto:String? = nil
    required init() {}
}
