//
//  Base.swift
//  ItunesApp
//
//  Created by Muhammad Tafani Rabbani on 05/01/24.
//

import Foundation

// MARK: - init results
struct BaseResults<T:Codable>: Codable {
    let resultCount: Int
    let results: [T]
}
