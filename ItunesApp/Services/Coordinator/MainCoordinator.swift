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

    func showDetail(movie : Movie){
        let detailVC = ViewControllerProvider.detailViewController.raw as! DetailViewController
        detailVC.movie = movie
        navigationController.pushViewController(detailVC, animated: true)
    }
}


enum ViewControllerProvider {
    case mainViewController
    case detailViewController
    
    var raw: UIViewController {
        
        switch self {
        case .mainViewController:
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let view = storyboard.instantiateViewController(identifier: "ListViewController") as! ViewController
            let viewmodel = ListViewModel(view: view)
            view.viewmodel = viewmodel
            return view
        case .detailViewController:
            return DetailViewController()
        }
     }
}
