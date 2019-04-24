//
//  ResultModel.swift
//  OMDB
//
//  Created by Rahul Garg on 24/04/19.
//  Copyright © 2019 Rahul Garg. All rights reserved.
//

import Foundation

class ResultModel {
    
    let totalResults: Int
    var response: APIResponseStatus?
    var searchItems = [SearchModel]()
    
    
    init(dict: [String:Any]?) {
        
        totalResults = Int(dict?[JSONKey().totalResults] as? String ?? "0") ?? 0
        
        if dict?[JSONKey().response] as? String == APIResponseStatus.success.rawValue {
            response = .success
        }
        
        (dict?[JSONKey().search] as? [[String:Any]])?.forEach {
            let model = SearchModel.init(dict: $0)
            searchItems.append(model)
        }
    }
}
