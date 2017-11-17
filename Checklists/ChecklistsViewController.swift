//
//  ViewController.swift
//  Checklists
//
//  Created by Marc SUN on 11/15/17.
//  Copyright © 2017 SUN. All rights reserved.
//

import UIKit

//以NS为前缀的对象都是Foundation框架提供的，NS是NextStep的缩写

class ChecklistsViewController: UITableViewController, ItemDetailViewControllerDelegate {
    
    var checklist: Checklist!
    
//    private var listItems: [ChecklistItem]
    
//    required init?(coder aDecoder: NSCoder) {
////        初始化空数组
////        listItems = [ChecklistItem]()
//
//        super.init(coder: aDecoder)
////        loadChecklistItems()
//
//        print("Documents folder is \(documentDirectory())")
//        print("Data file path is \(dataFilePath())")
//    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        title = checklist.name
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    /*
     * UITableView的数据来源协议(data source protocol)的一部分,当前ViewController作为数据源代理
     */
    
    //cell是可以复用的，当前屏幕显示的cell(可见的)数量才是需要关心的，滚动时会将新数据填充进入复用的cell中，节省内存的占用
    
    //在swift中，参数的名称是方法全名的一部分
    
    //获取当前拥有的数据行数
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return listItems.count
        return checklist.items.count
    }
    
    //获取所拥有的数据行数中的数据（根据返回的行数发送多次请求）
    //此数据源方法的目的是当某一行可见时，传递一个新的(或者重新利用的)cell对象到table view,只有UITableView可以调用它的数据源方法
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //获取prototype cell的拷贝(UITableViewCell对象)，带有IndexPath参数的仅适用于标准cell
        let cell = tableView.dequeueReusableCell(withIdentifier: "ChecklistItem", for: indexPath)
        
//        let item = listItems[indexPath.row]
        let item = checklist.items[indexPath.row]
        configureText(for: cell, with: item)
        configureCheckmark(for: cell, with: item)
 
        return cell
    }
    
    //UITableViewDelegate委托方法，选中某一行之后处理动作
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //获取正在显示的某一行中的一个已经存在的cell
        if let cell = tableView.cellForRow(at: indexPath) {
//            let item = listItems[indexPath.row]
            let item = checklist.items[indexPath.row]
            item.toggleChecked()
            configureCheckmark(for: cell, with: item)
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
        
//        saveChecklistItems()
    }
    
    //滑动等操作改变style时被调用
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
//        listItems.remove(at: indexPath.row)
        checklist.items.remove(at: indexPath.row)
        let indexPaths = [indexPath]
        tableView.deleteRows(at: indexPaths, with: .automatic)
        
//        saveChecklistItems()
    }
    
    //在一个界面将要向另一个界面转场时被调用(sender参数包含了一个控制转场的引用)
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "AddItem" {
            //转场的目的视图控制器
            let navigationController = segue.destination as! UINavigationController
            
            //获取顶层视图
            let controller = navigationController.topViewController as! ItemDetailViewController
            
            //将代理权交给被委托者
            controller.delegate = self
        } else if segue.identifier == "EditItem" {
            let navigationController = segue.destination as! UINavigationController
            
            let controller = navigationController.topViewController as! ItemDetailViewController
            
            controller.delegate = self
            
            //选取的需要编辑的Item信息被保存在itemToEdit对象中
            if let indexPath = tableView.indexPath(for: sender as! UITableViewCell) {
//                controller.itemToEdit = listItems[indexPath.row]
                controller.itemToEdit = checklist.items[indexPath.row]
            }
        }
    }
    
    func itemDetailControllerDidCancel(_ controller: ItemDetailViewController) {
        controller.dismiss(animated: true, completion: nil)
    }
    
    func addItemController(_ controller: ItemDetailViewController, didFinishAdding item: ChecklistItem) {
        controller.dismiss(animated: true, completion: nil)
    
        addItem(item: item)
        
//        saveChecklistItems()
    }
    
    func editItemController(_ controller: ItemDetailViewController, didFinishEditing item: ChecklistItem) {
        controller.dismiss(animated: true, completion: nil)
        
        if let index = checklist.items.index(of: item) {
            let indexPath = IndexPath(row: index, section: 0)
            if let cell = tableView.cellForRow(at: indexPath) {
                configureText(for: cell, with: item)
            }
        }
        
//        saveChecklistItems()
    }
    
    func configureText(for cell: UITableViewCell, with item: ChecklistItem) {
        let label = cell.viewWithTag(1000) as! UILabel
        label.text = item.text
    }
    
    func configureCheckmark(for cell: UITableViewCell, with item: ChecklistItem) {
        let label = cell.viewWithTag(1001) as! UILabel
        
        if item.checked  {
            //cell的accessory属性设置
            label.text = "√"
        } else {
            label.text = ""
        }
    }
    
    func addItem(item: ChecklistItem) {
        //数据模型和表格空间中需要同时添加数据，数据模型和视图必须保持同步
        
        //新添加的行在数组中的索引号
        let newRowIndex = checklist.items.count
        
        checklist.items.append(item)
        
        //IndexPath标识新的行位置：section 0的第newRowIndex行
        let indexPath = IndexPath(row: newRowIndex, section: 0)
        
        let indexPaths = [indexPath]
        //添加多行数据，传入行索引号数组
        tableView.insertRows(at: indexPaths, with: .automatic)
    }
}

