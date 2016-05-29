//
//  ViewController.swift
//  MusicVideo
//
//  Created by Joanna Kolny-Olesiak on 22.05.16.
//  Copyright © 2016 Joanna Kolny-Olesiak. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Call API
        let api = APIManager()
        api.loadData("https://itunes.apple.com/us/rss/topmusicvideos/limit=10/json", completion: didLoadData)
    }


    func didLoadData(result: String) {
        dispatch_async(dispatch_get_main_queue()) {
        let alert = UIAlertController(title: (result), message: nil, preferredStyle: .Alert)
        
        let okAction = UIAlertAction(title: "Ok", style: .Default) { action -> Void in
        }
        alert.addAction(okAction)
        self.presentViewController(alert, animated: true, completion: nil)
        }
        
    }
}

