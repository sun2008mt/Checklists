//
//  Checklist.swift
//  Checklists
//
//  Created by Marc SUN on 11/17/17.
//  Copyright © 2017 SUN. All rights reserved.
//

import UIKit

class Checklist: NSObject {
    var name: String = ""
    
    init(_ name: String) {
        self.name = name
        super.init()
    }
}
