//
//  MusicVideoTVC.swift
//  MusicVideo
//
//  Created by Joanna Kolny-Olesiak on 26.05.16.
//  Copyright © 2016 Joanna Kolny-Olesiak. All rights reserved.
//

import UIKit

var resolution = "300x300"

class MusicVideoTVC: UITableViewController {
    var videos = [Video]()
    
    var filterSearch = [Video]()
    
    let resultSearchController = UISearchController(searchResultsController: nil)
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
    
    func didLoadData(videos: [Video]) {
        
        print(reachabilityStatus)
        self.videos = videos
        if videos.count == 0 {
            let alert = UIAlertController(title: "No Vidoes found", message: "Choose another genre in the Settings", preferredStyle: .Alert)
            
            let okAction = UIAlertAction(title: "OK", style: .Default) { action -> () in
            }
            alert.addAction(okAction)
            self.presentViewController(alert, animated: true, completion: nil)
        }
        for (index, item) in videos.enumerate() {
            print("\(index) name = \(item.vName)")
            print("\(index) name = \(item.vPrice)")
        }
        
        navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.redColor()]
        if (NSUserDefaults.standardUserDefaults().objectForKey("GENRE")) != nil {
            if (NSUserDefaults.standardUserDefaults().objectForKey("GENRE") as! String) == "All" {
                title = "The iTunes Top \(limit) Music Videos"
            } else {
                title = "\(NSUserDefaults.standardUserDefaults().objectForKey("GENRE") as! String): Top \(limit)"
            }

        } else {
           title = "The iTunes Top \(limit) Music Videos" 
        }
                resultSearchController.searchResultsUpdater = self
        definesPresentationContext = true
        resultSearchController.dimsBackgroundDuringPresentation = false
        resultSearchController.searchBar.placeholder = "Search for Artist, Name, Rank"
        resultSearchController.searchBar.searchBarStyle = UISearchBarStyle.Prominent
        tableView.tableHeaderView = resultSearchController.searchBar
        tableView.reloadData()
    }
    
    func setImageQuality() {
        if NSUserDefaults.standardUserDefaults().boolForKey("BestImageQuality") {
        switch reachabilityStatus {
        case WIFI:
            resolution = "600x600"
        default:
            resolution = "300x300"
        }
        } else {
            resolution = "300x300"
        }
    }
    
    
    func reachabilityStatusChanged() {
        
        switch reachabilityStatus {
        case NOACCESS:
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
            if videos.count > 0 {
                print("do not refresh API")
            } else {
                runAPI()
            }
            
        }
        setImageQuality()
        
    }
    
    
    @IBAction func refresh(sender: UIRefreshControl) {
        
        refreshControl?.endRefreshing()
        
        if resultSearchController.active {
            refreshControl?.attributedTitle = NSAttributedString(string: "No refresh allowed in search")
        } else {
        runAPI()
        }
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
        if NSUserDefaults.standardUserDefaults().objectForKey("GENRESTRING") == nil {
            NSUserDefaults.standardUserDefaults().setObject("", forKey: "GENRESTRING")
        }
        let chosenGenre = NSUserDefaults.standardUserDefaults().objectForKey("GENRESTRING") as! String
        //Call API
        let api = APIManager()
        api.loadData("https://itunes.apple.com/us/rss/topmusicvideos/limit=\(limit)\(chosenGenre)/json", completion: didLoadData)
        print("https://itunes.apple.com/us/rss/topmusicvideos/limit=\(limit)\(chosenGenre)/json")
    }
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self, name: "ReachStatusChanged", object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIContentSizeCategoryDidChangeNotification, object: nil)
    }
    
    
    // MARK: - Table view data source
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if resultSearchController.active {
            return filterSearch.count
        }
        return videos.count
    }
    
    private struct storyboard {
        static let cellReusedIndentifier = "cell"
        static let segueIdentifier = "musicDetail"
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(storyboard.cellReusedIndentifier, forIndexPath: indexPath) as! MusicVideoTableViewCell
        if resultSearchController.active {
            cell.video = filterSearch[indexPath.row]
        } else {
            cell.video = videos[indexPath.row]
        }
        
        return cell
    }
    
    
    // MARK: - Navigation
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == storyboard.segueIdentifier {
            if let indexpath = tableView.indexPathForSelectedRow {
                let video: Video
                if resultSearchController.active {
                    video = filterSearch[indexpath.row]
                } else {
                    video = videos[indexpath.row]
                }
                let dvc = segue.destinationViewController as! MusicVideoDetailVC
                dvc.videos = video
            }
        }
    }
    func filterSearch(searchText: String) {
        filterSearch = videos.filter { videos in
        return videos.vArtist.lowercaseString.containsString(searchText.lowercaseString) || videos.vName.lowercaseString.containsString(searchText.lowercaseString) || "\(videos.vRank)".lowercaseString.containsString(searchText.lowercaseString)
        }
        tableView.reloadData()
    }
    
}
