//
//  Constants.swift
//  OMDB
//
//  Created by Rahul Garg on 24/04/19.
//  Copyright © 2019 Rahul Garg. All rights reserved.
//

import Foundation
import UIKit

struct ProjectConstants {
    let apiKey = "eeefc96f"
    
    //ImageViewController
    let imageViewControllerCollectionViewPadding: CGFloat = 15
    let imageViewControllerCollectionViewRowCount: CGFloat = 2
}


struct JSONKey {
    let apiKey = "apikey"
    let page = "page"
    
    let searchKey = "s"
    let searchText = "Batman"
    
    
    //Result Model
    let search = "Search"
    let totalResults = "totalResults"
    let response = "Response"
    
    //Search Model
    let title = "Title"
    let year = "Year"
    let imdbId = "imdbID"
    let type = "Type"
    let poster = "Poster"
}


struct ViewControllerIdentifiers {
    let homeVC = "ViewController"
    let detailVC = "DetailViewController"
}


struct CollectionViewCellReuseIdentifiers {
    let imageCell = "ViewCollectionViewCell"
}
