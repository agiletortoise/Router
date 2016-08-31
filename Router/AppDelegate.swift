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
        router.delegate = viewController
        
        performShortcutItem = true
        if let shortcutItem = launchOptions?[UIApplicationLaunchOptionsKey.shortcutItem] as? UIApplicationShortcutItem {
            handleShortcutItem(shortcutItem, completionHandler: nil)
            performShortcutItem = false
        }
        
        return true
    }
    
    //MARK: URLs
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        return router.route(url: url, options: options)
    }
    
    //MARK: Shortcuts
    
    func application(_ application: UIApplication, performActionFor shortcutItem: UIApplicationShortcutItem, completionHandler: @escaping (Bool) -> Swift.Void) {
        guard performShortcutItem else { return }
        
        handleShortcutItem(shortcutItem, completionHandler: completionHandler)
    }
    
    func handleShortcutItem(_ shortcutItem: UIApplicationShortcutItem, completionHandler: ((Bool) -> Void)?) {
        router.route(shortcutItem: shortcutItem) { (success) in
            completionHandler?(success)
        }
    }

    //MARK: NSUserActivity
    
    func application(_ application: UIApplication, continue userActivity: NSUserActivity, restorationHandler: @escaping ([Any]?) -> Swift.Void) -> Bool {
        router.route(userActivity: userActivity) { (success) in
            // do nothing - or call restoration handler if necessary
        }
        return true
    }

}

