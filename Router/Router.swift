/**
    # Router
//
//  Created by Greg Pierce on 8/31/16.
//  Copyright © 2016 Agile Tortoise. All rights reserved.
*/

import UIKit
import CoreSpotlight

/**
 Defines the types of commands supported by the router. This should be modify for app.
 */
public enum RouterRequestType: String {
    case open
    case search
}

/**
 Holds details pulled from the routing source.
 */
public struct RouterRequest {
    let uuid: String = UUID().uuidString
    let requestType: RouterRequestType
    let requestInfo: Dictionary<String, String>
    let successCallback: ((_ params: Dictionary<String, String>?) -> (Void))?
    let errorCallback: ((_ params: Dictionary<String, String>?) -> (Void))?
    let cancelCallback: ((_ params: Dictionary<String, String>?) -> (Void))?
}

public protocol RouterDelegate {
    func route(routerRequest: RouterRequest, router: Router)
}

public class Router {

    public var delegate: RouterDelegate?
    var lastRouterRequest: RouterRequest?
    
    public init() {}
    
    /**
     Routes a UIApplicationShortcutItem. Parses and creates generic RouterRequest, and passes to appropriate delegate method.
     */
    public func route(shortcutItem: UIApplicationShortcutItem, completionHandler: (Bool) -> Void) {
        if shortcutItem.type.hasSuffix("search") {
            let request = RouterRequest(requestType: .search, requestInfo: ["query": ""], successCallback: nil, errorCallback: nil, cancelCallback: nil)
            delegate?.route(routerRequest: request, router: self)
            completionHandler(true)
        }
    }

    /**
     Routes an NSUserActivity. Parses and creates generic RouterRequest, and passes to appropriate delegate method.
     */
    public func route(userActivity: NSUserActivity, completionHandler: (Bool) -> Void) {
        if userActivity.activityType == CSSearchableItemActionType { // Spotlight
            if let identifier = userActivity.userInfo?[CSSearchableItemActivityIdentifier] as? String {
                let request = RouterRequest(requestType: .open, requestInfo: ["identifier":identifier], successCallback: nil, errorCallback: nil, cancelCallback: nil)
                delegate?.route(routerRequest: request, router: self)
                completionHandler(true)
            }
        }
    }
    
    /**
     Routes a URL. Parses and creates generic RouterRequest, and passes to appropriate delegate method.
     */
    public func route(url: URL, options: [UIApplicationOpenURLOptionsKey : Any]) -> Bool {
        guard let components = URLComponents(url: url, resolvingAgainstBaseURL: false) else { return false }
        
        if components.host == "x-callback-url" {
            let actionName = components.path.lowercased()
            var successCallback: ((_ params: Dictionary<String, String>?) -> (Void))?
            var cancelCallback: ((_ params: Dictionary<String, String>?) -> (Void))?
            var errorCallback: ((_ params: Dictionary<String, String>?) -> (Void))?
            let callbackParams = ["x-success","x-cancel","x-error"]
            
            if let params = components.queryItems {
                for item: URLQueryItem in params {
                    let paramName = item.name.lowercased()
                    guard callbackParams.contains(paramName) else { continue }
                    guard let cbURLString = item.value else { continue }
                    
                    if var cbURL = URL(string: cbURLString) {
                        let callback = { (params: Dictionary<String, String>?) -> (Void) in
                            if params != nil {
                                var cbComponents = URLComponents(url: cbURL, resolvingAgainstBaseURL: false)
                                for key in params!.keys {
                                    cbComponents?.queryItems?.append(URLQueryItem(name: key, value: params![key]))
                                }
                                if let newURL = cbComponents?.url {
                                    cbURL = newURL
                                }
                            }
                            DispatchQueue.main.async {
                                UIApplication.shared.open(cbURL, options: [:], completionHandler: { (didOpen) in
                                    
                                })
                            }
                        }
                        if paramName == "x-success" {
                            successCallback = callback
                        }
                        else if paramName == "x-cancel" {
                            cancelCallback = callback
                        }
                        else if paramName == "x-error" {
                            errorCallback = callback
                        }
                    }
                }
            }
            
            if actionName == "/open" {
                var identifier = ""
                if let params = components.queryItems {
                    for item: URLQueryItem in params {
                        if item.name.lowercased() == "identifier" {
                            if let s = item.value {
                                identifier = s
                            }
                        }
                    }
                }
                let request = RouterRequest(requestType: .open, requestInfo: ["identifier":identifier], successCallback: successCallback, errorCallback: errorCallback, cancelCallback: cancelCallback)
                delegate?.route(routerRequest: request, router: self)
                return true
            } else if actionName == "/search" {
                var query = ""
                if let params = components.queryItems {
                    for item: URLQueryItem in params {
                        if item.name.lowercased() == "query" {
                            if let s = item.value {
                                query = s
                            }
                        }
                    }
                }
                let request = RouterRequest(requestType: .search, requestInfo: ["query": query], successCallback: successCallback, errorCallback: errorCallback, cancelCallback: cancelCallback)
                delegate?.route(routerRequest: request, router: self)
                return true
            }
        }
        
        return false
    }
}
