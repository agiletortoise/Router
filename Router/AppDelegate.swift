//
//  AppDelegate.swift
//  Router
//
//  Created by Greg Pierce on 8/31/16.
//  Copyright © 2016 Agile Tortoise. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    let router = Router()
    var performShortcutItem = true

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        let viewController = window?.rootViewController as! ViewController
        // assign router delegate, which will handle the parse router requests
        router.delegate = viewController
        
        // check for and handle shortcut item if needed
        performShortcutItem = true
        if let shortcutItem = launchOptions?[UIApplicationLaunchOptionsKey.shortcutItem] as? UIApplicationShortcutItem {
            handleShortcutItem(shortcutItem, completionHandler: nil)
            performShortcutItem = false
        }
        
        return true
    }
    
    //MARK: URLs
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        // pass URL to router to be handled
        return router.route(url: url, options: options)
    }
    
    //MARK: Shortcuts
    
    func application(_ application: UIApplication, performActionFor shortcutItem: UIApplicationShortcutItem, completionHandler: @escaping (Bool) -> Swift.Void) {
        guard performShortcutItem else { return }
        
        handleShortcutItem(shortcutItem, completionHandler: completionHandler)
    }
    
    func handleShortcutItem(_ shortcutItem: UIApplicationShortcutItem, completionHandler: ((Bool) -> Void)?) {
        // pass shortcut item to router to be handled
        router.route(shortcutItem: shortcutItem) { (success) in
            completionHandler?(success)
        }
    }

    //MARK: NSUserActivity
    
    func application(_ application: UIApplication, continue userActivity: NSUserActivity, restorationHandler: @escaping ([Any]?) -> Swift.Void) -> Bool {
        // pass NSUserActivity to router to handle
        router.route(userActivity: userActivity) { (success) in
            // do nothing - or call restoration handler if necessary
        }
        return true
    }

}

