//
//  Webservice.swift
//  Blog
//
//  Created by Sandesh on 29/04/20.
//  Copyright © 2020 Sandesh. All rights reserved.
//

import Foundation
import Alamofire

class Webservice: NSObject {
    static let shared = Webservice()
    func getData(with url: String, completion:@escaping (_ data: Blog?, _ error: Error?) -> Void) {
        AF.request(url).responseData { (responseData) in
            switch responseData.result {
            case .success(let data):
                //Apply string encoding as response is not UTF 8 formatted
                let string = String(decoding: data, as: UTF8.self)
                if let datastr = string.data(using: String.Encoding.utf8) {
                    //Map response data into model
                    do {
                        let blogData = try JSONDecoder().decode(Blog.self, from: datastr)
                        completion(blogData, nil)
                    } catch let error as NSError {
                        print(error)
                        completion(nil, error)
                    }
                }
            case .failure(let error):
                completion(nil, error)
            }
        }
    }
}
