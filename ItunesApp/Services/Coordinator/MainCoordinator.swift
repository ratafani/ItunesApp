//
//  MainCoordinator.swift
//  ItunesApp
//
//  Created by Muhammad Tafani Rabbani on 08/01/24.
//

import Foundation
import UIKit

protocol Coordinator{
    var childCoordinator: [Coordinator] { get }
    var navigationController : UINavigationController { get }
    
    func startCoordinator()
}

class MainCoordinator : Coordinator{
    var childCoordinator: [Coordinator] = []
    
    
    var navigationController: UINavigationController = {
        var controller = UINavigationController()
        controller.navigationBar.prefersLargeTitles = false
        let navBarAppearance = UINavigationBarAppearance()
        navBarAppearance.configureWithOpaqueBackground()
        navBarAppearance.backgroundColor = UIColor.red
        controller.navigationBar.standardAppearance = navBarAppearance
        controller.navigationBar.scrollEdgeAppearance = navBarAppearance
        controller.navigationBar.tintColor = .black
        return controller
        
    }()
    
    func startCoordinator() {
        let mainVC = ViewControllerProvider.mainViewController.raw as! ViewController
        mainVC.coordinator = self
        navigationController.pushViewController(mainVC, animated: false)
    }

    func showDetail(movie : Movie,onListen: @escaping (Movie)->Void){
        let detailVC = ViewControllerProvider.detailViewController(movie: movie).raw as! DetailViewController
        
        detailVC.viewModel?.listenToMovie{ m in
            onListen(m)
        }
        navigationController.pushViewController(detailVC, animated: true)
    }
}


enum ViewControllerProvider {
    case mainViewController
    case detailViewController(movie:Movie)
    
    var raw: UIViewController {
        
        switch self {
        case .mainViewController:
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(identifier: "ListViewController") as! ViewController
            let viewmodel = ListViewModel(view: vc)
            vc.viewmodel = viewmodel
            return vc
        case .detailViewController(let movie):
            let vc = DetailViewController()
            vc.viewModel = DetailViewModel(movie: movie,view: vc)
            return vc
        }
     }
}
