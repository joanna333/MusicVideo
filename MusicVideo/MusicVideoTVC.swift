//
//  MusicVideoTVC.swift
//  MusicVideo
//
//  Created by Joanna Kolny-Olesiak on 26.05.16.
//  Copyright © 2016 Joanna Kolny-Olesiak. All rights reserved.
//

import UIKit

class MusicVideoTVC: UITableViewController {
    var videos = [Videos]()
    var limit = 10
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(MusicVideoTVC.reachabilityStatusChanged), name: "ReachStatusChanged", object: nil)
           NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(MusicVideoTVC.prefferredFontChange), name: UIContentSizeCategoryDidChangeNotification, object: nil)
        
        reachabilityStatusChanged()
        
        
    }
    
    func prefferredFontChange() {
        print("The preferred font has changed")
    }
    
    func didLoadData(videos: [Videos]) {
        
        print(reachabilityStatus)
        self.videos = videos
        for item in videos {
            print("name = \(item.vName)")
        }
        
        for (index, item) in videos.enumerate() {
            print("\(index) name = \(item.vName)")
        }
        
        navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.redColor()]
        title = "The iTunes Top \(limit) Music Videos"
        tableView.reloadData()
    }
   
    
    
    func reachabilityStatusChanged() {
        
        switch reachabilityStatus {
        case NOACCESS:
           // view.backgroundColor = UIColor.redColor()
            dispatch_async(dispatch_get_main_queue()) {
                
                
                let alert = UIAlertController(title: "No Internet Access", message: "Please make sure you are connected to the Internet", preferredStyle: .Alert)
                let cancelAction = UIAlertAction(title: "Cancel", style: .Default) { action -> () in
                    print("Cancel")
                }
                let deleteAction = UIAlertAction(title: "Delete", style: .Destructive) { action -> () in
                    print("Delete")
                }
                let okAction = UIAlertAction(title: "OK", style: .Default) { action -> () in
                    print("OK")
                }
                alert.addAction(okAction)
                alert.addAction(cancelAction)
                alert.addAction(deleteAction)
                
                self.presentViewController(alert, animated: true, completion: nil)
            }
        default:
            //view.backgroundColor = UIColor.greenColor()
            if videos.count > 0 {
                print("do not refresh API")
            } else {
                runAPI()
            }
            
        }
        
    }
    
    
    @IBAction func refresh(sender: UIRefreshControl) {
        
        refreshControl?.endRefreshing()
        runAPI()
    }
    
    func getAPICount() {
        if NSUserDefaults.standardUserDefaults().objectForKey("APICNT") != nil {
            let theValue = NSUserDefaults.standardUserDefaults().objectForKey("APICNT") as! Int
            limit = theValue
        }
        
        let formatter = NSDateFormatter()
        formatter.dateFormat = "E, dd MMM yyyy HH:mm:ss"
        let refreshDte = formatter.stringFromDate(NSDate())
        
        refreshControl?.attributedTitle = NSAttributedString(string: "\(refreshDte)")
    }
    func runAPI() {
        
        getAPICount()
        //Call API
        let api = APIManager()
        api.loadData("https://itunes.apple.com/us/rss/topmusicvideos/limit=\(limit)/json", completion: didLoadData)
    }
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self, name: "ReachStatusChanged", object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIContentSizeCategoryDidChangeNotification, object: nil)
    }
    
    
    // MARK: - Table view data source
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return videos.count
    }
    
    private struct storyboard {
        static let cellReusedIndentifier = "cell"
        static let segueIdentifier = "musicDetail"
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(storyboard.cellReusedIndentifier, forIndexPath: indexPath) as! MusicVideoTableViewCell
        
        cell.video = videos[indexPath.row]
        
        
        return cell
    }
    
    
    /*
     // Override to support conditional editing of the table view.
     override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
     // Return false if you do not want the specified item to be editable.
     return true
     }
     */
    
    /*
     // Override to support editing the table view.
     override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
     if editingStyle == .Delete {
     // Delete the row from the data source
     tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
     } else if editingStyle == .Insert {
     // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
     }
     }
     */
    
    /*
     // Override to support rearranging the table view.
     override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {
     
     }
     */
    
    /*
     // Override to support conditional rearranging of the table view.
     override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
     // Return false if you do not want the item to be re-orderable.
     return true
     }
     */
    

     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == storyboard.segueIdentifier {
            if let indexpath = tableView.indexPathForSelectedRow {
                let video = videos[indexpath.row]
                let dvc = segue.destinationViewController as! MusicVideoDetailVC
                dvc.videos = video
            }
        }
        
    }

}

