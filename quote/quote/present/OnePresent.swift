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
    var num : Int = 0
    
    init(navigation :OneNavigation) {
        self.navigation = navigation
    }
    
    // 一个
    public func getOneData() {
        num = 0
        let url = "http://v3.wufazhuce.com:8000/api/channel/one/0/0"
        
        AF.request(url).responseData { response in
            do {
                        
                // 解析：https://juejin.cn/post/6875140053635432462
                // https://stackoverflow.com/questions/51318926/swift-json-to-model-class
                // let url = "http://v3.wufazhuce.com:8000/api/channel/one/0/0"

                // 注意 bean 名称不能轻易用Data名字
                let bean = try JSONDecoder().decode(OneBean.self, from: response.value!) as OneBean?
                
                
//                    print(bean!.data!.weather?.climate)
                self.navigation?.onDataSuccess(bean: bean)
            } catch {
                // print error here.
                self.navigation?.onDataSuccess(bean: nil)
            }
        }
    }
    
    func refresh(){
        switch num {
        case 0:
            num = num+1
            getCiBaData()
        case 1:
            num = num+1
            getShanBeiData()
        default:
            getOneData()
        }
    }
    
    // 词霸每日一句
    public func getCiBaData() {
        let url = "http://open.iciba.com/dsapi"
        AF.request(url).responseData { response in
            do {
                // 注意 bean 名称不能轻易用Data名字
                let bean = try JSONDecoder().decode(CiBaBean.self, from: response.value!) as CiBaBean?
                
                let itemBean = OneContentListBean()
                itemBean.img_url = bean?.picture2
                itemBean.forward = bean?.note
                itemBean.title = bean?.caption
                itemBean.words_info = bean?.content
                var list : [OneContentListBean] = [OneContentListBean]()
                list.append(itemBean)
                let oneBean = OneBean()
                let oneData = OneData()
                oneData.content_list = list
                oneBean.data = oneData

                self.navigation?.onDataSuccess(bean: oneBean)
            } catch {
                // print error here.
                self.navigation?.onDataSuccess(bean: nil)
            }
        }
    }

    // 扇贝
    public func getShanBeiData() {
        let url = "https://apiv3.shanbay.com/weapps/dailyquote/quote"
        AF.request(url).responseData { response in
            do {
                // 注意 bean 名称不能轻易用Data名字
                let bean = try JSONDecoder().decode(ShanBeiBean.self, from: response.value!) as ShanBeiBean?
                
                let itemBean = OneContentListBean()
                itemBean.img_url = bean?.origin_img_urls?[0]
                itemBean.forward = bean?.translation
                itemBean.title = bean?.author
                itemBean.words_info = bean?.content
                var list : [OneContentListBean] = [OneContentListBean]()
                list.append(itemBean)
                let oneBean = OneBean()
                let oneData = OneData()
                oneData.content_list = list
                oneBean.data = oneData

                self.navigation?.onDataSuccess(bean: oneBean)
            } catch {
                // print error here.
                self.navigation?.onDataSuccess(bean: nil)
            }
        }
    }
}
