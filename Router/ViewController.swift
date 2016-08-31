//
//  ViewController.swift
//  Router
//
//  Created by Greg Pierce on 8/31/16.
//  Copyright © 2016 Agile Tortoise. All rights reserved.
//

import UIKit

class ViewController: UIViewController {    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    //MARK: Actions
    
    @IBAction func urlExampleButtonTapped(_ sender: AnyObject) {
        guard let url = URL(string: "router://x-callback-url/open?identifier=100") else { return }
        
        UIApplication.shared.open(url, options: [:]) { (didOpen) in
            //
        }
    }
    
    @IBAction func searchUrlExampleButtonTapped(_ sender: AnyObject) {
        guard let url = URL(string: "router://x-callback-url/search?query=test") else { return }
        
        UIApplication.shared.open(url, options: [:]) { (didOpen) in
            //
        }
    }
    

}

