//
//  OneViewController.swift
//  quote
//
//  Created by 景彬 on 2022/5/31.
//  Copyright © 2022 景彬. All rights reserved.
//

import UIKit
import MJRefresh


class OneViewController: UIViewController, OneNavigation {
    
    // 数据
    var list:[OneContentListBean]?
    // P层
    var present:OnePresent?
    // 重试按钮
    var btNoNet:UIButton?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.addSubview(tableView)
        
        // 隐藏导航栏(标题栏)
        navigationController?.navigationBar.isHidden = true
//        navigationItem.title = "一个"
        view.backgroundColor = UIColor(lightThemeColor: .white, darkThemeColor: .black)
        
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
        
        present = OnePresent(navigation: self)
        present?.getOneData()
    }
    
    // 标题栏
    func initTitleView(){
        let toolView = UIView(frame: CGRect(x: 0, y: statusBarHeight, width: self.view.frame.width, height: 44))
//        toolView.backgroundColor = UIColor.white
        self.view.addSubview(toolView)
        
        toolView.addSubview(labelTimeDay)
        toolView.addSubview(labelTimeYearMon)
        toolView.addSubview(labelAbout)
        
        // 使用时需要一个Superview
        labelTimeDay.snp.makeConstraints { make in
            make.left.equalTo(15)
            make.height.equalTo(44)
            // 垂直居中
            make.centerY.equalToSuperview()
        }
        labelTimeYearMon.snp.makeConstraints { make in
            make.left.equalTo(labelTimeDay.snp.right).offset(10)
            make.bottom.equalTo(labelTimeDay.snp.bottom).offset(-8)
        }
        labelAbout.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.right.equalTo(-15)
//            make.width.equalTo(54)
            make.height.equalTo(44)
        }
    }
    
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
    
    func onDataSuccess(bean: OneBean?) {
        
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
            let vc = WebViewViewController()
            vc.url = bean.share_url
            vc.titleOut = bean.title ?? "loading"
            navigationController?.pushViewController(vc, animated: true)
        }
    }
}
