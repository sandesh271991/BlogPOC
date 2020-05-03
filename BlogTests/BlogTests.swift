//
//  BlogTests.swift
//  BlogTests
//
//  Created by Sandesh on 28/04/20.
//  Copyright © 2020 Sandesh. All rights reserved.
//

import XCTest
@testable import Blog

class BlogTests: XCTestCase {
    
    var blogDataModel: Blog!
    var blogViewModel: BlogViewModel!

    override func setUp() {
        blogDataModel = Blog(arrayLiteral: BlogElement(id: "", createdAt: "", content: "", comments: 2, likes: 2, media: [], user: []))
             
        blogViewModel = BlogViewModel(blog: blogDataModel)
        
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

    
    func testInitializationWithModel() {
    
        XCTAssertNotNil(blogViewModel, "Blog View model should not be nil")
    
        XCTAssertTrue(blogViewModel.blog!.count > 0, "Blogs should not be empty" )
        XCTAssertTrue(blogViewModel.blog?.count == blogDataModel.count, "Blogs array count in viewmodel should be equal to datamodel" )

    }
}
