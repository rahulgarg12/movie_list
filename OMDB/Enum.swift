//
//  Enum.swift
//  OMDB
//
//  Created by Rahul Garg on 24/04/19.
//  Copyright © 2019 Rahul Garg. All rights reserved.
//

import Foundation

//MARK:- Network
enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"
}

enum APIError: Error {
    case invalidURL
    case requestFailed
    case decodingFailure
}

enum APIResult<Body> {
    case success(NetworkResponse<Body>)
    case failure(APIError)
}


enum APIResponseStatus: String {
    case success = "True"
}
