//
//  CommentTests.swift
//  Posts
//
//  Created by Vasileios Loumanis on 26/08/2017.
//  Copyright © 2017 Vasileios Loumanis. All rights reserved.
//

import XCTest
@testable import Posts

class CommentTests: XCTestCase {

    var dictionary: [String: Any]?
    var comment: Comment?

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        dictionary = [
            "postId": 1,
            "id": 1,
            "name": "id labore ex et quam laborum",
            "email": "Eliseo@gardner.biz",
            "body": "laudantium enim quasi est quidem magnam voluptate ipsam eos\ntempora quo necessitatibus\ndolor quam autem quasi\nreiciendis et nam sapiente accusantium"
        ]
        comment = try? Comment.init(dictionary: dictionary!)
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testPostInitializationSucceeds() {
        XCTAssertNotNil(comment)
    }

    func testPostJsonParseSucceeds() {
        XCTAssertEqual(comment?.commentId, "1")
        XCTAssertEqual(comment?.name, "id labore ex et quam laborum")
        XCTAssertEqual(comment?.body, "laudantium enim quasi est quidem magnam voluptate ipsam eos\ntempora quo necessitatibus\ndolor quam autem quasi\nreiciendis et nam sapiente accusantium")
    }
}
