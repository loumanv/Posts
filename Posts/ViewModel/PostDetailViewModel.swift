//
//  PostDetailViewModel.swift
//  Posts
//
//  Created by Vasileios Loumanis on 26/08/2017.
//  Copyright © 2017 Vasileios Loumanis. All rights reserved.
//

import UIKit

protocol PostDetailViewModelOutput {
    func userAndCommentsFetched()
    func handle(error: Error)
    func isPerformingRequest(_: Bool)
}

enum PostDetailSection: Int {
    case post, comments
    static let count = 2

    static let sectionTitles = [
        post: "Post",
        comments: "Comments"
    ]

    func sectionTitle() -> String {
        if let sectionTitle = PostDetailSection.sectionTitles[self] {
            return sectionTitle
        } else {
            return ""
        }
    }
}

class PostDetailViewModel {

    var post: Post
    var storeManager = StoreManager.sharedInstance
    var controllerOutput: PostDetailViewModelOutput?

    let dispatchGroup = DispatchGroup()
    var loadUserError: Error?
    var loadCommentsError: Error?
    var userResponse: Any?
    var commentsResponse: Any?
    var comments: [Comment]? {
        guard let commentsSet = post.comments else { return nil }
        return commentsSet.allObjects as? [Comment]
    }

    init(post: Post) {
        self.post = post
        storeManager.controllerOutput = self
        load()
    }

    func load() {
        controllerOutput?.isPerformingRequest(true)
        loadUser(of: post)
        loadComments(of: post)
        dispatchGroup.notify(queue: DispatchQueue.main) { [weak self] in
            self?.controllerOutput?.isPerformingRequest(false)
            if self?.loadUserError != nil || self?.loadCommentsError != nil {
                self?.controllerOutput?.handle(error: ResponseError.connection)
                return
            }
            guard let user = try? User.parseUser(data: self?.userResponse),
                let comments = try? Comment.parseComments(data: self?.commentsResponse) else {
                    self?.controllerOutput?.handle(error: ResponseError.jsonResponseEmpty)
                    return
            }
            self?.post.user = user
            for comment in comments {
                if (self?.comments?.contains { $0.commentId == comment.commentId }) == false {
                    self?.post.addToComments(comment)
                }
            }
            StoreManager.sharedInstance.saveContext()
            self?.controllerOutput?.userAndCommentsFetched()
        }
    }

    func loadUser(of post: Post) {
        dispatchGroup.enter()
        RequestsManager.load(url: URL(string: Urls.baseUrl + Urls.usersUrl + "?id=\(post.userId)")!) { [weak self] (data, error) in
            self?.loadUserError = error
            self?.userResponse = data
            self?.dispatchGroup.leave()
        }
    }

    func loadComments(of post: Post) {
        dispatchGroup.enter()
        RequestsManager.load(url: URL(string: Urls.baseUrl + Urls.commentsUrl + "?postId=\(post.postId)")!) { [weak self] (data, error) in
            self?.loadCommentsError = error
            self?.commentsResponse = data
            self?.dispatchGroup.leave()
        }
    }
}

extension PostDetailViewModel: StoreManagerOutput {
    func handle(error: Error) {
        controllerOutput?.handle(error: error)
    }
}
