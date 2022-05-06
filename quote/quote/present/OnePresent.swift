//
//  OnePresent.swift
//  quote
//
//  Created by 景彬 on 2022/5/1.
//  Copyright © 2022 景彬. All rights reserved.
//

import UIKit
import Alamofire

class OnePresent {

    var navigation :OneNavigation?
    init(navigation :OneNavigation) {
        self.navigation = navigation
    }
    
    public func getOneData() {
            let url = "http://v3.wufazhuce.com:8000/api/channel/one/0/0"
            
            AF.request(url).responseData { response in
                do {
                            
                    // 解析：https://juejin.cn/post/6875140053635432462
                    // https://stackoverflow.com/questions/51318926/swift-json-to-model-class
                    // let url = "http://v3.wufazhuce.com:8000/api/channel/one/0/0"

                    // 注意 bean 名称不能轻易用Data名字
                    let bean = try JSONDecoder().decode(OneBean.self, from: response.value!) as OneBean?
    //                print(bean.res==0)
    //                print(bean.data!.content_list?[1].category)
//                    listener.onData(bean: bean)
                    self.navigation?.onDataSuccess(bean: bean)
                } catch {
                    // print error here.
                    self.navigation?.onDataSuccess(bean: nil)
                }
            }
        }
    
}
