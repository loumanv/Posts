//
//  AppNavigationController.swift
//  Posts
//
//  Created by Vasileios Loumanis on 30/08/2017.
//  Copyright © 2017 Vasileios Loumanis. All rights reserved.
//

import UIKit

class AppNavigationController {

    static let sharedInstance = AppNavigationController()

    lazy var navigationController: UINavigationController = {
        let postsVC = PostsViewController(viewModel: PostsViewModel())
        postsVC.controllerOutput = self
        return UINavigationController(rootViewController: postsVC)
    }()
}

extension AppNavigationController: PostsViewControllerOutput {
    func didSelectRowAction(sender: UIViewController, selectedPost: Post) {
        let postDetailVC = PostDetailViewController(viewModel: PostDetailViewModel(post: selectedPost))
        navigationController.pushViewController(postDetailVC, animated: true)
    }
}
