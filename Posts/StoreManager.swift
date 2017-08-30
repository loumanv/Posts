//
//  StoreManager.swift
//  Posts
//
//  Created by Vasileios Loumanis on 27/08/2017.
//  Copyright © 2017 Vasileios Loumanis. All rights reserved.
//

import UIKit
import CoreData

protocol StoreManagerOutput {
    func handle(error: Error)
}

class StoreManager: NSObject {

    static let sharedInstance = StoreManager()
    var controllerOutput: StoreManagerOutput?

    // MARK: - Core Data stack

    lazy var managedObjectContext: NSManagedObjectContext = {

        return self.persistentContainer.viewContext
    }()

    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Posts")
        container.loadPersistentStores(completionHandler: { [weak self] (_, error) in
            if let error = error as NSError? {
                self?.controllerOutput?.handle(error: error)
            }
        })
        container.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        return container
    }()

    // MARK: - Core Data Saving support

    func saveContext () {
        let context = persistentContainer.viewContext

        if context.hasChanges {
            do {
                try context.save()
            } catch {
                self.controllerOutput?.handle(error: error)
            }
        }
    }
}
