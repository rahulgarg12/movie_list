//
//  SearchModel.swift
//  OMDB
//
//  Created by Rahul Garg on 24/04/19.
//  Copyright © 2019 Rahul Garg. All rights reserved.
//

import Foundation

class SearchModel {
    
    var title: String?
    var year: Date?
    var imdbId: String?
    var type: String?
    var poster: String?
    
    
    init(dict: [String:Any]?) {
        title = dict?[JSONKey().title] as? String
        imdbId = dict?[JSONKey().imdbId] as? String
        type = dict?[JSONKey().type] as? String
        poster = dict?[JSONKey().poster] as? String
        
        if let yearString = dict?[JSONKey().year] as? String {
            let dateFormatter = DateFormatter()
            dateFormatter.timeZone = TimeZone.current
            dateFormatter.calendar = Calendar.current
            dateFormatter.dateFormat = "yyyy"
            
            year = dateFormatter.date(from: yearString)
        }
    }
}
