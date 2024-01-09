//
//  AppDelegate.swift
//  ItunesApp
//
//  Created by Muhammad Tafani Rabbani on 04/01/24.
//

import UIKit
import CoreData

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        return true
    }

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {

        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
   
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        //MARK: save the last visit date when app is closed
        UserDefaults.standard.setValue(Date().formattedString(), forKey: "LastVisit")
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        //MARK: save the last visit date when app is in background
        UserDefaults.standard.setValue(Date().formattedString(), forKey: "LastVisit")
    }
}

