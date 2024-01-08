//
//  DetailViewModel.swift
//  ItunesApp
//
//  Created by Muhammad Tafani Rabbani on 08/01/24.
//

import Foundation
import Combine

protocol DetailViewModelProtocol{
    func listenToMovie(onListen: @escaping (Movie)->Void)
    func favorite()
    func reloadData()
    func getMovie()->Movie?
    func viewDidLoad()
}

class DetailViewModel : ObservableObject,DetailViewModelProtocol{
    @Published var moviePublisher : Movie?
    private var cancellables = Set<AnyCancellable>()
    private var service = MovieService()
    
    var view : DetailViewControllerProtocol
    
    init(movie:Movie, view: DetailViewControllerProtocol){
        self.moviePublisher = movie
        self.view = view
    }
    
    func viewDidLoad() {
        listenToMovie { [weak self] movie in
            guard let self else {return}
            self.view.updateUI()
        }
    }
    
    func listenToMovie(onListen: @escaping (Movie)->Void){
        $moviePublisher
            .debounce(for: 0.1, scheduler: RunLoop.main)
            .removeDuplicates()
            .sink{ val in
                if let m = val {
                    onListen(m)
                }
            }
            .store(in: &cancellables)
    }
    
    func favorite(){
        moviePublisher?.isFavorites.toggle()
        guard let movie = moviePublisher else {return}
        if movie.isFavorites{
            service.saveLocal(movie: movie) { [weak self] m in
                guard let self else {return}
                self.view.updateUI()
            }
        }else{
            service.deleteLocal(movie: movie) { [weak self] val in
                guard let self else {return}
                self.view.updateUI()
            }
        }
    }
    
    func reloadData(){
        self.view.updateUI()
    }
    
    func getMovie()->Movie?{
        return moviePublisher
    }
}
