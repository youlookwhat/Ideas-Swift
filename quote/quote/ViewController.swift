//
//  ViewController.swift
//  quote
//
//  Created by 景彬 on 2022/4/26.
//  Copyright © 2022 景彬. All rights reserved.
//

import UIKit



class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        // 解析：https://juejin.cn/post/6875140053635432462
        // https://stackoverflow.com/questions/51318926/swift-json-to-model-class
        let url = "http://v3.wufazhuce.com:8000/api/channel/one/0/0"
//        let parameters = ["foo": "bar"]
        
//        AF.request(url,parameters: parameters, encoder: JSONParameterEncoder.default).response { result in
            
        AF.request(url).responseData { response in
            do {
                let bean = try JSONDecoder().decode(Bean.self, from: response.value!) as Bean
                print(bean.res==0)
                print(bean.data!.content_list?[1].category)
            } catch {
                // print error here.
            }
            
            
//        AF.request(url).response { response in
//           if let json = response.value {
//           let dict = obj as! NSDictionary
            
//            result.raw
//            print(result)
//           self.newsContent = NewsContent(dict: dict)
//            let json = JSON(obj)
//            print(JSON(response))
            
            //JSON转化为Data
//            json.rawData()
            
            // 有值 0
//            print(json["res"].int)
            
            // 对象

            
//            let bean :Bean = json["data"].object as! Bean
//            print(bean.id)
            
//            let data = json.object as! Bean
             
//            let jsonObject = json.rawValue  as AnyObject
            
//            let data : Bean? = json.rawData()
//            print(data.res)
//            }
            
            
            
//            switch response.result.isSuccess {
//            case true:
//                if let value = response.result.value {
//                    let json = JSON(response)
//                    print(json)
//                    if let number = json[0]["phones"][0]["number"].string {
//                        // 找到电话号码
//                        print("第一个联系人的第一个电话号码：",number)
//                    }
//                }
//            case false:
//                print(response.result.error)
//            }
//        }
        
//        let login = Login(email: "test@test.test", password: "testPassword")
//
//        AF.request("https://httpbin.org/post",
//                   method: .post,
//                   parameters: login,
//                   encoder: JSONParameterEncoder.default).response { response in
//            debugPrint(response)
//        }

        
    }


}

struct Login: Encodable {
    let email: String
    let password: String
}

    class Bean :Decodable {
        var res:Int? = nil
        var data:Data? = nil
    }
    class Data:Decodable {
        var id:String? = nil
        var content_list:[ContentListBean]? = nil
    }

    class ContentListBean :Decodable{
        var category:String? = nil
    }
}
