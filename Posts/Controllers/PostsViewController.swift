//
//  PostsViewController.swift
//  Posts
//
//  Created by Vasileios Loumanis on 26/08/2017.
//  Copyright © 2017 Vasileios Loumanis. All rights reserved.
//

import UIKit

protocol PostsViewControllerOutput {
    func didSelectRowAction(sender: UIViewController, selectedPost: Post)
}

class PostsViewController: UIViewController {

    var viewModel: PostsViewModel
    var controllerOutput: PostsViewControllerOutput?

    @IBOutlet weak var table: UITableView! {
        didSet {
            table.estimatedRowHeight = 102
            table.rowHeight = UITableViewAutomaticDimension

            table.register(UINib(nibName: String(describing: PostCell.self), bundle: nil), forCellReuseIdentifier: String(describing: PostCell.self))
        }
    }
    let activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView.init(activityIndicatorStyle: .gray)

    init(viewModel: PostsViewModel) {
        self.viewModel = viewModel
        super.init(nibName: String(describing: PostsViewController.self), bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.controllerOutput = self
        table.delegate = self
        table.dataSource = self
        addNavigationItems()
    }

    func reload() {
        viewModel.loadPosts()
    }

    func addNavigationItems() {
        let activityBarButton = UIBarButtonItem(customView: activityIndicator)
        navigationItem.rightBarButtonItem  = activityBarButton
        activityIndicator.startAnimating()
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Reload", style: .plain, target: self, action: #selector(reload))
    }

    func showErrorMessage(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        let action = UIAlertAction(title: "Ok", style: .default, handler: nil)
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
}

extension PostsViewController: UITableViewDataSource, UITableViewDelegate {

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        guard let section = PostSection(rawValue: section), let firstPost = viewModel.posts?.first else { return "" }
        return section.sectionTitle(post: firstPost)
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.posts?.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let posts = viewModel.posts else { return UITableViewCell() }
        guard let cell = table.dequeueReusableCell(withIdentifier: String(describing: PostCell.self), for: indexPath) as? PostCell else { return UITableViewCell() }
        cell.titleLabel.text = posts[indexPath.row].title
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let posts = viewModel.posts else { return }
        controllerOutput?.didSelectRowAction(sender: self, selectedPost:  posts[indexPath.row])
    }
}

extension PostsViewController: PostsViewModelOutput {
    func postsFetched() {
        table.reloadData()
    }

    func handle(error: Error) {
        showErrorMessage(title: "An Error Occurred", message: error.localizedDescription)
    }

    func isPerformingRequest(_ isPerformingRequest: Bool) {
        isPerformingRequest ? activityIndicator.startAnimating() : activityIndicator.stopAnimating()
    }
}
