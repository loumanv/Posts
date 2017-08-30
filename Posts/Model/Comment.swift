//
//  Comment+CoreDataClass.swift
//  Posts
//
//  Created by Vasileios Loumanis on 28/08/2017.
//  Copyright © 2017 Vasileios Loumanis. All rights reserved.
//

import Foundation
import CoreData

enum CommentError: LocalizedError {
    case missingCommentId
    case missingName
    case missingBody
}

@objc(Comment)
public class Comment: NSManagedObject {

    convenience init(dictionary: [String: Any], entity: NSEntityDescription = NSEntityDescription.entity(forEntityName: "Comment", in: StoreManager.sharedInstance.managedObjectContext)!, insertIntoManagedObjectContext context: NSManagedObjectContext! = StoreManager.sharedInstance.managedObjectContext) throws {
        self.init(entity: entity, insertInto: context)

        guard let commentId = dictionary["id"] as? Int else { throw CommentError.missingCommentId}
        guard let name = dictionary["name"] as? String else { throw CommentError.missingName}
        guard let body = dictionary["body"] as? String else { throw CommentError.missingBody}

        self.commentId = "\(commentId)"
        self.name = name
        self.body = body
    }
}

extension Comment {
    static func parseComments(data: Any?) throws -> [Comment] {
        guard let data = data else { throw ResponseError.jsonResponseEmpty }
        let comments: [Comment] = {
            if let commentsArray = data as? [Any] {
                return commentsArray.flatMap { commentDictionary in
                    guard let commentDictionary = commentDictionary as? [String : Any] else { return nil }
                    return try? Comment(dictionary: commentDictionary) }
            }
            return [Comment]()
        }()
        return comments
    }
}
