//
//  AboutVC.swift
//  MusicVideo
//
//  Created by Joanna Kolny-Olesiak on 28.05.16.
//  Copyright © 2016 Joanna Kolny-Olesiak. All rights reserved.
//

import UIKit

class AboutVC: UIViewController {

    @IBOutlet weak var createdLbl: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()

        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(MusicVideoTVC.prefferredFontChange), name: UIContentSizeCategoryDidChangeNotification, object: nil)
    }

    func prefferredFontChange()  {
        createdLbl.font = UIFont.preferredFontForTextStyle(UIFontTextStyleBody)
    }
    
    deinit {

        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIContentSizeCategoryDidChangeNotification, object: nil)
    }
    
   }
