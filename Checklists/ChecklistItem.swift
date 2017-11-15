//
//  ChecklistItem.swift
//  Checklists
//
//  Created by Marc SUN on 11/15/17.
//  Copyright © 2017 SUN. All rights reserved.
//

import Foundation

class ChecklistItem {
    var text = ""
    var checked = false
    
    //好的面向对象设计原则是应该尽可能地让每个对象自己去改变自己的状态
    func toggleChecked() {
        checked = !checked
    }
}
