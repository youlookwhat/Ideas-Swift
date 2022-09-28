//
//  OneNavigation.swift
//  quote
//
//  Created by 景彬 on 2022/5/1.
//  Copyright © 2022 景彬. All rights reserved.
//

import UIKit
import RealmSwift

protocol IdeasNavigation {

    func onDataSuccess(bean : [NoteBean]?)
    
    func sendData()
}
