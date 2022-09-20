//
//  HomeCell.swift
//  quote
//
//  Created by 景彬 on 2022/7/10.
//  Copyright © 2022 景彬. All rights reserved.
//

import UIKit

/*
 * 主页的cell adapter
 */
class HomeListCell: UITableViewCell {

    // 图片的高度
    var imageHeight:Int = 0
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        imageHeight = Int((Screen.width-30) * (1175/2262.0))
        
        //这里生成后就不会变了
        // 阴影
//        contentView.layer.addSublayer(shadowLayer)
        contentView.addSubview(iconImageView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(desLabel)
        contentView.addSubview(tagLabel)
        contentView.addSubview(lineViewBottom)
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
            
            
            // 图片
            iconImageView.sd_setImage(with: URL(string: model.img_url ?? ""), placeholderImage: BannerImagePlaceholder)
            

            // One：第一个是最后一个作者名，其他的是标题
            // 词霸和扇贝：英文
            // 一言：作者和出处
            if model.typeContent==3 {
                var whoFrom = ""
                if (model.title == nil || model.title!.isEmpty) {
                    whoFrom = "《\((model.words_info) ?? "未知")》"
                } else {
                    whoFrom = "--- \(model.title ?? "")  《\((model.words_info) ?? "未知") 》"
                }
                desLabel.text = whoFrom
            } else{
                desLabel.text = (model.words_info ?? "未知")
            }
            
            
            //One：第一个是：摄影|jeff...，其他的是标题下的作者
            var subtitle = ""
            if (model.pic_info == nil || model.pic_info!.isEmpty) {
                subtitle = "\((model.title) ?? "未知")"
            } else {
                subtitle = "\((model.title) ?? "未知") | \(model.pic_info ?? "未知")"
            }
            tagLabel.text = subtitle
            
            // 这里每次绘制cell都会执行。但是切换深色模式不会走这里？
//            shadowLayer.backgroundColor = UIColor(lightThemeColor: .white, darkThemeColor: .black).cgColor
            
            
            if (model.words_info != nil && model.words_info != "") {
                // One的第一个cell，和其他类型的cell
                
                // 是除One所有的其他的类型
                if model.img_url==nil {
                    iconImageView.isHidden = true
                } else {
                    iconImageView.isHidden = false
                    // 图片 使用 remakeConstraints ，如果使用makeConstraints可能会布局异常
                    iconImageView.snp.remakeConstraints { make in
    //                    make.top.equalTo(lineView.snp.bottom).offset(10)
                        make.top.equalTo(15)
//                        make.top.equalToSuperview().offset(15)
                        make.left.equalTo(15)
                        make.right.equalTo(-15)
                        // 这个属性是上下居中
            //            make.centerY.equalToSuperview()
                        make.width.equalTo(Screen.width-30)
                        make.height.equalTo(imageHeight).priority(.high)
                    }
                    
                }
                if model.typeContent==nil {
                    // 一个 才显示
                    tagLabel.isHidden = false
                    // 标签 摄影|jeff...
                    tagLabel.snp.remakeConstraints { make in
                        // 在iconImageView下方，且距离10
                        make.top.equalTo(iconImageView.snp.bottom).offset(10)
                        // 水平居中
                        make.centerX.equalToSuperview()
                        // 高度
//                        make.height.equalTo(15)
                    }
                }else {
                    tagLabel.isHidden = true
                }
                titleLabel.snp.remakeConstraints { make in
                    if model.typeContent==0 || model.typeContent==nil {
                        // 一个
                        make.top.equalTo(tagLabel.snp.bottom).offset(20)
                        make.left.equalTo(40)
                        make.right.equalTo(-40)
                    }else{
                        if model.img_url==nil {
                            // 在iconImageView下方，且距离10
                            make.top.equalTo(15)
                            make.left.equalTo(15)
                            make.right.equalTo(-15)
                        }else{
                            // 在iconImageView下方，且距离10
                            make.top.equalTo(iconImageView.snp.bottom).offset(10)
                            make.left.equalTo(15)
                            make.right.equalTo(-15)
                        }
                    }
                    // 如果是自适应则不要设置固定高度 make.height.equalTo(45)
                    // 水平居中
                    make.centerX.equalToSuperview()
                }
                
                desLabel.font = UIFont.systemFont(ofSize: 13)
                desLabel.textColor = UIColor(lightThemeColor: .gray, darkThemeColor: .gray)
                // 第三行标题
                desLabel.snp.remakeConstraints { make in
                    if model.typeContent==0 || model.typeContent==nil {
                        // 一个
                        make.top.equalTo(titleLabel.snp.bottom).offset(20)
                        // 水平居中
                        make.centerX.equalToSuperview()
                    }else{
                        make.top.equalTo(titleLabel.snp.bottom).offset(8)
                        if model.img_url==nil {
                            // 是没有图的，在最靠右
                            make.right.equalTo(-15)
                        } else {
                            make.left.equalTo(15)
                            make.right.equalTo(-15)
                        }
                    }
                    
                    // 自适应高度的话，最后一个item需要bottom
//                    make.bottom.equalTo(-10)
                    // 高度
//                    make.height.equalTo(15)
                }
                
                lineViewBottom.snp.remakeConstraints{ make in
                    make.top.equalTo(desLabel.snp.bottom).offset(15)
                    // 自适应高度的话，最后一个item需要bottom
                    make.bottom.equalTo(0)
                    make.width.equalTo(Screen.width)
                    make.height.equalTo(1)
                }
                
                
            } else {
                tagLabel.isHidden = false
                iconImageView.isHidden = false

                // 标题
                desLabel.textColor = UIColor(lightThemeColor: .black, darkThemeColor: .white)
                // 全粗
//                desLabel.font = .boldSystemFont(ofSize: 18)
                // 中等粗
                desLabel.font = .systemFont(ofSize: 18, weight: .medium)
                desLabel.text = model.title ?? "未知"
                
                // 第三行标题
                desLabel.snp.remakeConstraints { make in
//                    make.top.equalTo(lineView.snp.bottom).offset(30)
                    make.top.equalTo(20)
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
//                    make.height.equalTo(15)
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
//                    make.bottom.equalTo(-10)
                    make.left.equalTo(15)
                    make.right.equalTo(-15)
                    make.width.equalTo(Screen.width-30)
                    // 设置高优先级，不然控制台会提示约束问题
                    make.height.equalTo(imageHeight).priority(.high)
                }
                // 最后的线
                lineViewBottom.snp.remakeConstraints{ make in
                    make.top.equalTo(iconImageView.snp.bottom).offset(15)
                    // 自适应高度的话，最后一个item需要bottom
                    make.bottom.equalTo(0)
                    make.width.equalTo(Screen.width)
                    make.height.equalTo(1)
                }
            }
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    lazy var lineViewBottom: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.lightGray
        view.alpha = 0.1
        return view
    }()
    
    lazy var iconImageView: UIImageView = {
        let view = UIImageView()
        view.layer.masksToBounds = true
        // 缩放模式，相当于centerCrop
        view.contentMode = .scaleAspectFill
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
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
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
