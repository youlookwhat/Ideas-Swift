//
//  DialogUtil.swift
//  quote
//
//  Created by 景彬 on 2022/9/21.
//  Copyright © 2022 景彬. All rights reserved.
//

import Foundation
class DialogUtil {
    
    
    // 删除弹框
    public class func showDeleteAlert(vc:UIViewController,handle : ((UIAlertAction) -> Void)?){
        let alertController = UIAlertController(title: "是否删除此条内容?",message: nil, preferredStyle: .alert)
        let cancerAction = UIAlertAction(title: "取消", style: .default, handler: nil)
        let okAction = UIAlertAction(title: "确定", style: .default, handler: handle)
        alertController.addAction(cancerAction)
        alertController.addAction(okAction)
        vc.present(alertController, animated: true, completion: nil)
    }

    // 复制弹框
    public class func showBottomAlert(vc:UIViewController,handle : ((UIAlertAction) -> Void)?) {
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let cancelAction = UIAlertAction(title: NSLocalizedString("取消", comment: ""), style: .cancel, handler: nil)
        let milesAction = UIAlertAction(title: NSLocalizedString("复制全文", comment: ""), style: .default, handler: handle)
        alertController.addAction(cancelAction)
        alertController.addAction(milesAction)
        vc.present(alertController, animated: true, completion: nil)

    }

    
}
