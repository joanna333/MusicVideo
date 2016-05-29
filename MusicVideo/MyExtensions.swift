//
//  MyExtensions.swift
//  MusicVideo
//
//  Created by Joanna Kolny-Olesiak on 29.05.16.
//  Copyright © 2016 Joanna Kolny-Olesiak. All rights reserved.
//

import UIKit

extension MusicVideoTVC: UISearchResultsUpdating {
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        searchController.searchBar.text?.lowercaseString
        filterSearch(searchController.searchBar.text!)
    }
    
}

