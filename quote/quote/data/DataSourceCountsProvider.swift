//
//  DataSourceCountsProvider.swift
//  quote
//
//  Created by 景彬 on 2022/5/7.
//  Copyright © 2022 景彬. All rights reserved.
//

import UIKit

protocol DataSourceCountsProvider {

  var numberOfSections: Int { get }
  func numberOfItemsInSection(withIndex sectionIndex: Int) -> Int

}
