//
//  RequestsManager.swift
//  Posts
//
//  Created by Vasileios Loumanis on 26/08/2017.
//  Copyright © 2017 Vasileios Loumanis. All rights reserved.
//

import UIKit
import Alamofire

struct Urls {
    static let baseUrl = "https://jsonplaceholder.typicode.com"
    static let postsUrl = "/posts"
    static let usersUrl = "/users"
    static let commentsUrl = "/comments"
}

class RequestsManager: NSObject {

    static func load(url: URL, completion: @escaping ((Any?, Error?) -> Void)) {
        Alamofire.request(url).responseJSON { response in

            switch response.result {
            case .success(let data):
                completion(data, nil)

            case .failure(let error):
                completion(nil, error)
            }
        }
    }
}
