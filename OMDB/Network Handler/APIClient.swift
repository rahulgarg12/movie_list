//
//  APIClient.swift
//  OMDB
//
//  Created by Rahul Garg on 24/04/19.
//  Copyright © 2019 Rahul Garg. All rights reserved.
//

import Foundation


struct NetworkRequest {
    
    let method: HTTPMethod
    let url: String
    var queryItems: [URLQueryItem]?
    var headers: [HTTPHeader]?
    var body: Data?
    
    init(method: HTTPMethod, url: String, headers: [HTTPHeader]? = nil, bodyDict: [String:Any]? = nil) {
        self.method = method
        self.url = url
        
        if let headers = headers {
            self.headers = headers
        }
        
        if let bodyDict = bodyDict {
            self.body = try? JSONSerialization.data(withJSONObject: bodyDict)
        }
    }
    
}


struct APIClient {
    
    func perform(_ request: NetworkRequest?, _ completion: @escaping (APIResult<Data?>) -> Void) {
        
        guard let request = request,
            let url = URL(string: request.url) else {
                completion(.failure(.invalidURL))
                return
        }
        
        var urlComponents = URLComponents()
        urlComponents.scheme = url.scheme
        urlComponents.host = url.host
        urlComponents.path = url.path
        urlComponents.queryItems = request.queryItems
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = request.method.rawValue
        urlRequest.httpBody = request.body
        
        request.headers?.forEach { urlRequest.addValue($0.value, forHTTPHeaderField: $0.field) }
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
//        urlRequest.setValue("application/json", forHTTPHeaderField: "Accept")
        
        
        let task = URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
            
            guard error == nil, let httpResponse = response as? HTTPURLResponse else {
                completion(.failure(.requestFailed))
                return
            }
            
            let networkResponse = NetworkResponse<Data?>(statusCode: httpResponse.statusCode,
                                                         body: data)
            let success = APIResult.success(networkResponse)
            completion(success)
        }
        
        task.resume()
    }
}
