//
//  MovieService.swift
//  ItunesApp
//
//  Created by Muhammad Tafani Rabbani on 05/01/24.
//

import Foundation
import Combine
import CoreData

protocol MovieServiceProtocol {
    func searchMovie(term:String,country:String?,limit:Int?)-> AnyPublisher<BaseResults<Movie>,Error>
    func lookupMovie(amgVideoId:String) -> AnyPublisher<BaseResults<Movie>,Error>
    func saveLocal(movie:Movie,onSuccess:@escaping (Movie)->Void)
    func readLocal(onSuccess:@escaping ([Movie])->Void)
    func deleteLocal(movie:Movie,onSuccess:@escaping (Bool)->Void)
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
        CoreDataHelper.shared.create(type: MovieEntity.self) { (new: MovieEntity) in
            new.update(with: movie)
        }

    }
    
    func readLocal(onSuccess:@escaping ([Movie])->Void){
        CoreDataHelper.shared.fetch(type: MovieEntity.self, predicate: nil) { movies in
            guard let movies = movies else {
                onSuccess([])
                return
            }
            onSuccess( movies.reduce([]) { (result, movieEntity) -> [Movie] in
                var updatedResult = result
                updatedResult.append(movieEntity.createMovie())
                return updatedResult
            })
            
        }
    }
    
    func deleteLocal(movie:Movie,onSuccess:@escaping (Bool)->Void){
        do{
            let obj =  try CoreDataHelper.shared.getContext().existingObject(with: movie.id)
            CoreDataHelper.shared.delete(object: obj) { val in
                onSuccess(val)
            }
        }catch{
            
        }
    }
}
