//
//  DataModel.swift
//  Checklists
//
//  Created by Marc SUN on 11/17/17.
//  Copyright © 2017 SUN. All rights reserved.
//

import Foundation

class DataModel {
    var lists = [Checklist]()
    
    init() {
        loadChecklists()
    }
    
    //IOS的app都被存储在一个封闭的环境中（沙盒），每个app都有自己的目录用于存储文件，而且决不允许从其他app的目录中读取文件；更新app后，Document目录不会受到影响
    func documentDirectory() -> URL {
        //获取app内Document路径
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
    func dataFilePath() -> URL {
        //获取文件存储路径
        return documentDirectory().appendingPathComponent("Checklists.plist")
    }
    
    func loadChecklists() {
        //添加数据项
        let path = dataFilePath()
        if let data = try?Data(contentsOf: path) {
            let unarchiver = NSKeyedUnarchiver(forReadingWith: data)
            lists = unarchiver.decodeObject(forKey: "Checklists") as! [Checklist]
            unarchiver.finishDecoding()
        }
        //        else {
        //            var list = Checklist("Birthdays")
        //            lists.append(list)
        //
        //            list = Checklist("Groceries")
        //            lists.append(list)
        //
        //            list = Checklist("Cool Apps")
        //            lists.append(list)
        //
        //            list = Checklist("To Do")
        //            lists.append(list)
        //
        //            for list in lists {
        //                let item = ChecklistItem()
        //                item.text = "Item for \(list.name)"
        //                list.items.append(item)
        //            }
        //        }
    }
    
    /*
     * 有三种情况会导致app中断：
     * 1.当内存耗尽的时候
     * 2.app异常崩溃的时候
     */
    func saveChecklists() {
        //数据放置的对象
        let data = NSMutableData()
        //NSKeyedArchiver，NSCoder创建plist文件的形式(二进制)
        let archiver = NSKeyedArchiver(forWritingWith: data)
        
        //需要被编码的对象实现NSCoding协议
        archiver.encode(lists, forKey: "Checklists")
        archiver.finishEncoding()
        //文件在存储介质上的路径
        data.write(to: dataFilePath(), atomically: true)
    }
}
