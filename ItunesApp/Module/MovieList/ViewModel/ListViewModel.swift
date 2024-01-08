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
    func changeListStyle()
    func favoriteForRowAt(_ movie: Movie)
    func cellSize()->(CGFloat,String)
    func changeListMovie(by movie:Movie)
}

enum ListLayoutStyle{
    case table
    case twoGrid
}

class ListViewModel : ObservableObject,ListViewModelProtocol{
    
    
    
    @Published var movies: [Movie] = []
    @Published var localMovies: [Movie] = []
    @Published var isSearching : Bool = false
    @Published var layoutStyle : ListLayoutStyle = .twoGrid
    
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
            self.view.updateListStyle(layout: val)
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
    
    
    func changeListStyle(){
        DispatchQueue.main.async {
            switch self.layoutStyle {
            case .table:
                self.layoutStyle = .twoGrid
            case .twoGrid:
                self.layoutStyle = .table
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
    
    func listenIsStyle(onListen: @escaping (ListLayoutStyle)->Void){
        $layoutStyle
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
    
    func favoriteForRowAt(_ movie: Movie){
        guard let index = findMovie(movie: movie) else {return}
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
    
    func findMovie(movie: Movie) -> Int?{
        let m = self.movies.firstIndex(where: {$0.id == movie.id})
        let index = m ?? 0
        return index
    }
    
    func cellSize() -> (CGFloat,String) {
        switch layoutStyle {
        case .table:
            return (view.getViewFrame() * 0.96,"Small")
        case .twoGrid:
            return (view.getViewFrame() / 2.255 ,"Large")
        }
    }
    
    func changeListMovie(by movie: Movie) {
        let arr = self.movies.map({$0.id == movie.id ? movie : $0})
        self.movies = arr
    }
}
