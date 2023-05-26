//
//  AppDelegate.swift
//  iOSStorage
//
//  Created by Николай Игнатов on 25.05.2023.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        let navigationCOntroller = UINavigationController(rootViewController: LoginViewController())
        window?.rootViewController = navigationCOntroller
        window?.makeKeyAndVisible()
        
        return true
    }

}

