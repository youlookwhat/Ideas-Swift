//
//  FlomoViewController.swift
//  quote
//
//  Created by 景彬 on 2022/7/20.
//  Copyright © 2022 景彬. All rights reserved.
//

import UIKit
import MJRefresh
import RealmSwift

class FlomoViewController: BaseViewController, FlomoNavigation,UITextFieldDelegate, FlomoSendEditViewDelegate{

    
    var sidebar:DCSidebar? = nil
    // 数据
    var list:[NoteBean]?
    // P层
    var present:FlomoPresent?
    // 重试按钮
    var btNoNet:UIButton?
    var viewEdit = FlomoSendEditView()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.addSubview(tableView)
        
        // 隐藏导航栏(标题栏)
        navigationController?.navigationBar.isHidden = true
        navigationItem.title = "flomo"
        view.backgroundColor = UIColor(lightThemeColor: UIColor.colorF3F3F3, darkThemeColor: .black)
        
        // 下拉刷新
        tableView.mj_header = MJRefreshNormalHeader { [weak self] in
            // load some data
            self?.present?.refresh()
          }.autoChangeTransparency(true)
          .link(to: tableView)
        
        // 加载更多
        tableView.mj_footer = MJRefreshAutoNormalFooter{  [weak self] in
            self?.tableView.mj_footer?.endRefreshingWithNoMoreData()
        }.autoChangeTransparency(true)
       .link(to: tableView)
        
        initTitleView()
//        sidebar = DCSidebar(sideView: view)
//        sidebar?.showAnimationsTime = 0.2
//        sidebar?.hideAnimationsTime = 0.2
        
        present = FlomoPresent(navigation: self)
        present?.getOneData()
        
//
//        let viewEdit = XbsCommentEditView()
        viewEdit.isHidden = true
        viewEdit.delegate = self
        view.addSubview(viewEdit)
  

        viewEdit.snp.makeConstraints{ make in
            make.height.equalTo(Screen.height)
            make.width.equalTo(Screen.width)
        }
        
        // 监听键盘弹起
//        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillAppear(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)

        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillAppear(notification:)), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)


    }
    
    func showButtonTouchUpInside(_ sender: Any) {
        sidebar?.show()
    }
        
    func screenEdgePanGesture(_ sender: UIScreenEdgePanGestureRecognizer) {
        if sender.state == .ended {
            sidebar?.show()
        }
    }
    
    // 标题栏
    func initTitleView(){
        let toolView = UIView(frame: CGRect(x: 0, y: statusBarHeight, width: self.view.frame.width, height: 44))
        
//        toolView.backgroundColor = UIColor.white
        self.view.addSubview(toolView)
        
        toolView.addSubview(titleLable)
        toolView.addSubview(aboutImage)
        toolView.addSubview(menuImage)
        view.addSubview(sendImage)
        
        sendImage.snp.makeConstraints{ make in
            make.bottom.equalToSuperview().offset(-30)
            make.centerX.equalToSuperview()
            make.width.height.equalTo(70)
        }
        
        titleLable.snp.makeConstraints{ make in
            make.centerX.centerY.equalToSuperview()
        }
        menuImage.snp.makeConstraints { make in
            make.left.equalToSuperview()
            make.centerY.equalToSuperview()
            make.width.equalTo(70)
            make.height.equalTo(40)
        }
        aboutImage.snp.makeConstraints { make in
            make.right.equalToSuperview()
            make.width.height.equalTo(44)
        }
        
    }
    
    lazy var sendImage: UIImageView = {
        let image = UIImage(named: "icon_send")?.withRenderingMode(.alwaysOriginal)
        var ivBack:UIImageView  = UIImageView(image: image)
        ivBack.contentMode = .scaleAspectFit
        // 给图片加点击事件
        let singleTapGesture = UITapGestureRecognizer(target: self, action: #selector(send))
        ivBack.frame = CGRect(x: 0, y: 0, width: 70, height: 70)
        ivBack.addGestureRecognizer(singleTapGesture)
        ivBack.isUserInteractionEnabled = true
        return ivBack
    }()
    
    lazy var menuImage: UIImageView = {
        let image = UIImage(named: "icon_menu")?.withRenderingMode(.alwaysOriginal)
        var ivBack:UIImageView  = UIImageView(image: image)
//        ivBack.tintColor = UIColor(lightThemeColor: .black, darkThemeColor: .white)
        ivBack.contentMode = .scaleAspectFit
        // 给图片加点击事件
        let singleTapGesture = UITapGestureRecognizer(target: self, action: #selector(openMenu))
        ivBack.addGestureRecognizer(singleTapGesture)
        ivBack.isUserInteractionEnabled = true
        return ivBack
    }()
    
    lazy var aboutImage: UIImageView = {
        let image = UIImage(named: "icon_about")?.withRenderingMode(.alwaysOriginal)
        var ivBack:UIImageView  = UIImageView(image: image)
//        ivBack.tintColor = UIColor(lightThemeColor: .black, darkThemeColor: .white)
        ivBack.contentMode = .center
//        ivBack.frame = CGRect(x: 0, y: 0, width: 44, height: 44)
        // 给图片加点击事件
        let singleTapGesture = UITapGestureRecognizer(target: self, action: #selector(openAbout))
        ivBack.addGestureRecognizer(singleTapGesture)
        ivBack.isUserInteractionEnabled = true
        return ivBack
    }()
    
    lazy var titleLable: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(lightThemeColor: .black, darkThemeColor: .white)
        label.font = UIFont(name: "PingFangSC-Medium", size: 17)
        label.text = "flomo"
        label.textAlignment = .center
        return label
    }()
    
    
    lazy var labelTimeDay: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(lightThemeColor: .black, darkThemeColor: .white)
        label.font = UIFont(name: "PingFangSC-Medium", size: 28)
        label.textAlignment = .center
        label.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(refreshAll)))
        label.isUserInteractionEnabled = true
        return label
    }()
    
    lazy var labelTimeYearMon: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(lightThemeColor: .black, darkThemeColor: .white)
//        label.text = "07 . 2022"
        label.font = UIFont(name: "PingFangSC-Medium", size: 13)
//        label.font = UIFont.systemFont(ofSize: 13)
        label.textAlignment = .center
        return label
    }()
    
    lazy var labelAbout: UIButton = {
        // 添加关于按钮
        let bt2 = UIButton()
        bt2.setTitle("ByQuoteApp", for: .normal)
        // 设置文字大小
        bt2.titleLabel?.font = UIFont.systemFont(ofSize: 13)
        bt2.setTitleColor(UIColor(lightThemeColor: .gray, darkThemeColor: .white), for: .normal)
        bt2.addTarget(self, action: #selector(openAbout), for: .touchUpInside)
        return bt2;
    }()
    
    // 打开菜单
    @objc func openMenu(){
        let vc = OneViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    // 点击日期，刷新所有
    @objc func refreshAll(){
        present?.num = -1
        self.tableView.mj_header?.beginRefreshing()
    }
    
    // 点击关于
    @objc func openAbout(){
        let vc = WebViewViewController()
        vc.url = "https://github.com/youlookwhat/ByQuoteApp"
        vc.titleOut = "ByQuoteApp"
        navigationController?.pushViewController(vc, animated: true)
    }
    
    // 发布内容
    @objc func send(){
        viewEdit.isHidden = false
        viewEdit.commentTextView.becomeFirstResponder()
    }
    
    func onDataSuccess(bean: [NoteBean]?) {
        
        // 下拉刷新完成，收起
        self.tableView.mj_header?.endRefreshing()
        // 加载更多完成
        self.tableView.mj_footer?.endRefreshing()
        
        btNoNet?.removeFromSuperview()
        tableView.isHidden = false
        
//        if (bean != nil && bean!.data != nil && bean!.data!.weather != nil){
//            let weather = bean!.data!.weather
//            let date = weather?.date
//            if (date!.contains("-")){
//                // 以 - 切割
//                let times = date?.components(separatedBy: "-")
//                if (times!.count == 3){
//                    labelTimeDay.text = times?[2]
//                    labelTimeYearMon.text = "\(times![1]) . \(times![0])"
//                }
//            }
//        }
        if (bean != nil) {
            switch present?.num {
            case 0:
                list = bean!
                self.tableView.reloadData()
            default:
                list = bean!
                self.tableView.reloadData()
//                list?.insert(contentsOf: bean![0], at: 0)
                // 在第row行插入
//                let indexPath1:IndexPath = IndexPath.init(row: 0, section: 0)
//                tableView.beginUpdates()
//                tableView.insertRows(at: [indexPath1], with: .fade)
//                tableView.endUpdates()
            }
            
        } else if present!.num == 0{
            // 只有第一页才显示错误页面
//            tableView.removeFromSuperview()
            tableView.isHidden = true
            btNoNet = UIButton(frame: viewBounds())
            btNoNet!.setTitle("请检查网络，点击重试", for: .normal)
            // 设置文字大小
            btNoNet!.titleLabel?.font = UIFont.systemFont(ofSize: 14)
            btNoNet!.setTitleColor(UIColor(lightThemeColor: .black, darkThemeColor: .white), for: .normal)
            btNoNet!.addTarget(self, action: #selector(reLoad), for: .touchUpInside)
            view.addSubview(btNoNet!)
        } else {
            self.tableView.mj_footer?.endRefreshingWithNoMoreData()
        }
    }

    // 重新加载
    @objc func reLoad(){
//        view.addSubview(tableView)
        present?.getOneData()
    }
    
    lazy var tableView: UITableView = {
        // viewBounds() 限制了tableView的宽高，距上状态栏+44
        let tableView = UITableView(frame: viewBounds(), style: .plain)
//        let tableView = UITableView(frame: self.view.frame, style: .plain)
//        tableView.backgroundColor = .white
        tableView.backgroundColor = UIColor(lightThemeColor: UIColor.colorF3F3F3, darkThemeColor: .black)
        // 这里的100是像素，不是文字对应的高度，要将高度转为像素
//        tableView.rowHeight = Screen.width * (1175/2262.0) + 170.0
        // 自适应高度添加 1.这两行属性 初始高度和配置 2.最底部的一个cell配上bottom属性
        tableView.estimatedRowHeight = Screen.width * (1175/2262.0) + 170.0
        tableView.rowHeight = UITableView.automaticDimension
        
        tableView.dataSource = self
        tableView.delegate = self
        // 分割线，加了以后最上面也有分割线
        tableView.separatorStyle = .none
//        tableView.separatorColor = UIColor.gray
//        tableView.separatorInset = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15)
        
        tableView.tableFooterView = UIView()
        tableView.register(FlomoCell.self, forCellReuseIdentifier: "CellIdentifier")
//        tableView.mj_footer = MJDIYFooter(refreshingBlock: {
//            self.requestData()
//        })
        return tableView
    }()

}


extension FlomoViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        list?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CellIdentifier", for: indexPath) as! FlomoCell

        // 没有选中的样式，一般都没有
        cell.selectionStyle = .none
        
        let topic = list?[indexPath.row]
        cell.model = topic
        
        cell.moreImage.tag = indexPath.row
        cell.moreImage.isUserInteractionEnabled = true
        cell.moreImage.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: #selector(clickMore(_:))))
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let bean = list?[indexPath.row]
//        guard let bean = bean else { return }
        
//        if (bean.share_url != nil && bean.share_url != "") {
//            let vc = WebViewViewController()
//            vc.url = bean.share_url
//            vc.titleOut = bean.title ?? "loading"
//            navigationController?.pushViewController(vc, animated: true)
//        }
    }
    
    // 点击更多
   @objc func clickMore(_ tap: UITapGestureRecognizer) {
       let img = tap.view as! UIImageView
       let row = img.tag
       print("editCar",row)
   }

    
    
    @objc func keyboardWillAppear(notification: NSNotification) {
        print("弹起键盘了")
        viewEdit.keyboardWillChangeFrame(notifi: notification as Notification)
    }
    

    func commentSend(content:String) {
        print("点击了发布")
        let note = NoteBean()
        note.title = content
        note.creatTime = TimeUtil.getCurrentTimeStamp()
        note.id = (list?[0].id)! + 1// 一定要加不一样的主键，且不能为空
        DatabaseUtil.insertNote(by: note)
        
        list?.insert(note, at: 0)
        
       // 在第row行插入
       let indexPath1:IndexPath = IndexPath.init(row: 0, section: 0)
       tableView.beginUpdates()
       tableView.insertRows(at: [indexPath1], with: .fade)
       tableView.endUpdates()
        
//        viewEdit.endEditing(true)
//        viewEdit.isHidden = true
    }
    
    
    func commentDismiss(dismissClick view: FlomoSendEditView, sender: UIButton?) {
        viewEdit.endEditing(true)
        viewEdit.isHidden = true
    }


}
