//
//  String+Extention.swift
//  ItunesApp
//
//  Created by Muhammad Tafani Rabbani on 05/01/24.
//

import Foundation


//MARK: to limit the lenght of string
extension String {
    func limit(num:Int) -> String {
        var s = self
        if s.count > num + 3{
            while s.count >= num {
                s.remove(at: s.index(before: s.endIndex))
            }
            s.append("...")
        }
        return s
    }
}
