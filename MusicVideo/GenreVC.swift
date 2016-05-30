//
//  GenreVC.swift
//  MusicVideo
//
//  Created by Joanna Kolny-Olesiak on 30.05.16.
//  Copyright © 2016 Joanna Kolny-Olesiak. All rights reserved.
//

import UIKit

class GenreVC: UIViewController, UITableViewDelegate, UITableViewDataSource {

    let genreDict = ["All":"","Alternative":"1620", "Big Band":"1685","Blues":"1602", "Brazilian": "1671", "Children's Music": "1604", "Chinese": "1637", "Christian & Gospel": "1622", "Classical":"1605", "Country":"1606", "Dance":"1617", "Disney": "1631", "Electronic": "1607","Fitnesss & Workout": "1683", "German Pop": "1633", "Hip-Hop/Rap": "1618", "Instrumental": "1684", "Jazz": "1611", "Latin": "1612", "Opera": "1609", "Pop":"1614", "Rock": "1621", "Soundtrack": "1616"]
    var genreArray: [String] {
        return Array(genreDict.keys).sort()
    }
    var chosenGenre = ""
    var genreStringForAPI: String {
        if chosenGenre == "All" {
            return ""
        } else {
            return "/genre=\(genreDict[chosenGenre]!)"
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return genreArray.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("genreCell", forIndexPath: indexPath)
        cell.textLabel?.text = genreArray[indexPath.row]
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        chosenGenre = genreArray[indexPath.row]
        NSUserDefaults.standardUserDefaults().setObject(genreStringForAPI, forKey: "GENRESTRING")
        NSUserDefaults.standardUserDefaults().setObject(chosenGenre, forKey: "GENRE")
        
        print(NSUserDefaults.standardUserDefaults().objectForKey("GENRESTRING") as! String)
        print(NSUserDefaults.standardUserDefaults().objectForKey("GENRE") as! String)
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
}
