//
//  ListViewModel.swift
//  ItunesApp
//
//  Created by Muhammad Tafani Rabbani on 05/01/24.
//

import UIKit
import Combine

protocol ListViewModelProtocol {
    func cellForRowAt(_ index: Int) -> Movie?
    func numberOfRows() -> Int
    func viewDidLoad()
    func search(term:String,lim:Int?,country:String?)
    func reset()
    func isSearch()
    func isListStyle()
    func favoriteForRowAt(_ index: Int)
}

class ListViewModel : ObservableObject,ListViewModelProtocol{
    
    
    
    @Published var movies: [Movie] = []
    @Published var localMovies: [Movie] = []
    @Published var isSearching : Bool = false
    @Published var isListStyleTable : Bool = true
    
    private var cancellables = Set<AnyCancellable>()
    private unowned let view: MainViewProtocol
    private var service = MovieService()
    
    init( view: MainViewProtocol) {
        self.view = view
        reset()
    }
    
    func cellForRowAt(_ index: Int) -> Movie? {
        if movies.count > index{
            return movies[index]
        }else{
            return nil
        }
        
    }
    
    func numberOfRows() -> Int {
        movies.count
    }
    
    func isSearch() {
        isSearching.toggle()
    }
    
    func viewDidLoad() {
        view.configureView()
        listenIsDataChange { [weak self] movies in
            guard let self = self else {return}
            self.view.reloadData()
        }
        listenIsSearching { [weak self] val in
            guard let self = self else {return}
            self.view.updateSearchbar(isSearch: val)
        }
        listenIsStyle { [weak self] val in
            guard let self = self else {return}
            self.view.updateListStyle(isSearch: val)
        }
    }
    
    func search(term:String,lim:Int? = nil,country:String? = nil){
        reset()
        service.searchMovie(term: term, country: country, limit: lim)
            .receive(on: DispatchQueue.global(qos: .background))
            .sink { completion in
                switch completion {
                case .failure(let error):
                    print(error)
                case .finished: break
                }
            } receiveValue: { [weak self] first in
                guard let self = self else {return}
                DispatchQueue.main.async {
                    UIView.animate(withDuration: 1) {
                        let res = first.results
                        
                        self.movies = res
                        self.getFavorites()
                    }
                }
            }
            .store(in: &cancellables)
    }
    
    func getFavorites(){
        let res = self.movies.reduce([]) { (result, movie) -> [Movie] in
            var updatedResult = result
            
            let arg = self.localMovies.filter({
                return $0.trackID == movie.trackID})
            
            if !arg.isEmpty{
                updatedResult.append(contentsOf: arg)
            }else{
                updatedResult.append(movie)
            }
            
            return updatedResult
        }
        self.movies = res.sorted(by: {$0.isFavorites && !$1.isFavorites})
    }
    
    func reset() {
        DispatchQueue.main.async {
            self.movies = []
            self.service.readLocal { [weak self] movies in
                self?.localMovies = movies
                self?.movies = self?.localMovies ?? []
            }
        }
    }
    func isListStyle(){
        DispatchQueue.main.async {
            UIView.animate(withDuration: 1) {
                self.isListStyleTable.toggle()
            }
        }
    }
    
    func listenIsDataChange(onListen: @escaping ([Movie])->Void){
        $movies
            .debounce(for: 0.1, scheduler: RunLoop.main)
            .removeDuplicates()
            .sink{ val in
                onListen(val)
            }
            .store(in: &cancellables)
    }
    
    func listenIsSearching(onListen: @escaping (Bool)->Void){
        $isSearching
            .debounce(for: 0.1, scheduler: RunLoop.main)
            .removeDuplicates()
            .sink{ val in
                onListen(val)
            }
            .store(in: &cancellables)
    }
    
    func listenIsStyle(onListen: @escaping (Bool)->Void){
        $isListStyleTable
            .debounce(for: 0.1, scheduler: RunLoop.main)
            .removeDuplicates()
            .sink{ val in
                
                onListen(val)
            }
            .store(in: &cancellables)
    }
    
    func reloadData(){
        
        self.movies = movies.sorted(by: {$0.isFavorites && !$1.isFavorites})
    }
    func favoriteForRowAt(_ index: Int) {
        if movies.count > index{
            movies[index].isFavorites.toggle()
            if movies[index].isFavorites{
                service.saveLocal(movie: movies[index]) { [weak self] movie in
                    guard let self else {return}
                    self.reloadData()
                }
            }else{
                service.deleteLocal(movie: movies[index]) { [weak self] val in
                    guard let self else {return}
                    self.reloadData()
                }
            }
            
            
        }
        
    }
}
