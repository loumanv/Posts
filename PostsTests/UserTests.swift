//
//  UserTests.swift
//  Posts
//
//  Created by Vasileios Loumanis on 26/08/2017.
//  Copyright © 2017 Vasileios Loumanis. All rights reserved.
//

import XCTest
@testable import Posts

class UserTests: XCTestCase {

    var dictionary: [String: Any]?
    var user: User?

    override func setUp() {
        super.setUp()
        dictionary = [
            "id": 1,
            "name": "Leanne Graham",
            "username": "Bret",
            "email": "Sincere@april.biz",
            "address": [
                "street": "Kulas Light",
                "suite": "Apt. 556",
                "city": "Gwenborough",
                "zipcode": "92998-3874",
                "geo": [
                    "lat": "-37.3159",
                    "lng": "81.1496"
                ]
            ],
            "phone": "1-770-736-8031 x56442",
            "website": "hildegard.org",
            "company": [
                "name": "Romaguera-Crona",
                "catchPhrase": "Multi-layered client-server neural-net",
                "bs": "harness real-time e-markets"
            ]
        ]
        user = try? User.init(dictionary: dictionary!)
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testPostInitializationSucceeds() {
        XCTAssertNotNil(user)
    }

    func testPostJsonParseSucceeds() {
        XCTAssertEqual(user?.name, "Leanne Graham")
    }
}
