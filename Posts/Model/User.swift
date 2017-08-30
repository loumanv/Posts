//
//  User+CoreDataClass.swift
//  Posts
//
//  Created by Vasileios Loumanis on 28/08/2017.
//  Copyright © 2017 Vasileios Loumanis. All rights reserved.
//

import Foundation
import CoreData

enum UserError: LocalizedError {
    case missingName
}

@objc(User)
public class User: NSManagedObject {

    convenience init(dictionary: [String: Any], entity: NSEntityDescription = NSEntityDescription.entity(forEntityName: "User", in: StoreManager.sharedInstance.managedObjectContext)!, insertIntoManagedObjectContext context: NSManagedObjectContext! = StoreManager.sharedInstance.managedObjectContext) throws {
        self.init(entity: entity, insertInto: context)

        guard let name = dictionary["name"] as? String else { throw UserError.missingName}

        self.name = name
    }
}

extension User {
    static func parseUser(data: Any?) throws -> User? {
        guard let data = data else { throw ResponseError.jsonResponseEmpty }
        let user: User? = {
            if let userArray = data as? [Any] {
                guard let userDictionary = userArray.first as? [String : Any] else { return nil }
                return try? User(dictionary: userDictionary)
            }
            return nil
        }()
        return user
    }
}
