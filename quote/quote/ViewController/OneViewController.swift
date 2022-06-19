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
        
        navigationItem.title = "一个"
        view.backgroundColor = UIColor.white
        
        
        // Do any additional setup after loading the view.
        present = OnePresent(navigation: self)
        present?.getOneData()
    }
    
    func onDataSuccess(bean: OneBean?) {
        
        if (bean != nil && bean!.data != nil && bean!.data!.content_list != nil) {
            list  = bean!.data!.content_list
            self.tableView.reloadData()
        }
    }

    lazy var tableView: UITableView = {
        // viewBounds() 限制了tableView的宽高
        let tableView = UITableView(frame: viewBounds(), style: .plain)
//        let tableView = UITableView(frame: self.view.frame, style: .plain)
        tableView.backgroundColor = .white
        // 这里的100是像素，不是文字对应的高度，要将高度转为像素
        tableView.rowHeight = Screen.width * (1175/2262.0) + 150.0
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
//        let topic = list?[indexPath.row]
//        if let didSelectTopic = didSelectTopic {
//            let dic = topic?.yy_modelToJSONObject() as? [AnyHashable: Any]
//            didSelectTopic(dic, indexPath.row)
//        }
//        else if let id = topic?.id {
//            let vc = BPTopicViewController()
//            vc.id = id
//            navigationController?.pushViewController(vc, animated: true)
//        }
    }
}

public var didSelectTopic: (([AnyHashable: Any]?, Int) -> Void)?
//fileprivate var list = [BPMomentsTopicModel]()

class BPTopicListCell: UITableViewCell {
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
//        contentView.layer.addSublayer(shadowLayer)
        
        contentView.addSubview(iconImageView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(desLabel)
        contentView.addSubview(tagLabel)
        
        
        // 图片
//        iconImageView.snp.makeConstraints { make in
//            make.top.equalTo(10)
//            make.left.equalTo(15)
//            make.right.equalTo(-15)
//            // 这个属性是上下居中
////            make.centerY.equalToSuperview()
//            make.height.equalTo(Int(Screen.width * (1175/2262.0)))
//            make.width.equalTo(Screen.width)
//        }
//
//        // 标签 摄影|jeff...
//        tagLabel.snp.makeConstraints { make in
//
//            // 在iconImageView下方，且距离10
//            make.top.equalTo(iconImageView.snp.bottom).offset(10)
//            // 水平居中
//            make.centerX.equalToSuperview()
//            // 高度
//            make.height.equalTo(15)
//
//
//            // 高度
////            make.height.equalTo(15)
//            // 和标题一样的左边距
////            make.left.equalTo(titleLabel.snp.left)
//            // 以desLabel垂直居中对齐
////            make.centerY.equalTo(desLabel)
//        }
//
//        // 图片下方的第二标题
//        titleLabel.snp.makeConstraints { make in
////            make.left.equalTo(iconImageView.snp.right).offset(14)
//            // 在iconImageView下方，且距离10
//            make.top.equalTo(tagLabel.snp.bottom).offset(20)
//            make.left.equalTo(40)
//            make.right.equalTo(-40)
//            make.height.equalTo(45)
//            // 水平居中
//            make.centerX.equalToSuperview()
//        }
//
//        // 第三行标题
//        desLabel.snp.makeConstraints { make in
//
//            make.top.equalTo(titleLabel.snp.bottom).offset(20)
//            // 水平居中
//            make.centerX.equalToSuperview()
//            // 高度
//            make.height.equalTo(15)
//
//            // 在tagLabel左边，且距离4
////            make.left.equalTo(tagLabel.snp.right).offset(4)
//            // 在titleLabel的下方，且距离16
////            make.top.equalTo(titleLabel.snp.bottom).offset(16)
////            make.bottom.equalTo(-10)
//        }
        
        
    }
    
    public var model: OneContentListBean? {
        didSet {
            guard let model = model else { return }
            
            // 标题   第一个是2行话的那个
            titleLabel.text =  (model.forward ?? "未知")
            
            // 图片
            iconImageView.sd_setImage(with: URL(string: model.img_url ?? ""), placeholderImage: GoodsImagePlaceholder)

            // 标题  第一个是最后一行的作者：严明
            desLabel.text = (model.words_info ?? "未知")
            // 标签  第一个是：摄影|jeff...
            let subtitle = "\((model.title) ?? "未知") | \(model.pic_info ?? "未知")"
            tagLabel.text = subtitle
            
            
            if (model.words_info != nil && model.words_info != "") {
                // 是第一个
                // 图片
                iconImageView.snp.makeConstraints { make in
                    make.top.equalTo(10)
                    make.left.equalTo(15)
                    make.right.equalTo(-15)
                    // 这个属性是上下居中
        //            make.centerY.equalToSuperview()
                    make.height.equalTo(Int(Screen.width * (1175/2262.0)))
                    make.width.equalTo(Screen.width)
                }
                
                // 标签 摄影|jeff...
                tagLabel.snp.makeConstraints { make in
                    
                    // 在iconImageView下方，且距离10
                    make.top.equalTo(iconImageView.snp.bottom).offset(10)
                    // 水平居中
                    make.centerX.equalToSuperview()
                    // 高度
                    make.height.equalTo(15)
                }
                
                // 图片下方的第二标题
                titleLabel.snp.makeConstraints { make in
                    // 在iconImageView下方，且距离10
                    make.top.equalTo(tagLabel.snp.bottom).offset(20)
                    make.left.equalTo(40)
                    make.right.equalTo(-40)
                    make.height.equalTo(45)
                    // 水平居中
                    make.centerX.equalToSuperview()
                }
                
                // 第三行标题
                desLabel.snp.makeConstraints { make in
                    make.top.equalTo(titleLabel.snp.bottom).offset(20)
                    // 水平居中
                    make.centerX.equalToSuperview()
                    // 高度
                    make.height.equalTo(15)
                }
                
                
            } else {
                
                // 没有words_info，不是第一个
                // 标题
                desLabel.textColor = .black
                // 全粗
//                desLabel.font = .boldSystemFont(ofSize: 18)
                // 中等粗
                desLabel.font = .systemFont(ofSize: 18, weight: .medium)
                desLabel.text = model.title ?? "未知"
                
                // 第三行标题
                desLabel.snp.remakeConstraints { make in
                    make.top.equalTo(10)
                    make.left.equalTo(15)
                    make.right.equalTo(-15)
//                    make.top.equalTo(titleLabel.snp.bottom).offset(20)
                    // 水平居中
//                    make.centerX.equalToSuperview()
                    // 高度
                    make.height.equalTo(18)
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
                    make.height.equalTo(45)
                    // 水平居中
//                    make.centerX.equalToSuperview()
                }
                
                
                // 图片
                iconImageView.snp.remakeConstraints { make in
                    make.top.equalTo(titleLabel.snp.bottom).offset(10)
                    make.left.equalTo(15)
                    make.right.equalTo(-15)
                    // 这个属性是上下居中
        //            make.centerY.equalToSuperview()
                    make.height.equalTo(Int(Screen.width * (1175/2262.0)))
                    make.width.equalTo(Screen.width)
                }
                
            }
            
//            if model.topicTag == 0 {
//                tagLabel.snp.updateConstraints { make in
//                    make.width.height.equalTo(0)
//                }
//                desLabel.snp.updateConstraints { make in
//                    make.left.equalTo(tagLabel.snp.right).offset(0)
//                }
//            } else {
//                tagLabel.snp.updateConstraints { make in
//                    make.width.height.equalTo(16)
//                }
//                desLabel.snp.updateConstraints { make in
//                    make.left.equalTo(tagLabel.snp.right).offset(4)
//                }
//                if model.topicTag == 1 {
//                    tagLabel.text = "热"
//                    tagLabel.backgroundColor = UIColor(rgb: 0xFF666F)
//                } else if model.topicTag == 2 {
//                    tagLabel.text = "新"
//                    tagLabel.backgroundColor = UIColor(rgb: 0xF7A64A)
//                } else if model.topicTag == 3 {
//                    tagLabel.text = "爆"
//                    tagLabel.backgroundColor = UIColor(rgb: 0xB76EFF)
//                }
//            }
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    lazy var iconImageView: UIImageView = {
        let view = UIImageView()
        view.layer.masksToBounds = true
        view.layer.cornerRadius = 8
        return view
    }()
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 2
//        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 15)
//        label.textColor = .color50
//        label.font = .mediumSystemFont(ofSize: 15)
        return label
    }()
    
    lazy var desLabel: UILabel = {
        let label = UILabel()
        label.textColor = .gray
        label.font = UIFont.systemFont(ofSize: 13)
//        label.textColor = .color99
//        label.font = .mediumSystemFont(ofSize: 12)
        return label
    }()
    
    lazy var tagLabel: UILabel = {
        let label = UILabel()
        label.textColor = .gray
        label.font = UIFont.systemFont(ofSize: 13)
//        label.font = .mediumSystemFont(ofSize: 12)
        label.text = "热"
//        label.backgroundColor = UIColor(rgb: 0xFF666F)
        label.clipsToBounds = true
//        label.layer.cornerRadius = 4
        label.textAlignment = .center
        return label
    }()
    
    /// 阴影
    lazy var shadowLayer: CALayer = {
        let bgLayer1 = CALayer()
        bgLayer1.frame = CGRect(x: 15, y: 10, width: kScreenWidth - 30, height: Screen.width * (1175/2262.0) + 150.0)
        bgLayer1.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1).cgColor
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

