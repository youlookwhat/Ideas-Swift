//
//  OnePresent.swift
//  quote
//
//  Created by 景彬 on 2022/5/1.
//  Copyright © 2022 景彬. All rights reserved.
//

import UIKit
import Alamofire
import RealmSwift

/*
 * Ideas首页
 */
class IdeasPresent {

    var navigation :IdeasNavigation?
    var page : Int = 1
    
    init(navigation :IdeasNavigation) {
        self.navigation = navigation
    }
    
    public func getDBData() {
        // 看是否要放在异步获取
        let notes = DatabaseUtil.getSortedNotes()
        var list = [NoteBean]()
        for note in notes {
            list.append(note)
        }
        navigation?.onDataSuccess(bean: list)
    }
    
    // 刷新数据
    func refresh(){
        getDBData()
    }
    
    // 获取空视图
    public func addEmptyLayout(view : UIView) -> UIView {
        let uiView = UIView(frame: CGRect(x: 0,y: 0,width: kScreenWidth,height: kScreenHeight))
//        uiView.backgroundColor = UIColor(lightColor: UIColor.colorF3F3F3, darkColor: .black)
        uiView.addSubview(emptyImage)
        uiView.addSubview(btNoNet)
        view.addSubview(uiView)
        
        // 要先addSubview，再设置frame
        uiView.snp.makeConstraints {make in
            make.width.equalTo(kScreenWidth)
            make.height.equalTo(350)
            make.top.equalTo(kNavigationBarHeight + 50)
        }
        emptyImage.snp.makeConstraints {make in
            make.width.height.equalTo(180)
            make.top.equalTo(70)
            make.centerX.equalToSuperview()
        }
        btNoNet.snp.makeConstraints {make in
            make.width.equalTo(120)
            make.height.equalTo(40)
            make.top.equalTo(emptyImage.snp.bottom).offset(15)
            make.centerX.equalToSuperview()
        }

        // UIButton点击无效情况整理:https://www.jianshu.com/p/79c967789a21
        // UIView的frame被设置，虽然能看见，但是frame是CGRectZero，没有点击区域
        btNoNet.isUserInteractionEnabled = true
        btNoNet.addTarget(self, action: #selector(sendBtnClik), for: .touchUpInside)
        return uiView;
    }

    /// 发送
    @objc func sendBtnClik() {
        navigation?.sendData()
    }
    
    lazy var btNoNet: UIButton = {
        let btNoNet = UIButton(frame: CGRect(x: 0, y: 0, width: 120, height: 40))
        btNoNet.layer.cornerRadius = 20
        btNoNet.setTitle("添加想法", for: .normal)
        btNoNet.backgroundColor = .colorTheme
        // 设置文字大小
        btNoNet.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        btNoNet.setTitleColor(.white, for: .normal)
//        btNoNet.isUserInteractionEnabled = true
//        btNoNet.addTarget(self, action: #selector(sendBtnClik), for: .touchUpInside)
        return btNoNet
    }()
    
    lazy var emptyImage: UIImageView = {
        let image = UIImage(named: "bg_home_empty")?.withRenderingMode(.alwaysOriginal)
        var ivBack:UIImageView  = UIImageView(image: image)
        ivBack.contentMode = .scaleAspectFit
        ivBack.frame = CGRect(x: 0, y: 0, width: 180, height: 180)
        // 给图片加点击事件
//        ivBack.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(send)))
//        ivBack.isUserInteractionEnabled = true
        return ivBack
    }()
    
    
}
