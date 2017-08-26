//
//  AppController.swift
//  Posts
//
//  Created by Billybatigol on 26/08/2017.
//  Copyright © 2017 Vasileios Loumanis. All rights reserved.
//

import UIKit

enum AppControllerError: LocalizedError {
    case jsonResponseEmpty
}

class AppController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        loadPosts()
    }
    
    func loadPosts() {
        RequestsManager.load(url: URL(string: Urls.baseUrl + Urls.postsUrl)!) { [weak self] (data, error) in
            if error != nil {
                self?.showErrorMessage(title: "Request Error", message: error.debugDescription)
                return
            }
            
            guard let parsedPosts = try? self?.parsePosts(data: data), let posts = parsedPosts else {
                self?.showErrorMessage(title: "Post Parsing Error", message: "")
                return
            }
            let postsVC = PostsViewController(posts: posts)
            postsVC.modalTransitionStyle = .crossDissolve
            self?.present(postsVC, animated: true, completion: nil)
        }
    }

    func parsePosts(data: Any?) throws -> [Post] {
        guard let data = data else { throw AppControllerError.jsonResponseEmpty }
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

    func showErrorMessage(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        let action = UIAlertAction(title: "Ok", style: .default, handler: nil)
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
}
