//
//  AppDelegate.swift
//  Checklists
//
//  Created by Marc SUN on 11/15/17.
//  Copyright © 2017 SUN. All rights reserved.
//

import UIKit

/*
 * 在swift中，所有的基本类型：整型、浮点型、布尔型、字符串型、数组和字典都是值类型，并且在底层都是以结构体的形式所实现
 * 类是引用类型
 */

/*
 * let对于引用类型对象来说，并不能把对象变成常量，但是可以把对象的引用变成常量
 * 表示引用永远指向该对象，但对象本身可以发生改变
 */

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    //当app启动，并且加载StoryBoard时，会有一个短暂的瞬间window是nil
    var window: UIWindow?

    let dataModel = DataModel()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        //UIWindow是app中所有视图中的最高层级的视图
        let navigationController = window!.rootViewController as! UINavigationController
        let controller = navigationController.viewControllers[0] as! AllListsViewController
        controller.dataModel = dataModel
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        saveData()
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        saveData()
    }

    func saveData() {
        dataModel.saveChecklists()
    }

}

