//
//  PostDetailViewController.swift
//  Posts
//
//  Created by Vasileios Loumanis on 26/08/2017.
//  Copyright © 2017 Vasileios Loumanis. All rights reserved.
//

import UIKit

class PostDetailViewController: UIViewController {

    var viewModel: PostDetailViewModel

    @IBOutlet weak var table: UITableView! {
        didSet {
            table.estimatedRowHeight = 102
            table.rowHeight = UITableViewAutomaticDimension

            table.register(UINib(nibName: String(describing: TitleDetailCell.self), bundle: nil), forCellReuseIdentifier: String(describing: TitleDetailCell.self))
        }
    }
    let activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView.init(activityIndicatorStyle: .gray)

    init(viewModel: PostDetailViewModel) {
        self.viewModel = viewModel
        super.init(nibName: String(describing: PostDetailViewController.self), bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.controllerOutput = self
        table.dataSource = self
        addNavigationItems()
    }

    func addNavigationItems() {
        let activityBarButton = UIBarButtonItem(customView: activityIndicator)
        navigationItem.rightBarButtonItem  = activityBarButton
        activityIndicator.startAnimating()
    }

    func showErrorMessage(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        let action = UIAlertAction(title: "Ok", style: .default, handler: nil)
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
}

extension PostDetailViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return PostDetailSection.count
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        guard let section = PostDetailSection(rawValue: section) else { return "" }
        return section.sectionTitle()
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let section = PostDetailSection(rawValue: section), viewModel.post.user != nil else { return 0 }

        switch section {
        case .post:
            return 1
        case .comments:
            return viewModel.comments?.count ?? 0
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        guard let section = PostDetailSection(rawValue: indexPath.section) else { return UITableViewCell() }
        guard let cell = table.dequeueReusableCell(withIdentifier: String(describing: TitleDetailCell.self), for: indexPath) as? TitleDetailCell else { return UITableViewCell() }

        switch section {
        case .post:
            guard let author = viewModel.post.user else { return UITableViewCell() }
            cell.title.text = author.name
            cell.detail.text = viewModel.post.body
            return cell
        case .comments:
            guard let comment = viewModel.comments?[indexPath.row] else { return UITableViewCell() }
            cell.title.text = comment.name
            cell.detail.text = comment.body
            return cell
        }
    }
}

extension PostDetailViewController: PostDetailViewModelOutput {
    func userAndCommentsFetched() {
        table.reloadData()
    }

    func handle(error: Error) {
        showErrorMessage(title: "An Error Occurred", message: error.localizedDescription)
    }

    func isPerformingRequest(_ isPerformingRequest: Bool) {
        isPerformingRequest ? activityIndicator.startAnimating() : activityIndicator.stopAnimating()
    }
}
