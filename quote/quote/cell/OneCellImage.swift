//
//  oneCellImage.swift
//  quote
//
//  Created by 景彬 on 2022/5/4.
//  Copyright © 2022 景彬. All rights reserved.
//

import MagazineLayout
import UIKit
import SnapKit
import SDWebImage


class OneCellImage: MagazineLayoutCollectionViewCell {

  // MARK: Lifecycle
    private let label: UILabel
    private let subLabel: UILabel
//    private let imageView: SDWebImage

  override init(frame: CGRect) {
    
    label = UILabel(frame: .zero)
    subLabel = UILabel(frame: .zero)
//    imageView = SDWebImage(frame: .zero)

    super.init(frame: frame)

    
    
    label.font = UIFont.systemFont(ofSize: 24)
    label.textColor = .white
    label.numberOfLines = 0
    
    subLabel.font = UIFont.systemFont(ofSize: 20)
    subLabel.textColor = .white
    subLabel.numberOfLines = 0
    
    contentView.addSubview(label)
    contentView.addSubview(subLabel)
    
    label.snp.makeConstraints { (make) in
//        make.width.equalTo(ViewUtil.getScreenWidth())         // 宽为100
        make.left.top.equalTo(15)
        make.right.equalTo(-15)
        
//        make.height.equalTo(30)        // 高为100
//        make.center.equalTo(view)       // 位于当前视图的中心
    }
    
    subLabel.snp.makeConstraints { (make) in

        // 让顶部距离view1的底部为10的距离
        make.top.equalTo(label.snp.bottom).offset(10)
        make.left.equalTo(15)
        make.right.equalTo(-15)
        
//        make.rightMargin.equalTo(55)
        
        
//        make.bottom.equalTo(label)
    //        make.width.equalTo(ViewUtil.getScreenWidth())         // 宽为100
//            make.left.right.top.equalTo(15)
    //        make.height.equalTo(30)        // 高为100
    //        make.center.equalTo(view)       // 位于当前视图的中心
        }
//    let image = UIImageView()
    

//    label.translatesAutoresizingMaskIntoConstraints = false
//    NSLayoutConstraint.activate([
//      label.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 4),
//      label.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -4),
//      label.topAnchor.constraint(equalTo: contentView.topAnchor),
//      label.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
//    ])
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  // MARK: Internal

  override func prepareForReuse() {
    super.prepareForReuse()

    label.text = nil
    contentView.backgroundColor = nil
  }

  func set(_ itemInfo: ItemOneBean) {
    label.text = itemInfo.title
    subLabel.text = itemInfo.forward
    contentView.backgroundColor = UIColor.black
    
//    imageView.sd_setImage(with: URL(string: itemInfo.img_url!), placeholderImage: UIImage(named: "app_lauch.jpg"))
    
  }

  // MARK: Private

  

}

