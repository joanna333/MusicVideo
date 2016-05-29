//
//  MusicVideoDetailVC.swift
//  MusicVideo
//
//  Created by Joanna Kolny-Olesiak on 27.05.16.
//  Copyright © 2016 Joanna Kolny-Olesiak. All rights reserved.
//

import UIKit
import AVKit
import AVFoundation
import LocalAuthentication

class MusicVideoDetailVC: UIViewController {
    
    var videos:Video!
    var securitySwitch = false
    
    @IBOutlet weak var vName: UILabel!
    
    @IBOutlet weak var videoImage: UIImageView!
    
    @IBOutlet weak var vGenre: UILabel!
    
    @IBOutlet weak var vPrice: UILabel!
    
    @IBOutlet weak var vRights: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(MusicVideoDetailVC.preferredFontChange), name: UIContentSizeCategoryDidChangeNotification, object: nil)
        
        title = videos.vArtist
        vName.text = videos.vName
        vPrice.text = videos.vPrice
        vRights.text = videos.vRights
        vGenre.text = videos.vGenre
        
        if videos.vImageData != nil {
            videoImage.image = UIImage(data: videos.vImageData!)
        } else {
           videoImage.image = UIImage(named: "imageNotAvailable")
        }
    }
    
    @IBAction func socialMedia(sender: UIBarButtonItem) {
        securitySwitch = NSUserDefaults.standardUserDefaults().boolForKey("SecSetting")
        
        switch securitySwitch {
        case true:
            touchIdChk()
        default:
            shareMedia()
        }
    }
    
    func touchIdChk() {
        //Create an alert
        let alert = UIAlertController(title: "", message: "", preferredStyle: .Alert)
        alert.addAction(UIAlertAction(title: "continue", style: .Cancel, handler: nil))
        
        // Creat the Local Authentication Context
        let context = LAContext()
        var touchIDError : NSError?
        let reasonString = "Touch-Id authentication is needed to share info on Social Media"
        
        // Check if we can access local device authentication
        if context.canEvaluatePolicy(LAPolicy.DeviceOwnerAuthenticationWithBiometrics, error:&touchIDError) {
            context.evaluatePolicy(LAPolicy.DeviceOwnerAuthenticationWithBiometrics, localizedReason: reasonString, reply: { (success, policyError) -> Void in
                if success {
                    dispatch_async(dispatch_get_main_queue()) {
                        [unowned self] in
                        self.shareMedia()
                    }
                } else {
                    alert.title = "Unsuccessful!"
                    
                    switch LAError(rawValue: policyError!.code)! {
                    case .AppCancel:
                        alert.message = "Authentication was cancelled by application"
                    case .AuthenticationFailed:
                        alert.message = "The user failed to provide valid credentials"
                    case .PasscodeNotSet:
                        alert.message = "Passcode is not set on the device"
                    case .SystemCancel:
                        alert.message = "Authentication was cancelled by the system"
                    case .TouchIDLockout:
                        alert.message = "Too many failed attempts"
                    case .UserCancel:
                        alert.message = "You cancelled the request"
                    case .UserFallback:
                        alert.message = "Password not accepted, must use Touch-ID"
                    default:
                        alert.message = "Unable to Authenticate!"
                    }
                    dispatch_async(dispatch_get_main_queue()) {
                        [unowned self] in
                        self.presentViewController(alert, animated: true, completion: nil)
                    }
                }
                
            })
        } else {
            // Unable to access local device authentication
            
            // Set the error title
            
            alert.title = "Error"
            
            switch LAError(rawValue: touchIDError!.code)! {
            case .TouchIDNotEnrolled:
                alert.message = "Touch ID is not enrolled"
            case .TouchIDNotAvailable:
                alert.message = "Touch ID is not available on the device"
            case .PasscodeNotSet:
                alert.message = "Passcode has not been set"
            case .InvalidContext:
                alert.message = "The context is invalid"
            default:
                alert.message = "Local Athentication not available"
            }
            dispatch_async(dispatch_get_main_queue()) { [unowned self] in
                self.presentViewController(alert, animated: true, completion: nil)
            }
        }
        
    }
    
    func shareMedia() {
        let activity1 = "Have you had the opportunity to see this Music Video?"
        let activity2 = "\(videos.vName) by \(videos.vArtist)"
        let activity3 = "Watch it and tell me what you think?"
        let activity4 = videos.vLinkToiTunes
        let activity5 = "(Shared with the Music Video App - Step It UP)"
        
        
        let activityViewController: UIActivityViewController = UIActivityViewController(activityItems: [activity1, activity2, activity3, activity4, activity5], applicationActivities: nil)
        
        //activityViewController.excludedActivityTypes = [UIActivityTypeMail]
        
        
        activityViewController.completionWithItemsHandler = { (activity, success, items, error) in
            if activity == UIActivityTypeMail {
                print("email selected")
            }
        }
        self.presentViewController(activityViewController, animated: true, completion: nil)
        
    }
    
    @IBAction func playVideo(sender: UIBarButtonItem) {
        let url = NSURL(string: videos.vVideoUrl)!
        let player = AVPlayer(URL: url)
        let playerViewController = AVPlayerViewController()
        playerViewController.player = player
        self.presentViewController(playerViewController, animated: true) { 
            playerViewController.player?.play()
        }
        
    }
    
    func preferredFontChange() {
        vName.font = UIFont.preferredFontForTextStyle(UIFontTextStyleSubheadline)
        vPrice.font = UIFont.preferredFontForTextStyle(UIFontTextStyleSubheadline)
        vRights.font = UIFont.preferredFontForTextStyle(UIFontTextStyleBody)
        vGenre.font = UIFont.preferredFontForTextStyle(UIFontTextStyleSubheadline)
    }
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIContentSizeCategoryDidChangeNotification, object: nil)
    }
        
}
