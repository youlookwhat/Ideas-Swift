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
    
    // 用于会传值给上一个页面
    var backDelegate:ValueBackDelegate? = nil
    // cell位置
    var position :Int = 0
    var id :Int? = 0
    var note:NoteBean? = nil
    var present:IdeaEditPresent?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationItem.largeTitleDisplayMode = .never
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationItem.largeTitleDisplayMode = .automatic
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        navigationController?.navigationBar.isHidden = true
        hideTitleLayout()
        
        // 一定要设置背景
        view.backgroundColor = UIColor(lightColor: UIColor.colorF3F3F3, darkColor: .black)
        
        present = IdeaEditPresent(self)
        present?.setContentView(self, view)
        initData()
    }
    
    func initData(){
        note = DatabaseUtil.getNote(from: id)
        if note != nil {
            // 时间
            present?.timeLabel.text = TimeUtil.getDateFormatString(timeStamp: note!.creatTime)
            // 内容
            present?.commentTextView.text = note?.title
            // 键盘弹起
            present?.commentTextView.becomeFirstResponder()
            
            // 1.perform(必须在主线程中执行)
//            self.perform(#selector(delayExecution), with: nil, afterDelay: 0.5)
        }
    }
    
//    @objc func delayExecution(){
//        // 取消
//        NSObject.cancelPreviousPerformRequests(withTarget: self)
//    }
    
    // 发布
    func onSend(content: String) {
        if note != nil {
            // 不能直接改变数据库里直接获取的值，需要新建一个更新
            // note?.title = content
            let noteBean = NoteBean()
            noteBean.id = note!.id
            noteBean.title = content
            noteBean.creatTime = note?.creatTime
            DatabaseUtil.updateNote(note: noteBean)
            
            // 回传值
            if let a = backDelegate {
                a.valueBack(position: position, note: noteBean)
            }
        }
        finish()
    }
    
    
    public class func start(nc : UINavigationController?, id:Int?, position:Int, backDelegate:ValueBackDelegate?) {
        let vc = IdeaEditViewController()
        vc.id = id
        vc.position = position
        vc.backDelegate = backDelegate
        nc?.pushViewController(vc, animated: true)
    }
}

protocol ValueBackDelegate {
    func valueBack(position: Int,note: NoteBean)
}
