//
//  AppDelegate.swift
//  FantasyDrop
//
//  Created by Dmitro Levkutnyk on 01.09.2023.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
  
  var window: UIWindow? {
    didSet {
      if #available(iOS 13.0, *) {
        self.window?.overrideUserInterfaceStyle = .light
      }
    }
  }
  
  var applicationCoordinator: ApplicationCoordinator!
  
  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    
    let rootVC = BaseNavigationController()
    rootVC.isNavigationBarHidden = true
    
    window = UIWindow(frame: UIScreen.main.bounds)
    window?.rootViewController = rootVC
    window?.makeKeyAndVisible()
    
    let api = Api()
    
    applicationCoordinator = ApplicationCoordinator(navigationController: rootVC, api: api)
    applicationCoordinator.start()
    
    return true
  }
  
}

