//
//  OneViewController.swift
//  quote
//
//  Created by 景彬 on 2022/5/31.
//  Copyright © 2022 景彬. All rights reserved.
//

import UIKit


class OneViewController: UIViewController, OneNavigation {
    
    
    var  list :[OneContentListBean]?
    var present:OnePresent?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.addSubview(tableView)
        
        navigationController?.navigationBar.isHidden = true
//        navigationItem.title = "一个"
        view.backgroundColor = UIColor(lightThemeColor: .white, darkThemeColor: .black)
        
        initTitleView()
        // Do any additional setup after loading the view.
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
            make.right.equalToSuperview()
            make.width.equalTo(54)
            make.height.equalTo(44)
        }
    }
    
    lazy var labelTimeDay: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(lightThemeColor: .black, darkThemeColor: .white)
        label.font = UIFont(name: "PingFangSC-Medium", size: 28)
//        label.font = .systemFont(ofSize: 25, weight: .medium)
//        label.text = "03"
        label.textAlignment = .center
        return label
    }()
    
    lazy var labelTimeYearMon: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(lightThemeColor: .black, darkThemeColor: .white)
//        label.text = "07 . 2022"
        label.font = UIFont(name: "PingFangSC-Medium", size: 15)
//        label.font = UIFont.systemFont(ofSize: 13)
        label.textAlignment = .center
        return label
    }()
    
    lazy var labelAbout: UIButton = {
        // 添加前进按钮
        let bt2 = UIButton()
        bt2.setTitle("关于", for: .normal)
        // 设置文字大小
        bt2.titleLabel?.font = UIFont.systemFont(ofSize: 13)
        bt2.setTitleColor(UIColor(lightThemeColor: .gray, darkThemeColor: .white), for: .normal)
        bt2.addTarget(self, action: #selector(openAbout), for: .touchUpInside)
        return bt2;
    }()
    
    // 点击关于
    @objc func openAbout(){
        let vc = WebViewViewController()
        vc.url = "https://github.com/youlookwhat"
        vc.titleOut = "youlookwhat"
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func onDataSuccess(bean: OneBean?) {
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
            list  = bean!.data!.content_list
            self.tableView.reloadData()
        }
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
        tableView.register(BPTopicListCell.self, forCellReuseIdentifier: "CellIdentifier")
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

        let cell = tableView.dequeueReusableCell(withIdentifier: "CellIdentifier", for: indexPath) as! BPTopicListCell

        // 没有选中的样式，一般都没有
        cell.selectionStyle = .none
        
        let topic = list?[indexPath.row]
        cell.model = topic
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let bean = list?[indexPath.row]
        guard let bean = bean else { return }
        
        if (bean.words_info != nil && bean.words_info != "") {
            
        } else {
            let vc = WebViewViewController()
            vc.url = bean.share_url
            vc.titleOut = bean.title ?? ""
            navigationController?.pushViewController(vc, animated: true)
        }
    }
}

public var didSelectTopic: (([AnyHashable: Any]?, Int) -> Void)?
//fileprivate var list = [BPMomentsTopicModel]()

class BPTopicListCell: UITableViewCell {
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        //这里生成后就不会变了
        // 阴影
//        contentView.layer.addSublayer(shadowLayer)
        contentView.addSubview(iconImageView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(desLabel)
        contentView.addSubview(tagLabel)
        contentView.addSubview(lineView)
    }
    
    public var model: OneContentListBean? {
        didSet {
            guard let model = model else { return }
            
            // 标题   第一个是2行话的那个
//            titleLabel.text =  (model.forward ?? "未知")
            
            // 图片下方的第二标题
//                titleLabel.numberOfLines = 2
            //通过富文本来设置行间距
            let paraph = NSMutableParagraphStyle()
            //将行间距设置为28
            paraph.lineSpacing = 5
            //样式属性集合
            let attributes = [NSAttributedString.Key.font:UIFont.systemFont(ofSize: 15),
                              NSAttributedString.Key.paragraphStyle: paraph]
            titleLabel.attributedText = NSAttributedString(string: (model.forward ?? "未知"), attributes: attributes)
            
            
            // 图片
            iconImageView.sd_setImage(with: URL(string: model.img_url ?? ""), placeholderImage: BannerImagePlaceholder)

            // 标题  第一个是最后一行的作者：严明
            desLabel.text = (model.words_info ?? "未知")
            // 标签  第一个是：摄影|jeff...
            let subtitle = "\((model.title) ?? "未知") | \(model.pic_info ?? "未知")"
            tagLabel.text = subtitle
            
            // 这里每次绘制cell都会执行。但是切换深色模式不会走这里？
//            shadowLayer.backgroundColor = UIColor(lightThemeColor: .white, darkThemeColor: .black).cgColor
            
            
            if (model.words_info != nil && model.words_info != "") {
//                shadowLayer.isHidden = false
                lineView.isHidden = true
                // 是第一个
                // 图片 使用 remakeConstraints ，如果使用makeConstraints可能会布局异常
                iconImageView.snp.remakeConstraints { make in
                    make.top.equalTo(10)
                    make.left.equalTo(15)
                    make.right.equalTo(-15)
                    // 这个属性是上下居中
        //            make.centerY.equalToSuperview()
                    make.height.equalTo(Int(Screen.width * (1175/2262.0)))
                    make.width.equalTo(Screen.width)
                }
                
                // 标签 摄影|jeff...
                tagLabel.snp.remakeConstraints { make in
                    // 在iconImageView下方，且距离10
                    make.top.equalTo(iconImageView.snp.bottom).offset(10)
                    // 水平居中
                    make.centerX.equalToSuperview()
                    // 高度
                    make.height.equalTo(15)
                }
                
                titleLabel.snp.remakeConstraints { make in
                    // 在iconImageView下方，且距离10
                    make.top.equalTo(tagLabel.snp.bottom).offset(20)
                    make.left.equalTo(40)
                    make.right.equalTo(-40)
                    // 如果是自适应则不要设置固定高度 make.height.equalTo(45)
                    // 水平居中
                    make.centerX.equalToSuperview()
                }
                
                desLabel.font = UIFont.systemFont(ofSize: 13)
                desLabel.textColor = UIColor(lightThemeColor: .gray, darkThemeColor: .gray)
                // 第三行标题
                desLabel.snp.remakeConstraints { make in
                    make.top.equalTo(titleLabel.snp.bottom).offset(20)
                    // 自适应高度的话，最后一个item需要bottom
                    make.bottom.equalTo(-10)
                    // 水平居中
                    make.centerX.equalToSuperview()
                    // 高度
                    make.height.equalTo(15)
                }
                
                
            } else {
                lineView.isHidden = false
                lineView.snp.remakeConstraints{ make in
                    make.top.equalTo(10)
//                    make.left.equalTo(10)
//                    make.right.equalTo(10)
                    make.width.equalTo(Screen.width)
                    make.height.equalTo(1)
                }
                
//                shadowLayer.isHidden = true
                // 没有words_info，不是第一个
                // 标题
                desLabel.textColor = UIColor(lightThemeColor: .black, darkThemeColor: .white)
                // 全粗
//                desLabel.font = .boldSystemFont(ofSize: 18)
                // 中等粗
                desLabel.font = .systemFont(ofSize: 18, weight: .medium)
                desLabel.text = model.title ?? "未知"
                
                // 第三行标题
                desLabel.snp.remakeConstraints { make in
                    make.top.equalTo(lineView.snp.bottom).offset(30)
                    make.left.equalTo(15)
                    make.right.equalTo(-15)
                    // 水平居中 make.centerX.equalToSuperview()
                    // 高度
//                    make.height.equalTo(18)
                }
                
                // 作者
                tagLabel.text = "文 / \(model.author?.user_name ?? "未知")"
                // 居左对齐
                tagLabel.textAlignment = .left
                tagLabel.snp.remakeConstraints { make in
                    // 在desLabel下方，且距离8
                    make.top.equalTo(desLabel.snp.bottom).offset(8)
                    make.left.equalTo(15)
                    make.right.equalTo(-15)
                    // 高度
                    make.height.equalTo(15)
                }
                
                // 图片下方的第二标题
                titleLabel.snp.remakeConstraints { make in
                    make.top.equalTo(tagLabel.snp.bottom).offset(14)
                    make.left.equalTo(15)
                    make.right.equalTo(-15)
                    // 水平居中
//                    make.centerX.equalToSuperview()
                }
                
                // 图片
                iconImageView.snp.remakeConstraints { make in
                    make.top.equalTo(titleLabel.snp.bottom).offset(10)
                    make.bottom.equalTo(-10)
                    make.left.equalTo(15)
                    make.right.equalTo(-15)
                    make.height.equalTo(Int(Screen.width * (1175/2262.0)))
                    make.width.equalTo(Screen.width)
                }
                
            }
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
   
    lazy var lineView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.lightGray
        view.alpha = 0.1
        return view
    }()
    
    lazy var iconImageView: UIImageView = {
        let view = UIImageView()
        view.layer.masksToBounds = true
        view.layer.cornerRadius = 8
        return view
    }()
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        // 自适应高度添加
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
//        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 15)
//        label.font = .mediumSystemFont(ofSize: 15)
        return label
    }()
    
    lazy var desLabel: UILabel = {
        let label = UILabel()
//        label.textColor = .gray
//        label.textColor = UIColor(lightThemeColor: .black, darkThemeColor: .white)
        label.font = UIFont.systemFont(ofSize: 13)
//        label.font = .mediumSystemFont(ofSize: 12)
        return label
    }()
    
    lazy var tagLabel: UILabel = {
        let label = UILabel()
        label.textColor = .gray
        label.font = UIFont.systemFont(ofSize: 13)
//        label.font = .mediumSystemFont(ofSize: 12)
        label.text = ""
        label.clipsToBounds = true
//        label.layer.cornerRadius = 4
        label.textAlignment = .center
        return label
    }()
    
    /// 阴影
    lazy var shadowLayer: CALayer = {
        let bgLayer1 = CALayer()
        bgLayer1.frame = CGRect(x: 15, y: 10, width: kScreenWidth - 30, height: Screen.width * (1175/2262.0) + 150.0)
        // 背景，去掉后看起来没有阴影了
        bgLayer1.backgroundColor = UIColor(lightThemeColor: .white, darkThemeColor: .black).cgColor
//        bgLayer1.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1).cgColor
        bgLayer1.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.08).cgColor
        bgLayer1.shadowOffset = CGSize(width: 0, height: 0)
        bgLayer1.shadowOpacity = 1
        bgLayer1.shadowRadius = 3
        bgLayer1.cornerRadius = 8
        bgLayer1.shadowPath = CGPath(roundedRect: bgLayer1.bounds, cornerWidth: 4, cornerHeight: 4, transform: nil)
        return bgLayer1
    }()
}

func setShadow(view:UIView,offset:CGSize,
               opacity:Float,radius:CGFloat) {
    //设置阴影颜色
    view.layer.shadowColor = UIColor.lightGray.cgColor
    //设置透明度
    view.layer.shadowOpacity = opacity
    //设置阴影半径
    view.layer.shadowRadius = radius
    //设置阴影偏移量
    view.layer.shadowOffset = offset
}


