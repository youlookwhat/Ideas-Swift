//
//  IdeaEditViewController.swift
//  quote
//
//  Created by 景彬 on 2022/9/24.
//  Copyright © 2022 景彬. All rights reserved.
//

import UIKit

// 编辑页
class IdeaEditViewController: BaseViewController {
    
    var id :Int? = 0
    var note:NoteBean? = nil
    var present:IdeaEditPresent?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.isHidden = true
        // 一定要设置背景
        view.backgroundColor = UIColor(lightThemeColor: UIColor.colorF3F3F3, darkThemeColor: .black)

        present = IdeaEditPresent()
        present?.setContentView(view)
        initData()
    }
    
    func initData(){
        note = DatabaseUtil.getNote(from: id)
        if note != nil {
            present?.commentTextView.text = note?.title
        }
    }
    
    
    public class func start(nc : UINavigationController?, id:Int?) {
        let vc = IdeaEditViewController()
        vc.id = id
        nc?.pushViewController(vc, animated: true)
    }
}
