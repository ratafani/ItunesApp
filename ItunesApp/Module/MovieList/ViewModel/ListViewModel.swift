//
//  ListViewModel.swift
//  ItunesApp
//
//  Created by Muhammad Tafani Rabbani on 05/01/24.
//

import UIKit
import Combine

protocol ListViewModelProtocol {
    func cellForRowAt(_ index: Int,isFavorite: Bool) -> Movie?
    func numberOfRows(isFavorite:Bool) -> Int
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
    //MARK: - only observing through protocols
    private unowned let view: MainViewProtocol
    
    private var service = MovieService()
    
    init( view: MainViewProtocol) {
        self.view = view
        reset()
    }
    //MARK: - to get movie from indexpath
    func cellForRowAt(_ index: Int,isFavorite: Bool) -> Movie? {
        if isFavorite{
            if localMovies.count > index{
                return localMovies[index]
            }else{
                return nil
            }
        }else{
            if movies.count > index{
                return movies[index]
            }else{
                return nil
            }
        }
        
    }
    
    //MARK: - getting the number of movie available both in local or from API
    // isfavorite shows if we are looking from coredata or from API Research
    func numberOfRows(isFavorite:Bool) -> Int {
        if isFavorite{
            return localMovies.count
        }else{
            return movies.count
        }
    }
    
    func isSearch() {
        isSearching.toggle()
    }
    
    func viewDidLoad() {
        view.configureView()
        readLocalDB()
        
        
        //MARK: - listening to publisher and update data if any
        listenIsDataChange { [weak self] movies in
            guard let self = self else {return}
            self.view.reloadData()
        }
        
        listenIsLocalDataChange { [weak self] movies in
            guard let self = self else {return}
            self.view.reloadData()
        }
        
        //MARK: - search bar update if hidden or active
        listenIsSearching { [weak self] val in
            guard let self = self else {return}
            self.view.updateSearchbar(isSearch: val)
        }
        //MARK: - observe the active layout style for the search result
        // its eather table style or 2 column style
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
    
    //MARK: - get favorites from the search result from the api to the local data
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
        }
    }
    
    //MARK: - change the style layout
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
    
    func listenIsLocalDataChange(onListen: @escaping ([Movie])->Void){
        $localMovies
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
    
    //MARK: -read the Coredata and update the UI
    func readLocalDB(){
        self.service.readLocal { [weak self] movies in
            self?.localMovies = movies
            self?.getFavorites()
        }
        
    }
    
    //MARK: - function to favorite based on selected movie
    func favoriteForRowAt(_ movie: Movie){
        guard let index = findMovie(movie: movie) else {return}
        if movies.count > index{
            movies[index].isFavorites.toggle()
            if movies[index].isFavorites{
                service.saveLocal(movie: movies[index]) { [weak self] success in
                    guard let self else {return}
                    
                    self.readLocalDB()
                }
            }else{
                service.deleteLocal(movie: movies[index]) { [weak self] val in
                    guard let self else {return}
                    
                    self.readLocalDB()
                }
            }
        }
    }
    
    //MARK: - looking for movie in API result
    func findMovie(movie: Movie) -> Int?{
        let m = self.movies.firstIndex(where: {$0.id == movie.id})
        let index = m ?? 0
        return index
    }
    
    //MARK: - logic to calculate the cell size based on active collection layout
    func cellSize() -> (CGFloat,String) {
        switch layoutStyle {
        case .table:
            return (view.getViewFrame() * 0.96,"Small")
        case .twoGrid:
            return (view.getViewFrame() / 2 - 10 ,"Large")
        }
    }
    
    
    //MARK: - to update the conncetion when collectionview is tapped
    func changeListMovie(by movie: Movie) {
        let arr = self.movies.map({$0.id == movie.id ? movie : $0})
        self.movies = arr
        readLocalDB()
    }
}
