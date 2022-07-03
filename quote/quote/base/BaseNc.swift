//
//  BaseNc.swift
//  quote
//
//  Created by 景彬 on 2022/7/2.
//  Copyright © 2022 景彬. All rights reserved.
//

import UIKit

class BaseNc: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // 强制开启侧滑返回操作
        interactivePopGestureRecognizer?.delegate = self
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
