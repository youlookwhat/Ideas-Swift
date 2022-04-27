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
        let url = "http://v3.wufazhuce.com:8000/api/channel/one/0/0"
        let parameters = ["foo": "bar"]
        
//        AF.request(url,parameters: parameters, encoder: JSONParameterEncoder.default).response { result in
            
        AF.request(url).responseJSON { result in
//           if let obj = result.value {
//           let dict = obj as! NSDictionary
            
            print(result)
//           self.newsContent = NewsContent(dict: dict)
//            }
        }
        
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

