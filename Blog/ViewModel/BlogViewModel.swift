//
//  BlogViewModel.swift
//  Blog
//
//  Created by Sandesh on 29/04/20.
//  Copyright © 2020 Sandesh. All rights reserved.
//

import Foundation
import UIKit

class BlogViewModel: NSObject {
 
    static func getdat(page:Int, completionHandler:@escaping (Blog?)-> Void ){
        Webservice.shared.getData(with: "https://5e99a9b1bc561b0016af3540.mockapi.io/jet2/api/v1/blogs") { (blogData, error) in
            if error != nil {
                return
            }
            guard let blogData = blogData else {return}
            completionHandler(blogData)
            //subclassing in nsopration quewq
        }
    }
    var blog: Blog?

    var numberofRows: Int {
        return blog?.count ?? 0
    }
    
    init(blog: Blog) {
        self.blog = blog
    }
}
