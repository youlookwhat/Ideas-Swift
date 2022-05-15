//
//  ViewController.swift
//  quote
//
//  Created by 景彬 on 2022/4/26.
//  Copyright © 2022 景彬. All rights reserved.
//

import UIKit
import MagazineLayout

class ViewController: UIViewController, OneNavigation {
    
    var present:OnePresent?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        
        navigationItem.title = "每日句子"
        view.backgroundColor = UIColor.white
        
        view.addSubview(collectionView)
        
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
          collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
          collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
          collectionView.topAnchor.constraint(equalTo: view.topAnchor),
          collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
        
        present = OnePresent(navigation: self)
        present?.getOneData()
    }

    var itemList = [ItemOneBean]()
    func onDataSuccess(bean: OneBean?) {
        if bean != nil {
            print(bean!.res==0)
            
            // 这里可以优化一下，直接赋值结构体content_list
            for item in bean!.data!.content_list!{
                let one = ItemOneBean()
                one.sizeMode = MagazineLayoutItemSizeMode(
                                widthMode: .fullWidth(respectsHorizontalInsets: true),
                                heightMode: .dynamic)
                one.author = item.author
                one.category = item.category
                one.forward = item.forward
                one.img_url = item.img_url
                one.title = item.title
                one.share_url = item.share_url
                one.words_info = item.words_info
                itemList.append(one)
            }
            loadData()
//            print(bean!.data!.content_list?[1].category)
        } else {
            // 无内容
        }
    }
    
    
    private func removeAllData() {
      collectionView.performBatchUpdates({
        for sectionIndex in (0..<dataSource.numberOfSections).reversed() {
          dataSource.removeSection(atSectionIndex: sectionIndex)
          collectionView.deleteSections(IndexSet(arrayLiteral: sectionIndex))
        }
      }, completion: nil)
    }
    
    func loadData() {
        
        removeAllData()

//        let section0 = SectionInfo(
//          headerInfo: HeaderInfo(
//            visibilityMode: .visible(heightMode: .dynamic, pinToVisibleBounds: true),
//            title: "Welcome!"),
//          itemInfos: [
//            ItemInfo(
//              sizeMode: MagazineLayoutItemSizeMode(
//                widthMode: .fullWidth(respectsHorizontalInsets: true),
//                heightMode: .dynamic),
//              text: "MagazineLayout lets you layout items in vertically scrolling grids and lists.",
//              color: Colors.red),
//            ItemInfo(
//              sizeMode: MagazineLayoutItemSizeMode(
//                widthMode: .fullWidth(respectsHorizontalInsets: true),
//                heightMode: .dynamic),
//              text: "As you can see...",
//              color: Colors.red),
//            ItemInfo(
//              sizeMode: MagazineLayoutItemSizeMode(
//                widthMode: .halfWidth,
//                heightMode: .dynamic),
//              text: "items can be vertically self-sized",
//              color: Colors.orange),
//            ItemInfo(
//              sizeMode: MagazineLayoutItemSizeMode(
//                widthMode: .halfWidth,
//                heightMode: .dynamic),
//              text: "based on their contents.",
//              color: Colors.orange),
//            ItemInfo(
//              sizeMode: MagazineLayoutItemSizeMode(
//                widthMode: .halfWidth,
//                heightMode: .dynamic),
//              text: "Widths are determined",
//              color: Colors.green),
//            ItemInfo(
//              sizeMode: MagazineLayoutItemSizeMode(
//                widthMode: .halfWidth,
//                heightMode: .dynamic),
//              text: "by item width modes",
//              color: Colors.green),
//            ItemInfo(
//              sizeMode: MagazineLayoutItemSizeMode(
//                widthMode: .thirdWidth,
//                heightMode: .dynamic),
//              text: "3 across",
//              color: Colors.green),
//            ItemInfo(
//              sizeMode: MagazineLayoutItemSizeMode(
//                widthMode: .thirdWidth,
//                heightMode: .dynamic),
//              text: "3 across",
//              color: Colors.green),
//            ItemInfo(
//              sizeMode: MagazineLayoutItemSizeMode(
//                widthMode: .thirdWidth,
//                heightMode: .dynamic),
//              text: "3 across",
//              color: Colors.green),
//            ItemInfo(
//              sizeMode: MagazineLayoutItemSizeMode(
//                widthMode: .fractionalWidth(divisor: 10),
//                heightMode: .dynamic),
//              text: "1",
//              color: Colors.blue),
//            ItemInfo(
//              sizeMode: MagazineLayoutItemSizeMode(
//                widthMode: .fractionalWidth(divisor: 10),
//                heightMode: .dynamic),
//              text: "0",
//              color: Colors.blue),
//            ItemInfo(
//              sizeMode: MagazineLayoutItemSizeMode(
//                widthMode: .fractionalWidth(divisor: 10),
//                heightMode: .dynamic),
//              text: " ",
//              color: Colors.blue),
//            ItemInfo(
//              sizeMode: MagazineLayoutItemSizeMode(
//                widthMode: .fractionalWidth(divisor: 10),
//                heightMode: .dynamic),
//              text: "a",
//              color: Colors.blue)
//          ],
//          footerInfo: FooterInfo(
//            visibilityMode: .hidden,
//            title: ""),
//          backgroundInfo: BackgroundInfo(visibilityMode: .hidden)
//        )
        
        let section0 = SectionInfoOne(
            itemInfos: itemList
        )
        
        collectionView.performBatchUpdates({
          dataSource.insert(section0, atSectionIndex: 0)
//          dataSource.insert(section0, atSectionIndex: 1)
//          dataSource.insert(section2, atSectionIndex: 2)

//          collectionView.insertSections(IndexSet(arrayLiteral: 0, 1, 2))
            collectionView.insertSections(IndexSet(arrayLiteral: 0))
        }, completion: nil)
    }
    
    private lazy var collectionView: UICollectionView = {
      let layout = MagazineLayout()
      let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
      collectionView.register(OneCellImage.self, forCellWithReuseIdentifier: OneCellImage.description())
//      collectionView.register(
//        Header.self,
//        forSupplementaryViewOfKind: MagazineLayout.SupplementaryViewKind.sectionHeader,
//        withReuseIdentifier: Header.description())
//      collectionView.register(
//        Footer.self,
//        forSupplementaryViewOfKind: MagazineLayout.SupplementaryViewKind.sectionFooter,
//        withReuseIdentifier: Footer.description())
//      collectionView.register(
//        Background.self,
//        forSupplementaryViewOfKind: MagazineLayout.SupplementaryViewKind.sectionBackground,
//        withReuseIdentifier: Background.description())
      collectionView.isPrefetchingEnabled = false
      collectionView.dataSource = dataSource
      collectionView.delegate = self
      collectionView.backgroundColor = .white
      collectionView.contentInsetAdjustmentBehavior = .always
      return collectionView
    }()

    private lazy var dataSource = DataSourceOne()

//struct Login: Encodable {
//    let email: String
//    let password: String
//}

}

// MARK: UICollectionViewDelegate
extension ViewController: UICollectionViewDelegate {

  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    collectionView.performBatchUpdates({
        print(itemList[indexPath.item].title)
//      if dataSource.numberOfItemsInSection(withIndex: indexPath.section) > 1 {
//        dataSource.removeItem(atItemIndex: indexPath.item, inSectionAtIndex: indexPath.section)
//        collectionView.deleteItems(at: [indexPath])
//      } else {
//        dataSource.removeSection(atSectionIndex: indexPath.section)
//        collectionView.deleteSections(IndexSet(integer: indexPath.section))
//      }
    }, completion: nil)
  }

}

extension ViewController: UICollectionViewDelegateMagazineLayout {

  func collectionView(
    _ collectionView: UICollectionView,
    layout collectionViewLayout: UICollectionViewLayout,
    sizeModeForItemAt indexPath: IndexPath)
    -> MagazineLayoutItemSizeMode
  {
    return dataSource.sectionInfos[indexPath.section].itemInfos[indexPath.item].sizeMode!
  }

  func collectionView(
    _ collectionView: UICollectionView,
    layout collectionViewLayout: UICollectionViewLayout,
    visibilityModeForHeaderInSectionAtIndex index: Int)
    -> MagazineLayoutHeaderVisibilityMode
  {
    return .hidden
  }

  func collectionView(
    _ collectionView: UICollectionView,
    layout collectionViewLayout: UICollectionViewLayout,
    visibilityModeForFooterInSectionAtIndex index: Int)
    -> MagazineLayoutFooterVisibilityMode
  {
    return .hidden
  }

  func collectionView(
    _ collectionView: UICollectionView,
    layout collectionViewLayout: UICollectionViewLayout,
    visibilityModeForBackgroundInSectionAtIndex index: Int)
    -> MagazineLayoutBackgroundVisibilityMode
  {
    return .hidden
  }

  func collectionView(
    _ collectionView: UICollectionView,
    layout collectionViewLayout: UICollectionViewLayout,
    horizontalSpacingForItemsInSectionAtIndex index: Int)
    -> CGFloat
  {
    return 12
  }

  func collectionView(
    _ collectionView: UICollectionView,
    layout collectionViewLayout: UICollectionViewLayout,
    verticalSpacingForElementsInSectionAtIndex index: Int)
    -> CGFloat
  {
    return 12
  }

  func collectionView(
    _ collectionView: UICollectionView,
    layout collectionViewLayout: UICollectionViewLayout,
    insetsForSectionAtIndex index: Int)
    -> UIEdgeInsets
  {
    return UIEdgeInsets(top: 24, left: 4, bottom: 24, right: 4)
  }

  func collectionView(
    _ collectionView: UICollectionView,
    layout collectionViewLayout: UICollectionViewLayout,
    insetsForItemsInSectionAtIndex index: Int)
    -> UIEdgeInsets
  {
    return UIEdgeInsets(top: 24, left: 4, bottom: 24, right: 4)
  }

  func collectionView(
    _ collectionView: UICollectionView,
    layout collectionViewLayout: UICollectionViewLayout,
    finalLayoutAttributesForRemovedItemAt indexPath: IndexPath,
    byModifying finalLayoutAttributes: UICollectionViewLayoutAttributes)
  {
    // Fade and drop out
    finalLayoutAttributes.alpha = 0
    finalLayoutAttributes.transform = .init(scaleX: 0.2, y: 0.2)
  }

}
