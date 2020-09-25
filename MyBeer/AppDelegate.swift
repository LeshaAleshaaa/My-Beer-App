//
//  AppDelegate.swift
//  MyBeer
//
//  Created by Алексей Смицкий on 24.09.2020.
//

import UIKit

// MARK: - AppDelegate

@main
final class AppDelegate: UIResponder, UIApplicationDelegate {
    
    // MARK: - Public properties
    
    var window: UIWindow?
    
    // MARK: - Public methods
    
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        let chooseBeerController = ChooseBeerController()
        let navigationController = UINavigationController(rootViewController: chooseBeerController)
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = navigationController
        window?.backgroundColor = .white
        window?.makeKeyAndVisible()
        
        return true
    }
}
