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
        
        uiView.addSubview(titleLabel)
        uiView.addSubview(desLabel)
//        uiView.addSubview(moreImage)
        contentView.addSubview(uiView)
        
        uiView.snp.makeConstraints{ make in
            make.left.equalTo(10)
            make.right.equalTo(-10)
            make.top.equalTo(5)
            make.bottom.equalTo(-5)
        }
    }
    
    public var model: NoteBean? {
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
            titleLabel.attributedText = NSAttributedString(string: (model.title ?? "未知"), attributes: attributes)

            desLabel.text = TimeUtil.getDateFormatString(timeStamp: model.creatTime)
            
            
            desLabel.snp.makeConstraints{ make in
                make.left.top.equalTo(15)
            }
            titleLabel.snp.makeConstraints{ make in
                make.top.equalTo(desLabel.snp.bottom).offset(15)
                make.left.equalTo(desLabel)
                make.right.equalTo(-10)
                make.bottom.equalToSuperview().offset(-10)
            }
//            moreImage.snp.makeConstraints{ make in
//                make.width.height.equalTo(36)
//                make.right.equalTo(-5)
//            }
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    lazy var uiView: UIView = {
        let label = UIView()
        label.layer.cornerRadius = 4
        label.backgroundColor = UIColor(lightThemeColor: .white, darkThemeColor: UIColor.darkGray)
        return label
    }()
    
    
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
    
//    lazy var moreImage: UIImageView = {
//        let image = UIImage(named: "icon_more_flomo")?.withRenderingMode(.alwaysOriginal)
//        var imageView:UIImageView = UIImageView(image: image)
//        imageView.contentMode = .scaleAspectFit
        // 给图片加点击事件
//        let singleTapGesture = UITapGestureRecognizer(target: self, action: #selector(send))
//        imageView.addGestureRecognizer(singleTapGesture)
//        imageView.isUserInteractionEnabled = true
//        return imageView
//    }()

}
