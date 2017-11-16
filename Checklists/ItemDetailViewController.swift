//
//  AddItemTableViewController.swift
//  Checklists
//
//  Created by Marc SUN on 11/15/17.
//  Copyright © 2017 SUN. All rights reserved.
//

import UIKit

/*
 * 定义委托步骤(对象A是对象B的委托)
 * 1.为对象B定义一个委托协议
 * 2.给对象B一个可选型的委托变量，这个变量必须是weak的
 * 3.当某些事件触发时，让对象B发送消息到它的委托，使用如delegate?.methodName(self, ...)来完成功能
 * 4.让对象A遵守委托协议，将协议的名称放入类声明，，并且执行协议中的方法列表
 * 5.告诉对象B，对象A现在是你的委托了
 */

 /*数据在视图控制器之间传递有两种方法：
 *1.从A到B。当界面A打开界面B时，A可以给B需要的数据。简单地在B的视图控制器中创建一个实例变量，然后A转场到B时给这个变量赋值就可以了，这一工作通常都是在prepare(for:sender:)中完成的
 *2.从B到A。B回传数据给A则需要使用委托
  */

//委托和协议是手拉手出现的(class关键字表明只能由类来实现，不能由struct和enum来实现)
protocol ItemDetailViewControllerDelegate: class {
    //委托方法通常以第一个参数指代它们的属主
    func itemDetailControllerDidCancel(_ controller: ItemDetailViewController)
    func addItemController(_ controller: ItemDetailViewController, didFinishAdding item: ChecklistItem)
    func editItemController(_ controller: ItemDetailViewController, didFinishEditing item: ChecklistItem)
}

class ItemDetailViewController: UITableViewController, UITextFieldDelegate {
    
    //Outlet是确定的
    @IBOutlet private weak var textField: UITextField!
    
    //Done按钮
    @IBOutlet private weak var doneBarButton: UIBarButtonItem!
    
    //委托是可选的(不要定义为private，因为会被受委托者调用)
    var delegate: ItemDetailViewControllerDelegate?
    
    var itemToEdit: ChecklistItem?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        
        //判断是添加Item还是编辑Item
        if let item = itemToEdit {
            title = "Edit Item"
            textField.text = item.text
            doneBarButton.isEnabled = true
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
        return 1
    }

    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    //由于是static cells，用于信息输入，因此要禁用选中行的互动
    override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        return nil
    }
    
    //视图控制器在即将可视化之前接收此方法消息
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //控制聚焦或第一响应，让键盘自动滑出
        textField.becomeFirstResponder()
    }
    
    //监控输入框中的输入
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        //Swift中的String和Object-C中的NSString是桥接的
        let oldText = textField.text! as NSString
        let newText = oldText.replacingCharacters(in: range, with: string) as NSString
        
        //如果输入框没有输入或者被删除，则禁用Done按钮
        doneBarButton.isEnabled = (newText.length > 0)
        
//        if newText.length > 0 {
//            doneBarButton.isEnabled = true
//        } else {
//            doneBarButton.isEnabled = false
//        }
        
        return true
    }

    //IBAction永远不返回值
    @IBAction func cancel() {
//        dismiss(animated: true, completion: nil)
        delegate?.itemDetailControllerDidCancel(self)
    }
    
    @IBAction func done() {
//        dismiss(animated: true, completion: nil)
        
        if let item = itemToEdit {
            item.text = textField.text!
            delegate?.editItemController(self, didFinishEditing: item)
        } else {
            let item = ChecklistItem()
            item.text = textField.text!
            item.checked = false
            
            delegate?.addItemController(self, didFinishAdding: item)
        }
    }
}
