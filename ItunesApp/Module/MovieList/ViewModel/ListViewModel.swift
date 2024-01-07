//
//  ListViewModel.swift
//  ItunesApp
//
//  Created by Muhammad Tafani Rabbani on 05/01/24.
//

import UIKit
import Combine

protocol ListViewModelProtocol {
    func cellForRowAt(_ index: Int) -> Movie
    func numberOfRows() -> Int
    func viewDidLoad()
    func search(term:String,lim:Int?,country:String?)
    func reset()
    func isSearch()
    func isListStyle()
}

class ListViewModel : ObservableObject,ListViewModelProtocol{
    
    @Published var movies: [Movie] = []
    @Published var isSearching : Bool = false
    @Published var isListStyleTable : Bool = true
    
    private var cancellables = Set<AnyCancellable>()
    private unowned let view: MainViewProtocol
    private var service = MovieService()
    
    init( view: MainViewProtocol) {
        self.view = view
    }
    
    func cellForRowAt(_ index: Int) -> Movie {
        movies[index]
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
                        self.movies = first.results
                    }
                }
            }
            .store(in: &cancellables)
    }
    
    
    func reset() {
        DispatchQueue.main.async {
            UIView.animate(withDuration: 1) {
                self.movies = []
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
}
