//
//  PostsViewController.swift
//  Posts
//
//  Created by Vasileios Loumanis on 26/08/2017.
//  Copyright © 2017 Vasileios Loumanis. All rights reserved.
//

import UIKit

protocol PostsViewControllerOutput {
    func didSelect(post: Post, sender: PostsViewController)
}

class PostsViewController: UIViewController {

    var posts: [Post]
    var navigationBar: UINavigationController?
    var controllerOutput: PostsViewControllerOutput?

    @IBOutlet weak var table: UITableView! {
        didSet {
            table.estimatedRowHeight = 102
            table.rowHeight = UITableViewAutomaticDimension

            table.register(UINib(nibName: String(describing: PostCell.self), bundle: nil), forCellReuseIdentifier: String(describing: PostCell.self))
        }
    }

    init(posts: [Post]) {
        self.posts = posts
        super.init(nibName: String(describing: PostsViewController.self), bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationBar = UINavigationController(rootViewController: self)
        table.delegate = self
        table.dataSource = self
    }
}

extension PostsViewController: UITableViewDataSource, UITableViewDelegate {
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }

    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = table.dequeueReusableCell(withIdentifier: String(describing: PostCell.self), for: indexPath) as? PostCell else { return UITableViewCell() }
        cell.titleLabel.text = posts[indexPath.row].title
        return cell
    }

    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        controllerOutput?.didSelect(post: posts[indexPath.row], sender: self)
    }
}
