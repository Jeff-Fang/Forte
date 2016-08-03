//
//  AppDelegate.swift
//  Forte
//
//  Created by Jeff Fang on 3/27/16.
//  Copyright © 2016 swordx. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    @available(iOS 10.0, *)
    lazy var coreDataStack = CoreDataStack()
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        customizeAppearance()
        checkUserDefaults()
        distributeManagedObjectController()
        
        return true
    }
    
    func checkUserDefaults() {
        let defaults = UserDefaults.standard()
        let isPreloaded = defaults.bool(forKey: "isPreloaded")
        if !isPreloaded {
            let preloader = Preloader()
            preloader.coreDataStack = coreDataStack
            preloader.preloadData()
            
            
            defaults.set(true, forKey: "isPreloaded")
        }
    }
    
    func distributeManagedObjectController() {
        let tabBarController = window!.rootViewController as! UITabBarController
        if let tabBarViewControllers = tabBarController.viewControllers {
            let searchViewController = tabBarViewControllers[0] as! SearchViewController
            searchViewController.managedObjectContext = coreDataStack.persistentContainer.viewContext
            
            let navigationController = tabBarViewControllers[1] as! UINavigationController
            let markedItemTableViewController = navigationController.viewControllers[0] as! MarkedItemTableViewController
            markedItemTableViewController.managedObjectContext = coreDataStack.persistentContainer.viewContext
            
        }
    }
    
    func customizeAppearance() {
        let redColor = UIColor(colorLiteralRed: 255/255 , green: 80/255 , blue: 100/255 , alpha: 1)
        
        UINavigationBar.appearance().titleTextAttributes = [ NSForegroundColorAttributeName: redColor ]
        UINavigationBar.appearance().tintColor = redColor
        //        UINavigationBar.appearance().barTintColor = UIColor.blackColor()
        
        UITabBar.appearance().tintColor = redColor
        //        UITabBar.appearance().barTintColor = UIColor.blackColor()
        
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // Saves changes in the application's managed object context before the application terminates.
        
        do {
            try coreDataStack.persistentContainer.viewContext.save()
        } catch {
            print(error)
        }
    }
}

