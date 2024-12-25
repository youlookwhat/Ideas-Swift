//
//  OneViewController.swift
//  quote
//
//  Created by 景彬 on 2022/5/31.
//  Copyright © 2022 景彬. All rights reserved.
//

import UIKit
import MJRefresh
import SnapKit


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
    var titleButton:UIBarButtonItem?
    private var tabCollectionView: UICollectionView!
    private var selectedTabIndex: Int = 0
    private let tabs = ["三重门", "零下一度", "像少年啦飞驰", "毒", "通稿2003", "长安乱", "就这么漂来漂去", "一座城池","光荣日","杂的文","他的国","草","可爱的洪水猛兽","1988：我想和这个世界谈谈","我所理解的生活","告白与告别"]
    private let tabCellId = "TabCell"
    
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
        titleButton = UIBarButtonItem(title:"",style: UIBarButtonItem.Style.plain,target:self,action:#selector(refreshAll))
        titleButton?.tintColor = .gray
        self.navigationItem.rightBarButtonItem = titleButton
        
        view.backgroundColor = UIColor(lightColor: .white, darkColor: .black)
        
        view.addSubview(tableView)
        
        // 设置横向滚动的 tab 布局
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = 5
        layout.minimumLineSpacing = 5
        layout.sectionInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        
        // 创建 CollectionView
        tabCollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        tabCollectionView.backgroundColor = .clear
        tabCollectionView.showsHorizontalScrollIndicator = false
        tabCollectionView.delegate = self
        tabCollectionView.dataSource = self
        tabCollectionView.register(CategoryTabCell.self, forCellWithReuseIdentifier: tabCellId)
        view.addSubview(tabCollectionView)
        
        // 设置约束
        tabCollectionView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.left.right.equalToSuperview()
            make.height.equalTo(44)
        }
        
        // 更新 tableView 的约束
        tableView.snp.makeConstraints{ make in
            make.top.equalTo(tabCollectionView.snp.bottom)
            make.left.right.bottom.equalToSuperview()
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
        
//        initTitleView()
//        sidebar = DCSidebar(sideView: view)
//        sidebar?.showAnimationsTime = 0.2
//        sidebar?.hideAnimationsTime = 0.2
        
        present = OnePresent(navigation: self)
        present?.getOneData()
        showLoading()
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
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        print("viewWillTransition--OneViewController")
    }
    
    // 标题栏
    func initTitleView(){
        let toolDayView = UIView(frame: CGRect(x: 0, y: statusBarHeight, width: self.view.frame.width, height: 44))
        self.view.addSubview(toolDayView)
        
        toolDayView.addSubview(labelTimeDay)
        toolDayView.addSubview(labelTimeYearMon)
//        toolView.addSubview(labelAbout)
        
        toolDayView.snp.makeConstraints { make in
//            make.right.equalTo(self.navigationItem.titleView!.snp.right)
            make.top.equalTo(Screen.statusBarHeight())
            make.left.right.equalToSuperview()
            make.width.equalTo(Screen.width)
            make.height.equalTo(44)
        }
        
        // 使用时需要一个Superview
        labelTimeDay.snp.makeConstraints { make in
            make.right.equalTo(labelTimeYearMon.snp.left).offset(-10)
            make.bottom.equalTo(labelTimeYearMon.snp.bottom).offset(-8)
        }
        labelTimeYearMon.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.right.equalToSuperview().offset(-15)
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
        
        stopLoading()
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
                    titleButton?.title = "\(times![1])月\(times![2])日"
                }
            }
        }
        if (bean != nil && bean!.data != nil && bean!.data!.content_list != nil) {
            switch present?.num {
            case 0:
                list  = bean!.data!.content_list
                self.tableView.reloadData()
            default:
                if list == nil {
                    list = bean!.data!.content_list
                    self.tableView.reloadData()
                    return
                }
                list?.insert(contentsOf: bean!.data!.content_list!, at: 0)
                // 在第row行插入
                let indexPath1:IndexPath = IndexPath.init(row: 0, section: 0)
                tableView.beginUpdates()
                tableView.insertRows(at: [indexPath1], with: .fade)
                tableView.endUpdates()
            }
            
        } else if present!.num == 0{
            // 只有第一页才显示错误页面
            tableView.isHidden = true
            btNoNet = UIButton(frame: viewBounds())
            btNoNet!.setTitle("请检查网络，点击重试", for: .normal)
            // 设置文字大小
            btNoNet!.titleLabel?.font = UIFont.systemFont(ofSize: 14)
            btNoNet!.setTitleColor(UIColor(lightColor: .black, darkColor: .white), for: .normal)
            btNoNet!.addTarget(self, action: #selector(reLoad), for: .touchUpInside)
            view.addSubview(btNoNet!)
            btNoNet!.snp.remakeConstraints { make in
                make.left.right.top.bottom.equalToSuperview()
            }
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
        // ��里的100是像素，不是文字对应的高度要将高度转为像素
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

extension OneViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return tabs.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: tabCellId, for: indexPath) as! CategoryTabCell
        cell.configure(with: tabs[indexPath.item])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let title = tabs[indexPath.item]
        // 计算文字宽度
        let font = indexPath.item == selectedTabIndex ? 
            UIFont.boldSystemFont(ofSize: 16) : 
            UIFont.systemFont(ofSize: 15)
        let width = (title as NSString).boundingRect(
            with: CGSize(width: CGFloat.greatestFiniteMagnitude, height: 44),
            options: .usesLineFragmentOrigin,
            attributes: [.font: font],
            context: nil
        ).width
        
        // 给文字左右加上一些边距
        return CGSize(width: width + 20, height: 44)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedTabIndex = indexPath.item
        
        // 获取选中cell的布局属性
        guard let attributes = collectionView.layoutAttributesForItem(at: indexPath) else { return }
        let cellFrame = attributes.frame
        
        // 计算目标位置，使选中的 cell 位于中间
        let collectionViewCenter = collectionView.bounds.width / 2
        let targetOffset = cellFrame.midX - collectionViewCenter
        
        // 确保不会滚动超出范围
        let maxOffset = collectionView.contentSize.width - collectionView.bounds.width
        let finalOffsetX = max(0, min(targetOffset, maxOffset))
        
        // 平滑滚动到目标位置
        collectionView.setContentOffset(CGPoint(x: finalOffsetX, y: 0), animated: true)
        
        // 这里可以添加切换内容的逻辑
        // present?.switchTab(to: indexPath.item)
    }
}
