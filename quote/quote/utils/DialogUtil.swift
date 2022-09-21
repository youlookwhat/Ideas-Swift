//
//  DialogUtil.swift
//  quote
//
//  Created by 景彬 on 2022/9/21.
//  Copyright © 2022 景彬. All rights reserved.
//

import Foundation
class DialogUtil {
    
    
    public class func showDeleteAlert(vc:UIViewController,handle : ((UIAlertAction) -> Void)?){
        let alertController = UIAlertController(title: "是否删除此条内容?",message: nil, preferredStyle: .alert)
        let cancerAction = UIAlertAction(title: "取消", style: .default, handler: nil)
        let okAction = UIAlertAction(title: "确定", style: .default, handler: handle)
        alertController.addAction(cancerAction)
        alertController.addAction(okAction)
        vc.present(alertController, animated: true, completion: nil)
    }

}
