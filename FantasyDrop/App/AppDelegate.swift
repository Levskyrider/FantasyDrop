//
//  AppDelegate.swift
//  FantasyDrop
//
//  Created by Dmitro Levkutnyk on 01.09.2023.
//

import UIKit
import SwiftyDropbox

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
    DropboxClientsManager.setupWithAppKey("jzyx97e49hv14r5")
    
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
  
  func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
    let oauthCompletion: DropboxOAuthCompletion = {
      if let authResult = $0 {
        switch authResult {
        case .success:
          print("Success! User is logged into DropboxClientsManager.")
        case .cancel:
          print("Authorization flow was manually canceled by user!")
        case .error(_, let description):
          print("Error: \(String(describing: description))")
        }
      }
    }
    let canHandleUrl = DropboxClientsManager.handleRedirectURL(url, completion: oauthCompletion)
    return canHandleUrl
  }
  
}

