//
//  AppDelegate.swift
//  Yorla
//
//  Created by Tom on 4/11/19.
//  Copyright © 2019 Tom. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        let ud = UserDefaults.standard
        
        if !ud.bool(forKey: "firstRun") {
            ud.set(true, forKey: "firstRun")
            ud.set(13, forKey: "bab")
            ud.set(15, forKey: "dex")
            ud.set(3, forKey: "SADice")
            ud.set(4, forKey: "favoredEnemyBonus")
            ud.set(3, forKey: "studiedTargetBonus")
            ud.set(2, forKey: "miscAttack")
            ud.set(1, forKey: "miscDamage")
            ud.set(5, forKey: "numberAttack")
            ud.set(false, forKey: "autoAttack")
            ud.set(false, forKey: "autoDamage")
            
            ud.set(1, forKey: "highestAC")
            ud.set(false, forKey: "PBS")
            ud.set(false, forKey: "SA")
            ud.set(true, forKey: "deadlyAim")
            ud.set(false, forKey: "gravBow")
            ud.set(false, forKey: "favoredEnemy")
            ud.set(false, forKey: "studiedTarget")
            ud.set(false, forKey: "holy")
            ud.set(false, forKey: "bane")
        }
        
        
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

