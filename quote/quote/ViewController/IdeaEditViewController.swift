//
//  IdeaEditViewController.swift
//  quote
//
//  Created by 景彬 on 2022/9/24.
//  Copyright © 2022 景彬. All rights reserved.
//

import UIKit

// 编辑页
class IdeaEditViewController: BaseViewController, IdeaEditNavigation {
    
    var id :Int? = 0
    var note:NoteBean? = nil
    var present:IdeaEditPresent?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.isHidden = true
        // 一定要设置背景
        view.backgroundColor = UIColor(lightThemeColor: UIColor.colorF3F3F3, darkThemeColor: .black)

        present = IdeaEditPresent(self)
        present?.setContentView(view)
        initData()
    }
    
    func initData(){
        note = DatabaseUtil.getNote(from: id)
        if note != nil {
            present?.commentTextView.text = note?.title
        }
    }
    
    // 发布
    func onSend(content: String) {
        if note != nil {
            // 不能直接改变数据库里直接获取的值，需要新建一个更新
            // note?.title = content
            var noteBean = NoteBean()
            noteBean.id = note!.id
            noteBean.title = content
            noteBean.creatTime = note?.creatTime
            DatabaseUtil.updateNote(note: noteBean)
        }
        finish()
    }
    
    public class func start(nc : UINavigationController?, id:Int?) {
        let vc = IdeaEditViewController()
        vc.id = id
        nc?.pushViewController(vc, animated: true)
    }
}
