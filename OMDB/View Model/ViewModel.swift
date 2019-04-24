//
//  ViewModel.swift
//  OMDB
//
//  Created by Rahul Garg on 24/04/19.
//  Copyright © 2019 Rahul Garg. All rights reserved.
//

import Foundation

class ViewModel {
    
    var page = 1
    
    var isSearchApiInProgress = false
    
    var result: ResultModel?
    
    
    //MARK: Helper Methods
    func fetchData(completion: @escaping (_ isSuccess: Bool, _ dataDict: [String:Any]?) -> ()) {
        
        let url = APIList().omdbApi
            + "?\(JSONKey().apiKey)=\(ProjectConstants().apiKey)"
            + "&\(JSONKey().page)=\(page)"
            + "&\(JSONKey().searchKey)=\(JSONKey().searchText)"
        
        let request = NetworkRequest(method: .post,
                                     url: url)
        initiateNetwork(request: request) { (success, fetchedData) in
            
            completion(success, fetchedData)
        }
    }
}


//MARK:- Private Helpers
extension ViewModel {
    
    private func initiateNetwork(request: NetworkRequest, completion: @escaping (_ isSuccess: Bool, _ dataDict: [String:Any]?) -> ()) {
        
        APIClient().perform(request) { (result) in
            
            switch result {
            case .success(let response):
                do {
                    guard let body = response.body,
                        let dict = try JSONSerialization.jsonObject(with: body, options: []) as? [String:Any]
                        else {
                            completion(false, nil)
                            return
                    }
                    
                    completion(true, dict)
                    
                } catch let error {
                    print("Failed to decode response with error \(error)")
                    completion(false, nil)
                }
                
            case .failure:
                print("Error performing network request")
                completion(false, nil)
            }
        }
    }
}
