//
//  SceneDelegate.swift
//  ItunesApp
//
//  Created by Muhammad Tafani Rabbani on 04/01/24.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    var mainCoordinator : MainCoordinator?
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        
        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: windowScene)
        
        //MARK: initiate the main Coordinator for Coordinator navigation pattern
        mainCoordinator = MainCoordinator()
        mainCoordinator?.startCoordinator() 
        
        window?.rootViewController = mainCoordinator?.navigationController
        window?.makeKeyAndVisible()
    }
    
}

