//
//  String+Extention.swift
//  ItunesApp
//
//  Created by Muhammad Tafani Rabbani on 05/01/24.
//

import Foundation

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
