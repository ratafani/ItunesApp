//
//  Routes.swift
//  uikit_viper_combine_try
//
//  Created by Muhammad Tafani Rabbani on 03/01/24.
//

import Foundation

enum NetworkRoutes{
    case search
    case lookup
    
    var scheme: String {
        return "https"
    }
    
    var host: String {
        return "itunes.apple.com"
    }
    
    var path: String{
        switch self {
        case .search:
            return "/search"
        case .lookup:
            return "/lookup"
        }
    }
    
    
    func pageQuery(parameter : [String:String]) -> [URLQueryItem] {
        
        var queries = [URLQueryItem]()
        parameter.forEach { key,value in
            queries.append(URLQueryItem(name: key, value: value))
        }
        return queries
    }
}

enum MediaType : String{
    case movie
    case podcast
    case music
    case musicVideo
    case audiobook
    case shotFilm
    case tvShow
    case software
    case ebook
}
