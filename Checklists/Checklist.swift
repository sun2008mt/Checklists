//
//  Checklist.swift
//  Checklists
//
//  Created by Marc SUN on 11/17/17.
//  Copyright © 2017 SUN. All rights reserved.
//

import UIKit

class Checklist: NSObject, NSCoding {
    var name: String = ""
    var items = [ChecklistItem]()
    
    init(_ name: String) {
        self.name = name
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        name = aDecoder.decodeObject(forKey: "Name") as! String
        items = aDecoder.decodeObject(forKey: "Items") as! [ChecklistItem]
        super.init()
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(name, forKey: "Name")
        aCoder.encode(items, forKey: "Items")
    }
}
