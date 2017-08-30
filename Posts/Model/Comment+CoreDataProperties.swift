//
//  Comment+CoreDataProperties.swift
//  Posts
//
//  Created by Vasileios Loumanis on 28/08/2017.
//  Copyright © 2017 Vasileios Loumanis. All rights reserved.
//

import Foundation
import CoreData

extension Comment {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Comment> {
        return NSFetchRequest<Comment>(entityName: "Comment")
    }

    @NSManaged public var commentId: String
    @NSManaged public var name: String
    @NSManaged public var body: String

}
