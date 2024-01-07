//
//  MovieService.swift
//  ItunesApp
//
//  Created by Muhammad Tafani Rabbani on 05/01/24.
//

import Foundation
import Combine
import SwiftUI

protocol MovieServiceProtocol {
    //    func searchMovie2(args:[String:String])-> AnyPublisher<MovieResults,Error>
    func searchMovie(term:String,country:String?,limit:Int?)-> AnyPublisher<BaseResults<Movie>,Error>
    func lookupMovie(amgVideoId:String) -> AnyPublisher<BaseResults<Movie>,Error>
    func saveLocal(movie:Movie,onSuccess:@escaping (Movie)->Void)
    func readLocal(onSuccess:@escaping (Movie)->Void)
}

final class MovieService : MovieServiceProtocol{
    
    
    func lookupMovie(amgVideoId: String) -> AnyPublisher<BaseResults<Movie>, Error> {
        let args : [String:String] = ["amgVideoId":amgVideoId]
        return NetworkLayer.shared.request(router: .lookup, args: args)
    }
    
    func searchMovie(term: String, country: String?, limit: Int?) -> AnyPublisher<BaseResults<Movie>, Error> {
        
        var args : [String:String] = ["term":term,"media":"movie"]
        if let country{
            args["country"] = country
        }
        if let limit{
            args["limit"] = "\(limit)"
        }
        return NetworkLayer.shared.request(router: .search, args: args)
    }
    
    func saveLocal(movie:Movie,onSuccess:@escaping (Movie)->Void){
        let helper = CoreDataHelper.shared
        helper.create(type: movie) { m in
            <#code#>
        }
    }
    
    func readLocal(onSuccess:@escaping (Movie)->Void){
//        DBManager.read(proccess: () {})
    }
}
