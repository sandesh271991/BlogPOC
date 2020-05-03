//
//  Double+Extension.swift
//  Blog
//
//  Created by Sandesh on 03/05/20.
//  Copyright © 2020 Sandesh. All rights reserved.
//

import Foundation


extension Double {
    var kmFormatted: String {
        
        if self >= 10000, self <= 999999 {
            return String(format: "%.1fK", locale: Locale.current,self/1000).replacingOccurrences(of: ".0", with: "")
        }
        
        if self > 999999 {
            return String(format: "%.1fM", locale: Locale.current,self/1000000).replacingOccurrences(of: ".0", with: "")
        }
        
        return String(format: "%.0f", locale: Locale.current,self)
    }
}

