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
    
    let network : NetworkLayer = NetworkLayer()
    
    //MARK: get spesific movie from id
    func lookupMovie(amgVideoId: String) -> AnyPublisher<BaseResults<Movie>, Error> {
        let args : [String:String] = ["amgVideoId":amgVideoId]
        return network.request(router: .lookup, args: args)
    }
    
    //MARK: search movies from with possibility based on country
    func searchMovie(term: String, country: String?, limit: Int?) -> AnyPublisher<BaseResults<Movie>, Error> {
        
        var args : [String:String] = ["term":term,"media":"movie"]
        if let country{
            args["country"] = country
        }
        if let limit{
            args["limit"] = "\(limit)"
        }
        return network.request(router: .search, args: args)
    }
    
    //MARK: save it to coredata
    func saveLocal(movie:Movie,onSuccess:@escaping (Movie)->Void){
        CoreDataHelper.shared.create(type: MovieEntity.self) { (new: MovieEntity) in
            //MARK: create entity model based on movie obj
            new.update(with: movie)
        } completion: { m in
            onSuccess(m.createMovie())
        }
    }
    
    //MARK: get all fav movie from coredata
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
    
    //MARK: delete movie from coredata
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
