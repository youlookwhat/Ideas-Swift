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
        
        let url = "http://v3.wufazhuce.com:8000/api/channel/one/0/0"
        AF.request(url).response { result in
           if let obj = result.value {
//           let dict = obj as! NSDictionary
           print(obj)
//           self.newsContent = NewsContent(dict: dict)
            }
        }
    }


}

