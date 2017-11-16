//
//  ChecklistItem.swift
//  Checklists
//
//  Created by Marc SUN on 11/15/17.
//  Copyright © 2017 SUN. All rights reserved.
//

import Foundation

//声明继承NSObject，可以提供Swift对象所没有的大量有用的基础功能（如对象比较等）
class ChecklistItem: NSObject, NSCoding {
    
    var text = ""
    var checked = false
    
    override init() {
        super.init()
    }
    
    //好的面向对象设计原则是应该尽可能地让每个对象自己去改变自己的状态
    func toggleChecked() {
        checked = !checked
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(text, forKey: "Text")
        aCoder.encode(checked, forKey: "Checked")
    }
    
    required init?(coder aDecoder: NSCoder) {
        text = aDecoder.decodeObject(forKey: "Text") as! String
        checked = aDecoder.decodeBool(forKey: "Checked")
        super.init()
    }
}
