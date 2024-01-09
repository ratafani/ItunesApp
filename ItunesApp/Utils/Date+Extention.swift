//
//  Date+Extention.swift
//  ItunesApp
//
//  Created by Muhammad Tafani Rabbani on 09/01/24.
//

import Foundation


//MARK: to have date format for header last visit
extension Date {
    func formattedString() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "d'ᵗʰ' MMMM yyyy : HH:mm"
        formatter.locale = Locale(identifier: "en_US_POSIX")
        return formatter.string(from: self)
    }
}
