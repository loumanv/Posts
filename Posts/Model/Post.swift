//
//  Post.swift
//  Posts
//
//  Created by Vasileios Loumanis on 26/08/2017.
//  Copyright © 2017 Vasileios Loumanis. All rights reserved.
//

import UIKit

enum PostError: LocalizedError {
    case missingUserId
    case missingId
    case missingTitle
    case missingBody
}

class Post {

    var userId: Int
    var postId: Int
    var title: String
    var body: String

    init(dictionary: [String: Any]) throws {

        guard let userId = dictionary["userId"] as? Int else { throw PostError.missingUserId}
        guard let postId = dictionary["id"] as? Int else { throw PostError.missingId}
        guard let title = dictionary["title"] as? String else { throw PostError.missingTitle}
        guard let body = dictionary["body"] as? String else { throw PostError.missingBody}

        self.userId = userId
        self.postId = postId
        self.title = title
        self.body = body
    }

}
