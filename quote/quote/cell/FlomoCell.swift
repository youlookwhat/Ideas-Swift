//
//  FlomoCell.swift
//  quote
//
//  Created by 景彬 on 2022/7/21.
//  Copyright © 2022 景彬. All rights reserved.
//

import UIKit

class FlomoCell : UITableViewCell {
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.backgroundColor = UIColor(lightThemeColor: UIColor.colorF3F3F3, darkThemeColor: .black)
        
        //这里生成后就不会变了
        // 阴影
//        contentView.layer.addSublayer(shadowLayer)
        contentView.addSubview(titleLabel)
        contentView.addSubview(desLabel)
//        contentView.addSubview(tagLabel)
    }
    
    public var model: OneContentListBean? {
        didSet {
            guard let model = model else { return }
            
            // 多行的黑色文本
            //通过富文本来设置行间距
            let paraph = NSMutableParagraphStyle()
            //将行间距设置为28
            paraph.lineSpacing = 5
            //样式属性集合
            let attributes = [NSAttributedString.Key.font:UIFont.systemFont(ofSize: 15),
                              NSAttributedString.Key.paragraphStyle: paraph]
            titleLabel.attributedText = NSAttributedString(string: (model.forward ?? "未知"), attributes: attributes)

            desLabel.text = TimeUtil.getDateFormatString(timeStamp: TimeUtil.getCurrentTimeStamp())
            
            
            desLabel.snp.makeConstraints{ make in
                make.left.top.equalTo(15)
            }
            titleLabel.snp.makeConstraints{ make in
                make.top.equalTo(desLabel.snp.bottom).offset(15)
                make.left.equalTo(desLabel)
                make.right.equalTo(-10)
                make.bottom.equalToSuperview().offset(-10)
            }
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        // 自适应高度添加
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.font = UIFont.systemFont(ofSize: 17)
        return label
    }()
    
    lazy var desLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.textColor = UIColor(lightThemeColor: .gray, darkThemeColor: .white)
        label.font = UIFont.systemFont(ofSize: 12)
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
