//
//  MusicVideoTableViewCell.swift
//  MusicVideo
//
//  Created by Joanna Kolny-Olesiak on 27.05.16.
//  Copyright © 2016 Joanna Kolny-Olesiak. All rights reserved.
//

import UIKit

class MusicVideoTableViewCell: UITableViewCell {
    
    var video: Videos? {
        didSet {
            updateCell()
        }
    }
    
    @IBOutlet weak var musicImage: UIImageView!
    
    @IBOutlet weak var rank: UILabel!

    @IBOutlet weak var musicTitle: UILabel!
    
    func updateCell() {
        
        musicTitle.text = video?.vName
        rank.text = ("\(video!.vRank)")
        musicImage.image = UIImage(named: "imageNotAvailable")
        
    }
        
}
