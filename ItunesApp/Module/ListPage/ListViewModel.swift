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
}

class ListViewModel : ObservableObject,ListViewModelProtocol{
    
    
    
    @Published var movies: [Movie] = []
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
    
    func viewDidLoad() {
        view.configureTableView()
        listenIsDataChange { [weak self] movies in
            guard let self = self else {return}
            self.view.reloadData()
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
    
    func listenIsDataChange(onListen: @escaping ([Movie])->Void){
        $movies
            .debounce(for: 0.1, scheduler: RunLoop.main)
            .removeDuplicates()
            .sink{ val in
                onListen(val)
            }
            .store(in: &cancellables)
    }
}
