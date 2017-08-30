//
//  PostTests.swift
//  PostsTests
//
//  Created by Vasileios Loumanis on 26/08/2017.
//  Copyright © 2017 Vasileios Loumanis. All rights reserved.
//

import XCTest
@testable import Posts

class PostTests: XCTestCase {

    var dictionary: [String: Any]?
    var post: Post?

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        dictionary = [
            "userId": 1,
            "id": 1,
            "title": "sunt aut facere repellat provident occaecati excepturi optio reprehenderit",
            "body": "quia et suscipit\nsuscipit recusandae consequuntur expedita et cum\nreprehenderit molestiae ut ut quas totam\nnostrum rerum est autem sunt rem eveniet architecto"
        ]
        post = try? Post.init(dictionary: dictionary!)
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testPostInitializationSucceeds() {
        XCTAssertNotNil(post)
    }

    func testPostJsonParseSucceeds() {
        XCTAssertEqual(post?.userId, 1)
        XCTAssertEqual(post?.postId, "1")
        XCTAssertEqual(post?.title, "sunt aut facere repellat provident occaecati excepturi optio reprehenderit")
        XCTAssertEqual(post?.body, "quia et suscipit\nsuscipit recusandae consequuntur expedita et cum\nreprehenderit molestiae ut ut quas totam\nnostrum rerum est autem sunt rem eveniet architecto")
    }
}
