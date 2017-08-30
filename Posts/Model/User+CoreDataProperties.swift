//
//  User+CoreDataProperties.swift
//  Posts
//
//  Created by Vasileios Loumanis on 28/08/2017.
//  Copyright © 2017 Vasileios Loumanis. All rights reserved.
//

import Foundation
import CoreData

extension User {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<User> {
        return NSFetchRequest<User>(entityName: "User")
    }

    @NSManaged public var name: String

}
