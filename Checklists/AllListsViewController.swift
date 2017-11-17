//
//  AllListsViewController.swift
//  Checklists
//
//  Created by Marc SUN on 11/17/17.
//  Copyright © 2017 SUN. All rights reserved.
//

import UIKit

class AllListsViewController: UITableViewController, ListDetailViewControllerDelegate, UINavigationControllerDelegate {

//    var lists: [Checklist]
//    var lists: Array<Checklist>
    var dataModel: DataModel!
    
    //当UIKit从StoryBoard中读取视图控制器时会调用此方法(NSCoder用来解析storyboard文件和其他编码文件)
//    required init?(coder aDecoder: NSCoder) {
//        lists = [Checklist]()
//
//        super.init(coder: aDecoder)
//
//        loadChecklists()
//    }
    
    //每次加载此界面时被调用（不仅仅是在app启动时）
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        
        navigationController?.delegate = self
        let index = UserDefaults.standard.integer(forKey: "ChecklistIndex")
        
        //如果有保存之前因为意外终止存储的数据，读取并且调到相应界面
        if index != -1 {
            let checklist = dataModel.lists[index]
            performSegue(withIdentifier: "ShowChecklist", sender: checklist)
//            UserDefaults.standard.set(-1, forKey: "ChecklistIndex")
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return dataModel.lists.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "Cell"
        let cell = makeCell(for: tableView, with: cellIdentifier)
       
        let checklist = dataModel.lists[indexPath.row]
        cell.textLabel!.text = checklist.name
        cell.accessoryType = .detailDisclosureButton
        
        return cell
    }
    
    //当用户点击某一行时触发此委托方法
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //将用户当前关注的行存入UserDefaults中，避免app意外终止丢失掉必要数据
        UserDefaults.standard.set(indexPath.row, forKey: "ChecklistIndex")
        
        let checklist = dataModel.lists[indexPath.row]
        //手动转场(将要传递的对象方法sender中)
        performSegue(withIdentifier: "ShowChecklist", sender: checklist)
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            dataModel.lists.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */
    
    //accessory按钮点击触发
    override func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
        let navigationController = storyboard!.instantiateViewController(withIdentifier: "ListDetailNavigationController") as! UINavigationController
        let controller = navigationController.topViewController as! ListDetailViewController
        controller.delegate = self
        let checklist = dataModel.lists[indexPath.row]
        controller.checklistToEdit = checklist
        present(navigationController, animated: true, completion: nil)
    }

    //在转场执行后立即被调用(目标控制器的viewDidLoad方法在此方法之后被调用)
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "ShowChecklist" {
            let controller = segue.destination as! ChecklistsViewController
            //将sender赋值给目标控制器的指定对象(不是传递的拷贝，传递的是引用)
            controller.checklist = sender as! Checklist      //type cast
        } else if segue.identifier == "AddChecklist" {
            let navigationController = segue.destination as! UINavigationController
            let controller = navigationController.topViewController as! ListDetailViewController
            controller.delegate = self
            controller.checklistToEdit = nil
        }
    }
    
    /*
     * ==检查的是两个变量是否有同一个值
     * ===检查的是两个变量是否引用了同一个对象
     */
    //导航栏栈堆中推入或者弹出视图控制器时被调用
    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        if viewController === self {
            //类似于安卓里的SharedPreference
            UserDefaults.standard.set(-1, forKey: "ChecklistIndex")
        }
    }
 
    //创建cell（获取可以复用的cell对象，如果没有则新创建一个）
    /*
     * 制作cell有四种方法：
     * 1.使用标准cell。在ChecklistsViewController中使用。
     * 2.使用静态cell。在ItemDetailViewController中使用，静态cell最大的优势是不用给它提供数据源方法，适用于提前知道cell内容的情况。
     * 3.使用nib文件。一个nib(也叫做XIB)像是一个迷你的仅仅包含一个自定义的UITableViewCell对象的故事模板。
     * 4.手动创建。在AllListsViewController中使用，优点是比较灵活。
     */
    func makeCell(for tableView: UITableView, with cellIdentifier: String) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) {
            return cell
        } else {
            return UITableViewCell(style: .default, reuseIdentifier: cellIdentifier)
        }
    }
    
    func listDetailViewControllerDidCancel() {
        dismiss(animated: true, completion: nil)
    }
    
    func listDetailViewController(_ controller: ListDetailViewController, didFinishAdding checkList: Checklist) {
        dismiss(animated: true, completion: nil)
        
        let newRowIndex = dataModel.lists.count
        dataModel.lists.append(checkList)
        let indexPath = IndexPath(row: newRowIndex, section: 0)
        let indexPaths = [indexPath]
        tableView.insertRows(at: indexPaths, with: .automatic)
    }
    
    func listDetailViewController(_ controller: ListDetailViewController, didFinishEditing checkList: Checklist) {
        dismiss(animated: true, completion: nil)
        
        if let index = dataModel.lists.index(of: checkList) {
            let indexPath = IndexPath(row: index, section: 0)
            if let cell = tableView.cellForRow(at: indexPath) {
                cell.textLabel!.text = checkList.name
            }
        }
    }
}
