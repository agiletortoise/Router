//
//  ViewController+RouterDelegate.swift
//  Router
//
//  Created by Greg Pierce on 8/31/16.
//  Copyright © 2016 Agile Tortoise. All rights reserved.
//

import UIKit

extension ViewController: RouterDelegate {

    func route(routerRequest: RouterRequest, router: Router) {
        switch routerRequest.requestType {
        case .open:
            let identifier = routerRequest.requestInfo["identifier"]
            let alert = UIAlertController(title: "Open", message: "Open action triggered for identifier: \(identifier!)", preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: nil))
            
            present(alert, animated: true, completion: nil)
            break
        case .search:
            let query = routerRequest.requestInfo["query"]
            let alert = UIAlertController(title: "Search", message: "Search action triggered for query: \(query!)", preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: nil))
            
            present(alert, animated: true, completion: nil)
            break
        }
    }
    
}
