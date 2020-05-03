//
//  Helper.swift
//  Blog
//
//  Created by Sandesh on 03/05/20.
//  Copyright © 2020 Sandesh. All rights reserved.
//


import Foundation
import Alamofire

func isConnectedToInternet() -> Bool {
    return NetworkReachabilityManager()!.isReachable
}

extension UIViewController {
    func showAlert(title: String, message: String) {
        let alertController = UIAlertController(title: title, message:
            message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: {_ in
        }))
        self.present(alertController, animated: true, completion: nil)
    }
}

func formatDate(date: String) -> String {
    let dateFormatterGet = DateFormatter()
    dateFormatterGet.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
    
    let dateFormatter = DateFormatter()
    dateFormatter.dateStyle = .medium
    dateFormatter.timeStyle = .none
    //    dateFormatter.locale = Locale(identifier: "en_US") //uncomment if you don't want to get the system default format.
    
    let dateObj: Date? = dateFormatterGet.date(from: date)
    
    return dateFormatter.string(from: dateObj!)
}
