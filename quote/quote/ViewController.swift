//
//  ViewController.swift
//  quote
//
//  Created by 景彬 on 2022/4/26.
//  Copyright © 2022 景彬. All rights reserved.
//

import UIKit


class ViewController: UIViewController, OneNavigation {
    
    var present:OnePresent?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        
        navigationItem.title = "每日句子"
        view.backgroundColor = UIColor.white
        
        present = OnePresent(navigation: self)
        present?.getOneData()
    }

    
    func onDataSuccess(bean: OneBean?) {
        if bean != nil {
            print(bean!.res==0)
            print(bean!.data!.content_list?[1].category)
        } else {
            // 无内容
        }
    }
    

struct Login: Encodable {
    let email: String
    let password: String
}

}
