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

class OneCellImage: MagazineLayoutCollectionViewCell {

  // MARK: Lifecycle

  override init(frame: CGRect) {
    
    label = UILabel(frame: .zero)

    super.init(frame: frame)

    
    
    label.font = UIFont.systemFont(ofSize: 24)
    label.textColor = .white
    label.numberOfLines = 0
    contentView.addSubview(label)
    
    label.snp.makeConstraints { (make) in
//        make.width.equalTo(ViewUtil.getScreenWidth())         // 宽为100
        make.left.right.top.equalTo(15)
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
    contentView.backgroundColor = UIColor.black
  }

  // MARK: Private

  private let label: UILabel

}

