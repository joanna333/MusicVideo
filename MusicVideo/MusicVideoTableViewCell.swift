//
//  MusicVideoTableViewCell.swift
//  MusicVideo
//
//  Created by Joanna Kolny-Olesiak on 27.05.16.
//  Copyright © 2016 Joanna Kolny-Olesiak. All rights reserved.
//

import UIKit

class MusicVideoTableViewCell: UITableViewCell {
    
    var video: Video? {
        didSet {
            updateCell()
        }
    }
    
    @IBOutlet weak var musicImage: UIImageView!
    
    @IBOutlet weak var rank: UILabel!

    @IBOutlet weak var musicTitle: UILabel!
    
    func updateCell() {
        musicTitle.font = UIFont.preferredFontForTextStyle(UIFontTextStyleSubheadline)
        rank.font = UIFont.preferredFontForTextStyle(UIFontTextStyleSubheadline)
        
        musicTitle.text = video?.vName
        rank.text = ("\(video!.vRank)")
        
        if video!.vImageData != nil {
            print("Get data from array ...")
            musicImage.image = UIImage(data: video!.vImageData!)
        } else {
         getVideoImage(video!, imageView: musicImage)
            print("Get images in background thread")
        }
        
    }
    
    func getVideoImage(video: Video, imageView: UIImageView)  {
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {
            let data = NSData(contentsOfURL: NSURL(string: video.vImageUrl)!)
            
            var image: UIImage?
            if data != nil {
                video.vImageData = data
                image = UIImage(data: data!)
            }
            dispatch_async(dispatch_get_main_queue()) {
                imageView.image = image
            }
        }
    }
}
