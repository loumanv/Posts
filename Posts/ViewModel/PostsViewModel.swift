//
//  PostsViewModel.swift
//  Posts
//
//  Created by Vasileios Loumanis on 26/08/2017.
//  Copyright © 2017 Vasileios Loumanis. All rights reserved.
//

import UIKit
import CoreData

protocol PostsViewModelOutput {
    func postsFetched()
    func handle(error: Error)
    func isPerformingRequest(_: Bool)
}

class PostsViewModel {

    var posts: [Post]?
    var storeManager = StoreManager.sharedInstance
    var controllerOutput: PostsViewModelOutput?

    lazy var fetchedResultsController: NSFetchedResultsController = { () -> NSFetchedResultsController<Post> in
        let fetchRequest = NSFetchRequest<Post>(entityName: "Post")

        let sortDescriptor = NSSortDescriptor(key: "postId", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]

        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: StoreManager.sharedInstance.managedObjectContext, sectionNameKeyPath: nil, cacheName: nil)

        return fetchedResultsController
    }()

    init() {
        storeManager.controllerOutput = self
        loadPosts()
    }

    func loadPosts() {
        fetchFromPersistantStorage()
        controllerOutput?.isPerformingRequest(true)
        RequestsManager.load(url: URL(string: Urls.baseUrl + Urls.postsUrl)!) { [weak self] (data, error) in

            self?.controllerOutput?.isPerformingRequest(false)
            guard error == nil, let posts = try? Post.parsePosts(data: data) else {
                self?.controllerOutput?.handle(error: ResponseError.jsonResponseEmpty)
                return
            }
            self?.posts = posts
            StoreManager.sharedInstance.saveContext()
            self?.fetchFromPersistantStorage()
        }
    }

    func fetchFromPersistantStorage() {
        do {
            try fetchedResultsController.performFetch()
        } catch {
            let fetchError = error as NSError
            print("\(fetchError), \(fetchError.userInfo)")
        }
        posts = fetchedResultsController.fetchedObjects
        controllerOutput?.postsFetched()
    }
}

extension PostsViewModel: StoreManagerOutput {
    func handle(error: Error) {
        controllerOutput?.handle(error: error)
    }
}