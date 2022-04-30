//
//  ViewController.swift
//  quote
//
//  Created by 景彬 on 2022/4/26.
//  Copyright © 2022 景彬. All rights reserved.
//

import UIKit


class ViewController: UIViewController, OneGetDataListener {
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        OneModel().getOneData(listener: self)
        
}
    func onData(bean: OneBean) {
        print(bean.res==0)
        print(bean.data!.content_list?[1].category)
        
    }
    

struct Login: Encodable {
    let email: String
    let password: String
}

}
