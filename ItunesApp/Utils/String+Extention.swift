//
//  String+Extention.swift
//  ItunesApp
//
//  Created by Muhammad Tafani Rabbani on 05/01/24.
//

import Foundation

extension String {
    func limit(num:Int) -> String {
        if self.count>num{
            return dropLast(num) + "***"
        }
        return self
    }
}
