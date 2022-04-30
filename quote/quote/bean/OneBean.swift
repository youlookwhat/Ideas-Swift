//
//  OneBean.swift
//  quote
//
//  Created by 景彬 on 2022/4/30.
//  Copyright © 2022 景彬. All rights reserved.
//


import Foundation


// 注意 bean 名称不能轻易用Data名字

class OneBean :Decodable {
    var res:Int? = nil
    var data:OneData? = nil
}

class OneData:Decodable {
    var id:String? = nil
    var content_list:[OneContentListBean]? = nil
}

class OneContentListBean :Decodable{
    var category:String? = nil
}
