//
//  Post+CoreDataClass.swift
//  Posts
//
//  Created by Vasileios Loumanis on 28/08/2017.
//  Copyright © 2017 Vasileios Loumanis. All rights reserved.
//

import Foundation
import CoreData

enum PostError: LocalizedError {
    case missingUserId
    case missingId
    case missingTitle
    case missingBody
}

@objc(Post)
public class Post: NSManagedObject {

    convenience init(dictionary: [String: Any], entity: NSEntityDescription = NSEntityDescription.entity(forEntityName: "Post", in: StoreManager.sharedInstance.managedObjectContext)!, insertIntoManagedObjectContext context: NSManagedObjectContext! = StoreManager.sharedInstance.managedObjectContext) throws {
        self.init(entity: entity, insertInto: context)

        guard let userId = dictionary["userId"] as? Int else { throw PostError.missingUserId}
        guard let postId = dictionary["id"] as? Int else { throw PostError.missingId}
        guard let title = dictionary["title"] as? String else { throw PostError.missingTitle}
        guard let body = dictionary["body"] as? String else { throw PostError.missingBody}

        self.userId = Int32(userId)
        self.postId = "\(postId)"
        self.title = title
        self.body = body
    }
}

extension Post {
    static func parsePosts(data: Any?) throws -> [Post] {
        guard let data = data else { throw ResponseError.jsonResponseEmpty }
        let posts: [Post] = {
            if let postsArray = data as? [Any] {
                return postsArray.flatMap { postDictionary in
                    guard let postDictionary = postDictionary as? [String : Any] else { return nil }
                    return try? Post(dictionary: postDictionary) }
            }
            return [Post]()
        }()
        return posts
    }
}
