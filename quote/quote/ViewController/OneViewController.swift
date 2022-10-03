//
//  OneViewController.swift
//  quote
//
//  Created by 景彬 on 2022/5/31.
//  Copyright © 2022 景彬. All rights reserved.
//

import UIKit
import MJRefresh


class OneViewController: BaseViewController, OneNavigation {
    
    var sidebar:DCSidebar? = nil
    // 数据
    var list:[OneContentListBean]?
    // P层
    var present:OnePresent?
    // 重试按钮
    var btNoNet:UIButton?
    // 系统自己的下拉刷新，不松手也可以刷新，新布局没显示出来就end会跳动
    var refresh:UIRefreshControl?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("OneViewController将要显示了")
        // 注意这里的方式，不是使用navigationController?.navigationBar.prefersLargeTitles = true
        // https://so.muouseo.com/qa/q8m52v4de6wr.html
        self.navigationItem.largeTitleDisplayMode = .never
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationItem.largeTitleDisplayMode = .automatic
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        print("OneViewController已经消失了")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        hideTitleLayout()
        
        
        // 隐藏导航栏(标题栏)
//        navigationController?.navigationBar.isHidden = true
        // 这个是下面的大标题显示
        navigationItem.title = "一个"
        // 这个是转场后的箭头右侧的标题
//        navigationController?.title = "一个"
//        navigationController?.title = nil
        view.backgroundColor = UIColor(lightColor: .white, darkColor: .black)
        
        view.addSubview(tableView)
        
        // 先转场过来，不显示大标题，内容在导航栏下就覆盖了大标题。然后加载完内容时，隐藏大标题且设置内容全屏(为了可以看到导航栏下的半透明)。
        tableView.snp.makeConstraints{ make in
//            make.top.equalToSuperview().offset(kNavigationBarHeight)
            make.top.equalToSuperview()
            // 这里设置才能使输入框一直在底部栏之上
            make.bottom.equalToSuperview()
            make.width.equalTo(Screen.width)
            make.height.equalTo(kScreenHeight-kNavigationBarHeight)
        }
        
//        refresh = UIRefreshControl()
//        tableView.refreshControl = refresh
//        refresh!.addTarget(self, action: #selector(refreshSystem), for: .valueChanged)
//        refresh!.beginRefreshing()
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
        
        present = OnePresent(navigation: self)
        present?.getOneData()
    }
    
    @objc func refreshSystem(){
        present?.refresh()
    }
    
    @IBAction func showButtonTouchUpInside(_ sender: Any) {
        sidebar?.show()
    }
        
    @IBAction func screenEdgePanGesture(_ sender: UIScreenEdgePanGestureRecognizer) {
        if sender.state == .ended {
            sidebar?.show()
        }
    }
    
    // 标题栏
    func initTitleView(){
        let toolView = UIView(frame: CGRect(x: 0, y: statusBarHeight, width: self.view.frame.width, height: 44))
//        toolView.backgroundColor = UIColor.init(lightColor: .white,darkColor: .black)
        self.view.addSubview(toolView)
        
        toolView.addSubview(labelTimeDay)
        toolView.addSubview(labelTimeYearMon)
//        toolView.addSubview(labelAbout)
        
        // 使用时需要一个Superview
        labelTimeDay.snp.makeConstraints { make in
            make.right.equalTo(labelTimeYearMon.snp.left).offset(-10)
            make.bottom.equalTo(labelTimeYearMon.snp.bottom).offset(-8)
        }
        labelTimeYearMon.snp.makeConstraints { make in
            make.right.equalToSuperview()
            make.right.equalTo(-15)
            make.height.equalTo(44)
            // 垂直居中
            make.centerY.equalToSuperview()
        }
//        labelAbout.snp.makeConstraints { make in
//            make.top.equalToSuperview()
//            make.right.equalTo(-15)
////            make.width.equalTo(54)
//            make.height.equalTo(44)
//        }
    }
    
    lazy var labelTimeDay: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(lightColor: .black, darkColor: .white)
        label.font = UIFont(name: "PingFangSC-Medium", size: 30)
        label.textAlignment = .center
        label.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(refreshAll)))
        label.isUserInteractionEnabled = true
        return label
    }()
    
    lazy var labelTimeZhou: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(lightColor: .black, darkColor: .white)
//        label.text = "周一"
//        label.font = UIFont(name: "PingFangSC-Medium", size: 13)
        label.font = UIFont.systemFont(ofSize: 13)
        label.textAlignment = .center
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
    
//    lazy var labelAbout: UIButton = {
//        // 添加关于按钮
//        let bt2 = UIButton()
//        bt2.setTitle("ByQuoteApp", for: .normal)
//        // 设置文字大小
//        bt2.titleLabel?.font = UIFont.systemFont(ofSize: 13)
//        bt2.setTitleColor(UIColor(lightColor: .gray, darkColor: .white), for: .normal)
//        bt2.addTarget(self, action: #selector(openAbout), for: .touchUpInside)
//        return bt2;
//    }()
    
    // 点击日期，刷新所有，好像被标题栏覆盖了点不了，不过可以返回后重新进入刷新
    @objc func refreshAll(){
        present?.num = -1
        self.tableView.mj_header?.beginRefreshing()
    }
    
    func onDataSuccess(bean: OneBean?) {
        
        
        refresh?.endRefreshing()
        // 下拉刷新完成，收起
        self.tableView.mj_header?.endRefreshing()
        // 加载更多完成
        self.tableView.mj_footer?.endRefreshing()
        
        btNoNet?.removeFromSuperview()
        tableView.isHidden = false
        
        if (bean != nil && bean!.data != nil && bean!.data!.weather != nil){
            let weather = bean!.data!.weather
            let date = weather?.date
            if (date!.contains("-")){
                // 以 - 切割
                let times = date?.components(separatedBy: "-")
                if (times!.count == 3){
                    labelTimeDay.text = times?[2]
                    labelTimeYearMon.text = "\(times![1]) . \(times![0])"
                }
            }
        }
        if (bean != nil && bean!.data != nil && bean!.data!.content_list != nil) {
            switch present?.num {
            case 0:
                list  = bean!.data!.content_list
                self.tableView.reloadData()
            default:
                list?.insert(contentsOf: bean!.data!.content_list!, at: 0)
                // 在第row行插入
                let indexPath1:IndexPath = IndexPath.init(row: 0, section: 0)
                tableView.beginUpdates()
                tableView.insertRows(at: [indexPath1], with: .fade)
                tableView.endUpdates()
            }
            
        } else if present!.num == 0{
            // 只有第一页才显示错误页面
//            tableView.removeFromSuperview()
            tableView.isHidden = true
            btNoNet = UIButton(frame: viewBounds())
            btNoNet!.setTitle("请检查网络，点击重试", for: .normal)
            // 设置文字大小
            btNoNet!.titleLabel?.font = UIFont.systemFont(ofSize: 14)
            btNoNet!.setTitleColor(UIColor(lightColor: .black, darkColor: .white), for: .normal)
            btNoNet!.addTarget(self, action: #selector(reLoad), for: .touchUpInside)
            view.addSubview(btNoNet!)
        } else {
            self.tableView.mj_footer?.endRefreshingWithNoMoreData()
        }
        
        // 加载成功处理导航栏
//        navigationItem.title = "一个"
//        navigationController?.navigationBar.prefersLargeTitles = false
//        tableView.snp.updateConstraints{ make in
//            make.top.equalToSuperview()
//            make.bottom.equalToSuperview()
//            make.width.equalTo(Screen.width)
//            make.height.equalTo(kScreenHeight)
//        }
    }

    // 重新加载
    @objc func reLoad(){
//        view.addSubview(tableView)
        present?.getOneData()
    }
    
    lazy var tableView: UITableView = {
        // viewBounds() 限制了tableView的宽高，距上状态栏+44
//        let tableView = UITableView(frame: viewBounds(), style: .plain)
        let tableView = UITableView(frame: self.view.frame, style: .plain)
//        let tableView = UITableView(frame: CGRect(x: 0, y: kNavigationBarHeight, width: kScreenWidth, height: kScreenHeight-kNavigationBarHeight), style: .plain)
//        tableView.backgroundColor = .white
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
        tableView.register(HomeListCell.self, forCellReuseIdentifier: "CellIdentifier")
//        tableView.mj_footer = MJDIYFooter(refreshingBlock: {
//            self.requestData()
//        })
        return tableView
    }()

}


extension OneViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        list?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CellIdentifier", for: indexPath) as! HomeListCell

        // 没有选中的样式，一般都没有
        cell.selectionStyle = .none
        
        let topic = list?[indexPath.row]
        cell.model = topic
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let bean = list?[indexPath.row]
        guard let bean = bean else { return }
        
        if (bean.share_url != nil && bean.share_url != "") {
            WebViewViewController.start(nc: navigationController, url: bean.share_url, titleOut: bean.title)
        }
    }
}
