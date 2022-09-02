//
//  DBBean.swift
//  quote
//
//  Created by 景彬 on 2022/9/2.
//  Copyright © 2022 景彬. All rights reserved.
//

import Foundation
import RealmSwift
import UIKit

class Tag: Object {
    @objc dynamic var name = ""
    @objc dynamic var id = ""
    
    /// LinkingObjects 反向表示该对象的拥有者
    let owners = LinkingObjects(fromType: NoteBean.self, property: "tags")
}

class NoteBean: Object {
    // 内容
    @objc dynamic var title = ""
    // 主键id
    @objc dynamic var id = 0
    // 预留
    @objc dynamic var des = ""
    // 创建时间
    @objc dynamic var creatTime : String? = nil
    // 是否已经上传
    @objc dynamic var isUpload = 0
    
    //重写 Object.primaryKey() 可以设置模型的主键。
    //声明主键之后，对象将被允许查询，更新速度更加高效，并且要求每个对象保持唯一性。
    //一旦带有主键的对象被添加到 Realm 之后，该对象的主键将不可修改。
    override static func primaryKey() -> String? {
        return "id"
    }
    
    //重写 Object.ignoredProperties() 可以防止 Realm 存储数据模型的某个属性
    override static func ignoredProperties() -> [String] {
        return ["tempID"]
    }
    
    //重写 Object.indexedProperties() 方法可以为数据模型中需要添加索引的属性建立索引，Realm 支持为字符串、整型、布尔值以及 Date 属性建立索引。
    override static func indexedProperties() -> [String] {
        return ["title"]
    }
    
    //List 用来表示一对多的关系：一个 NoteBean 中拥有多个 Tag。
    let tags = List<Tag>()
}


