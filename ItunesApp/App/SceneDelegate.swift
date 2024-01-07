//
//  SceneDelegate.swift
//  ItunesApp
//
//  Created by Muhammad Tafani Rabbani on 04/01/24.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        
        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: windowScene)
        
        let navigationController = UINavigationController(rootViewController: setupInitController())
        navigationBarConfiguration(navigationController)
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
    }
    
    private func setupInitController()->UIViewController{
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let view = storyboard.instantiateViewController(identifier: "ListViewController") as! ViewController
        let viewmodel = ListViewModel(view: view)
        view.viewmodel = viewmodel
        return view
    }
    
    private func navigationBarConfiguration (_ controller: UINavigationController) {
        controller.navigationBar.prefersLargeTitles = false
        let navBarAppearance = UINavigationBarAppearance()
        navBarAppearance.configureWithOpaqueBackground()
        navBarAppearance.backgroundColor = UIColor.red
        controller.navigationBar.standardAppearance = navBarAppearance
        controller.navigationBar.scrollEdgeAppearance = navBarAppearance
        controller.navigationBar.tintColor = .black
    }
}

