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
        
        // Do any additional setup after loading the view.
        present = OnePresent(navigation: self)
        present?.getOneData()
    }
    
    func onDataSuccess(bean: OneBean?) {
        
        if (bean != nil && bean!.data != nil && bean!.data!.content_list != nil) {
            list  = bean!.data!.content_list
        }
    }

    lazy var tableView: UITableView = {
//        let tableView = UITableView(frame: viewBounds(), style: .plain)
        let tableView = UITableView(frame: self.view.frame, style: .plain)
//        tableView.backgroundColor = .line
        tableView.rowHeight = 94
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorColor = UIColor.black
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 83, bottom: 0, right: 15)
        tableView.tableFooterView = UIView()
        tableView.register(BPTopicListCell.self, forCellReuseIdentifier: "dd")
//        tableView.mj_footer = MJDIYFooter(refreshingBlock: {
//            self.requestData()
//        })
        return tableView
    }()

}


extension OneViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        list!.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(with: BPTopicListCell.self) as! BPTopicListCell
//        cell.selectionStyle = .none
        let topic = list?[indexPath.row]
        cell.model = topic
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let topic = list?[indexPath.row]
        if let didSelectTopic = didSelectTopic {
            let dic = topic?.yy_modelToJSONObject() as? [AnyHashable: Any]
            didSelectTopic(dic, indexPath.row)
        } else if let id = topic?.id {
            let vc = BPTopicViewController()
            vc.id = id
            navigationController?.pushViewController(vc, animated: true)
        }
    }
}

public var didSelectTopic: (([AnyHashable: Any]?, Int) -> Void)?
//fileprivate var list = [BPMomentsTopicModel]()

class BPTopicListCell: UITableViewCell {
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(iconImageView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(desLabel)
        contentView.addSubview(tagLabel)
        
        iconImageView.snp.makeConstraints { make in
            make.left.equalTo(15)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(54)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.left.equalTo(iconImageView.snp.right).offset(14)
            make.top.equalTo(iconImageView.snp.top).offset(5)
            make.height.equalTo(15)
        }
        
        desLabel.snp.makeConstraints { make in
            make.left.equalTo(tagLabel.snp.right).offset(4)
            make.top.equalTo(titleLabel.snp.bottom).offset(16)
        }
        
        tagLabel.snp.makeConstraints { make in
            make.width.height.equalTo(14)
            make.left.equalTo(titleLabel.snp.left)
            make.centerY.equalTo(desLabel)
        }
    }
    
    public var model: OneContentListBean? {
        didSet {
            guard let model = model else { return }
            titleLabel.text = "#" + (model.title ?? "")
            
            iconImageView.sd_setImage(with: URL(string: model.img_url ?? ""), placeholderImage: GoodsImagePlaceholder)
//            let participantsNum = model.participantsNum
//            let hitNum = model.hitNum
            var desc = ""
//            if participantsNum > 0 {
//                desc += (Utils.returnHitNum(participantsNum)) + "人参与"
//            }
//            if participantsNum > 0, hitNum > 0 {
//                desc += " | "
//            }
//            if hitNum > 0 {
//                desc += (Utils.returnHitNum(hitNum)) + "浏览量"
//            }
            desLabel.text = desc
            
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
        label.textColor = .color50
        label.font = .mediumSystemFont(ofSize: 15)
        return label
    }()
    
    lazy var desLabel: UILabel = {
        let label = UILabel()
        label.textColor = .color99
        label.font = .mediumSystemFont(ofSize: 12)
        return label
    }()
    
    lazy var tagLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = .mediumSystemFont(ofSize: 12)
        label.text = "热"
        label.backgroundColor = UIColor(rgb: 0xFF666F)
        label.clipsToBounds = true
        label.layer.cornerRadius = 4
        label.textAlignment = .center
        return label
    }()
}
