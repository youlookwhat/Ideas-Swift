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
        hideTitleLayout()
        
        // 一定要设置背景
        view.backgroundColor = UIColor(lightColor: UIColor.colorF3F3F3, darkColor: .black)
        
        present = IdeaEditPresent(self)
        present?.setContentView(self, view)
        initData()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        // 每一次ui变化都会更新
        print("viewWillLayoutSubviews--IdeaEditViewController\(kSafeAreaInset)")
    }

    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        // 将要屏幕旋转，执行时kSafeAreaInset里的值还没有更新，取的是上一次状态的值。安全的top或left就是状态栏高度
        print("屏幕旋转\(kSafeAreaInset)")
        var left = 0.0
        var top = 0.0
        if size.width > size.height {
            // 将要为横屏，之前为竖屏，取的是竖屏的top
            left = kSafeAreaHeightAllways
            top = kSafeAreaHeightAllways
        } else {
            // 将要为竖屏，之前为横屏，取的是竖屏的left
            left = 0.0
            top = kSafeAreaHeightAllways+44
        }
        present?.uiBottomView.snp.remakeConstraints{ make in
            make.height.equalTo(50)
            make.width.equalTo(Screen.width)
            // 要处理指示器的高度，需要单独在uiBottomView底部设置
            make.bottom.equalToSuperview()
            make.left.equalToSuperview().offset(left)
            make.right.equalToSuperview().offset(-left)
        }
        
        present?.uiHeaderView.snp.remakeConstraints { make in
            // 减去安全区域的宽度
            make.width.equalTo(Screen.width-30-2*left)
            make.left.equalToSuperview().offset(left+15)
            make.right.equalToSuperview().offset(-left-15)
            make.top.equalToSuperview().offset(top+10)
            // 这里设置才能使输入框一直在底部栏之上
            make.bottom.equalTo(present!.uiBottomView.snp.top).offset(-10)
        }
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
