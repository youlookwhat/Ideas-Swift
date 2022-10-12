//
//  IdeasViewController.swift
//  quote，点击 quote.xcworkspace
//
//  Created by 景彬 on 2022/7/20.
//  Copyright © 2022 景彬. All rights reserved.
//

import UIKit
import MJRefresh
import RealmSwift

class IdeasViewController: BaseViewController, IdeasNavigation,UITextFieldDelegate, IdeaSendEditViewDelegate, ValueBackDelegate{
        
    var sidebar:DCSidebar? = nil
    // 数据
    var list:[NoteBean]?
    // P层
    var present:IdeasPresent?
    // 重试按钮
    var emptyLayout:UIView?
    // 发布弹框
    var viewEdit : IdeaSendEditView? = nil
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        print("已经显示")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("IdeasViewController将要显示了")
        self.navigationItem.largeTitleDisplayMode = .automatic
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // 隐藏导航栏(标题栏)
        navigationController?.navigationBar.isHidden = false
        navigationItem.title = "ideas"
        navigationController?.title = "ideas"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationItem.largeTitleDisplayMode = .automatic
        view.backgroundColor = UIColor(lightColor: UIColor.colorF3F3F3, darkColor: .black)
        
        let item1=UIBarButtonItem(title:"关于",style: UIBarButtonItem.Style.plain,target:self,action:#selector(openAbout))
//        let item1=UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.trash,target:self,action:#selector(openAbout))
        let item2=UIBarButtonItem(title:"一个",style: UIBarButtonItem.Style.plain,target:self,action:#selector(openMenu))
//        self.navigationItem.rightBarButtonItem=item1
        self.navigationItem.rightBarButtonItems=[item1,item2]
        
//        let items1=UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.pause,target:self,action:nil)
//        let items2=UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.action,target:self,action:nil)
//        self.navigationItem.rightBarButtonItems=[items1,items2]

        
        hideTitleLayout();
        
        view.addSubview(tableView)
        view.addSubview(sendImage)
        present = IdeasPresent(navigation: self)
        emptyLayout = present?.addEmptyLayout(view:self.view)
        emptyLayout?.isHidden = true
        addIdeaSendEditView()
        
//        viewEdit.isHidden = true
//        viewEdit.delegate = self
//        view.addSubview(viewEdit)
        
        sendImage.snp.makeConstraints{ make in
            make.bottom.equalToSuperview().offset(-30)
            make.centerX.equalToSuperview()
            make.width.height.equalTo(70)
        }
        
        // 下拉刷新
//        tableView.mj_header = MJRefreshNormalHeader { [weak self] in
//            // load some data
//            self?.present?.refresh()
//          }.autoChangeTransparency(true)
//          .link(to: tableView)
        
        print("viewDidLoad---")
        
        
        tableView.snp.remakeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalToSuperview()
            make.bottom.equalToSuperview()
            make.width.equalTo(Screen.width)
            make.height.equalTo(Screen.height)
        }
        
        // 加载更多
        tableView.mj_footer = MJRefreshAutoNormalFooter{  [weak self] in
            self?.tableView.mj_footer?.endRefreshingWithNoMoreData()
        }.autoChangeTransparency(true)
       .link(to: tableView)
        
//        initTitleView()
//        sidebar = DCSidebar(sideView: view)
//        sidebar?.showAnimationsTime = 0.2
//        sidebar?.hideAnimationsTime = 0.2
        
        present?.refresh()
        
        
        
        // 下拉刷新
        tableView.mj_header?.beginRefreshing()
  
//        viewEdit.isHidden = true
//        //        viewEdit.delegate = self
//        viewEdit.snp.makeConstraints{ make in
//            make.height.equalTo(Screen.height)
//            make.width.equalTo(Screen.width)
//        }
        
        // 监听键盘弹起
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillAppear(notification:)), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)

        // 长按事件
        let longPressRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(longPressed(sender:)))
        tableView.addGestureRecognizer(longPressRecognizer)
    }
    
    @objc func longPressed(sender: UILongPressGestureRecognizer) {
        if sender.state == UIGestureRecognizer.State.began {
                let touchPoint = sender.location(in: self.tableView)
                if let indexPath = tableView.indexPathForRow(at: touchPoint) {
                    let bean = list?[indexPath.row]
                    DialogUtil.showBottomAlert(vc: self, handle: {_ in
                        Tools.copy(text: bean?.title)
                        self.view.makeToast("复制成功", duration: 1.0, position: .center)
                    })
                }
        }
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()

    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        print("viewWillTransition--")
        
        // 注意使用：remakeConstraints
        
        // 这里如果使用Screen.width可能还是上一次的宽高
        viewEdit?.snp.remakeConstraints{ make in
            make.height.equalTo(size.height)
            make.width.equalTo(size.width)
        }
        // 改变输入框的宽度
        viewEdit?.commentTextView.frame = CGRect(x: 0, y: 0, width: size.width - 30, height: 58)
        
        if (size.width > size.height) {
            // 横屏布局
            viewEdit?.backView.snp.remakeConstraints{ make in
                make.left.equalToSuperview().offset(kSafeAreaHeightAllways)
                make.right.equalToSuperview().offset(-kSafeAreaHeightAllways)
                make.width.equalTo(Screen.width-2*kSafeAreaHeightAllways)
                make.bottom.equalToSuperview()
            }
            emptyLayout?.snp.remakeConstraints {make in
                make.left.right.equalTo(0)
                make.height.equalTo(350)
                make.top.equalTo(kNavigationBarHeight)
            }
        } else {
            // 竖屏布局
            viewEdit?.backView.snp.remakeConstraints{ make in
                make.left.right.equalToSuperview()
                make.width.equalTo(Screen.width)
                make.bottom.equalToSuperview()
            }
            emptyLayout?.snp.remakeConstraints {make in
                make.left.right.equalTo(0)
                make.height.equalTo(350)
                make.top.equalTo(Screen.navigationBarHeight(self.navigationController) + 120)
            }
        }
        
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
        label.textColor = UIColor(lightColor: .black, darkColor: .white)
        label.font = UIFont(name: "PingFangSC-Medium", size: 17)
        label.text = "ideas"
        label.textAlignment = .center
        return label
    }()
    
    
    lazy var labelTimeDay: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(lightColor: .black, darkColor: .white)
        label.font = UIFont(name: "PingFangSC-Medium", size: 28)
        label.textAlignment = .center
        label.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(refreshAll)))
        label.isUserInteractionEnabled = true
        return label
    }()
    
    lazy var labelTimeYearMon: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(lightColor: .black, darkColor: .white)
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
        bt2.setTitleColor(UIColor(lightColor: .gray, darkColor: .white), for: .normal)
        bt2.addTarget(self, action: #selector(openAbout), for: .touchUpInside)
        return bt2;
    }()
    
    // 打开菜单
    @objc func openMenu(){
        let vc = OneViewController()
//        navigationController?.t
//        navigationController?.navigationBar.prefersLargeTitles = false
        navigationController?.pushViewController(vc, animated: true)
    }
    
    // 点击日期，刷新所有
    @objc func refreshAll(){
        present?.page = 1
        self.tableView.mj_header?.beginRefreshing()
    }
    
    // 点击关于
    @objc func openAbout(){
        // 使用浏览器打开
        openUrl(urlString: "https://github.com/youlookwhat/flomo-offline")
        
//        WebViewViewController.start(nc: navigationController, url: "https://github.com/youlookwhat/ByQuoteApp", titleOut: "loading")
    }
    
    func sendData() {
        send()
    }
    
    // 发布内容
    @objc func send(){
        viewEdit?.isHidden = false
        viewEdit?.commentTextView.becomeFirstResponder()
    }
    
    func onDataSuccess(bean: [NoteBean]?) {
        // 下拉刷新完成，收起
        self.tableView.mj_header?.endRefreshing()
        // 加载更多完成
        self.tableView.mj_footer?.endRefreshing()
        
        if (bean != nil && bean!.count > 0) {
            emptyLayout?.isHidden = true
            tableView.isHidden = false
            
            list = bean!
            self.tableView.reloadData()
            
        } else {
            // 只有第一页才显示错误页面
            tableView.isHidden = true
            emptyLayout?.isHidden = false
        }
        addIdeaSendEditView()
    }
    
    // 添加发布布局
    func addIdeaSendEditView(){
        if viewEdit == nil {
            viewEdit = IdeaSendEditView()
            view.addSubview(viewEdit!)
            viewEdit!.isHidden = true
            viewEdit!.delegate = self
            viewEdit!.snp.makeConstraints{ make in
                make.left.right.equalToSuperview()
                make.height.equalTo(Screen.height)
                make.width.equalTo(Screen.width)
            }
        }
    }
    
    lazy var tableView: UITableView = {
        // viewBounds() 限制了tableView的宽高，距上状态栏+44，这样写二级页面返回时大标题会收起来
        let tableView = UITableView(frame: self.view.frame, style: .plain)
        tableView.backgroundColor = UIColor(lightColor: UIColor.colorF3F3F3, darkColor: .black)

        // 可以使cell延伸到安全区域
//        tableView.insetsContentViewsToSafeArea = false
        
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
        tableView.register(IdeaCell.self, forCellReuseIdentifier: "CellIdentifier")
//        tableView.mj_footer = MJDIYFooter(refreshingBlock: {
//            self.requestData()
//        })
        return tableView
    }()

}

// 记录点击的时间
var taptime:Int = 0

extension IdeasViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        list?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CellIdentifier", for: indexPath) as! IdeaCell

        // 去掉默认颜色，可去掉侧边的白色
        cell.contentView.backgroundColor = .clear
        cell.backgroundColor = .clear
        
        
        // 没有选中的样式，一般都没有
        cell.selectionStyle = .none
        
        let topic = list?[indexPath.row]
        cell.model = topic
        
//        cell.moreImage.tag = indexPath.row
//        cell.moreImage.isUserInteractionEnabled = true
//        cell.moreImage.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: #selector(clickMore(_:))))
        
        return cell
    }
    
    // 单击&双击的操作
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //10位数时间戳
//        let current = Int(Date.init().timeIntervalSince1970)*1000
//        if (current - taptime < 500) {
//            // 双击事件
//            let bean = list?[indexPath.row]
//            if (bean?.id != nil) {
//                IdeaEditViewController.start(nc: navigationController, id: bean?.id,position: indexPath.row, backDelegate: self)
//            }
//        }
//        taptime = current;
        let bean = list?[indexPath.row]
        if (bean?.id != nil) {
            IdeaEditViewController.start(nc: navigationController, id: bean?.id,position: indexPath.row, backDelegate: self)
        }
    }
    
    
    //设置哪些行可以编辑
      func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
            if(indexPath.row == 0){
                return true
            }else{
                return true
            }
        }
    
    
    // 设置单元格的编辑的样式
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return UITableViewCell.EditingStyle.delete
    }
    
    
    func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String? {
        return "删除"
    }
    
    //设置点击删除之后的操作
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
//            DialogUtil.showDeleteAlert(vc: self, handle: {_ in
//
//            })
            let note = self.list?[indexPath.row]
            if note != nil {
                DatabaseUtil.deleteNote(note: note!)
                self.list?.remove(at: indexPath.row)
                
               // 删除第row行
               tableView.beginUpdates()
               tableView.deleteRows(at: [indexPath], with: .fade)
               tableView.endUpdates()
                
                // 最后一条被删除，显示空布局
                if self.list?.count == 0 {
                    self.emptyLayout?.isHidden = false
                    self.tableView.isHidden = true
                }
            }
            
            // Delete the row from the data source
//                workManager.updateCollection(withYear: yearForSearch, month: monthForSearch, row: indexPath.row - 1)
//                count = count - 1
//                tableView.deleteRows(at: [indexPath], with: .fade)
//                tableView.reloadRows(at: [IndexPath(row: 0, section: 0)], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
    }
    
    
    // 点击更多
//   @objc func clickMore(_ tap: UITapGestureRecognizer) {
//       let img = tap.view as! UIImageView
//       let row = img.tag
//       print("editCar",row)
//   }

    
    
    @objc func keyboardWillAppear(notification: NSNotification) {
        print("弹起键盘了")
        viewEdit?.keyboardWillChangeFrame(notifi: notification as Notification)
    }
    

    func commentSend(content:String) {
        print("点击了发布")
        let note = NoteBean()
        note.title = content
        note.creatTime = TimeUtil.getCurrentTimeStamp()
        if(list==nil || list?.count==0){
            // 第一次发布
//            btNoNet?.removeFromSuperview()
            tableView.isHidden = false
            emptyLayout?.isHidden = true
            
            note.id = 0
            list = [NoteBean]()
            list?.append(note)
            tableView.reloadData()
        } else {
            note.id = (list?[0].id)! + 1// 一定要加不一样的主键，且不能为空
            list?.insert(note, at: 0)
            
            // 在第row行插入
            let indexPath1:IndexPath = IndexPath.init(row: 0, section: 0)
            tableView.beginUpdates()
            tableView.insertRows(at: [indexPath1], with: .fade)
            tableView.endUpdates()
        }
        DatabaseUtil.insertNote(by: note)
        
        viewEdit?.hideSendView(clearText: true)
    }
    
    func commentDismiss(dismissClick view: IdeaSendEditView, sender: UIButton?) {
        viewEdit?.hideSendView(clearText: false)
    }

    // 从编辑页回传的位置值
    func valueBack(position: Int,note: NoteBean) {
        let indexPath:IndexPath = IndexPath.init(row: position, section: 0)
        list?[position] = note
        tableView.reloadRows(at: [indexPath], with: .fade)
    }

}
