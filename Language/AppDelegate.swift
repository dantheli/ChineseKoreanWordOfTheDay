//
//  AppDelegate.swift
//  Language
//
//  Created by Daniel Li on 11/5/15.
//  Copyright © 2015 Dannical. All rights reserved.
//

import UIKit
import RealmSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        let defaults = NSUserDefaults.standardUserDefaults()
        if let identifier = defaults.objectForKey("topIdentifier") as? String {
            if identifier != identifiers[0] {
                swap(&titles[0], &titles[1])
                swap(&images[0], &images[1])
            }
        }
        
        /*
        // Examples
        let term = Term()
        term.language = "chinese"
        term.chinese = "你好"
        term.romanization = "ní hǎo"
        term.english = "Hello"
        term.formality = ""
        term.termDate = NSDate()
        
        let term1 = Term()
        term1.language = "korean"
        term1.korean = "안녕"
        term1.romanization = "annyeong"
        term1.english = "Hello"
        term1.formality = "Informal"
        term1.termDate = NSDate().dateByAddingTimeInterval(-1*24*60*60)
        
        let term2 = Term()
        term2.language = "korean"
        term2.korean = "안녕히 가세요"
        term2.romanization = "annyeonghi gaseyo"
        term2.english = "Goodbye"
        term2.formality = "Formal"
        term2.termDate = NSDate().dateByAddingTimeInterval(-2*24*60*60)
        
        let realm = try! Realm()
        try! realm.write {
            realm.deleteAll()
            realm.add(term)
            realm.add(term1)
            realm.add(term2)
        }
        
        print(try! Realm().objects(Term))
        */
        UINavigationBar.appearance().tintColor = UIColor.whiteColor()
        UINavigationBar.appearance().barTintColor = UIColor(red: 52/255, green: 111/255, blue: 199/255, alpha: 1)
        UINavigationBar.appearance().titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]
        UIBarButtonItem.appearance().tintColor = UIColor.whiteColor()
        
        return true
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

