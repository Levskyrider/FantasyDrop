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
    
    let api = Api(refreshToken: "91q26ELJ1G4AAAAAAAAAAbFJ6S7TNhSfm928x1RMbC6WX71XTQbIGUuw_ekKpfgw")
    
    applicationCoordinator = ApplicationCoordinator(navigationController: rootVC, api: api)
    applicationCoordinator.start()
    
    //   applicationCoordinator.startDEBUG(vc: DEBUGViewController(), isNavigationBarHidden: false)
    return true
  }
  
  func handleAuth(result: DropboxOAuthResult) {
    applicationCoordinator.authResultHandled(result)
  }
  
  func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
    let oauthCompletion: DropboxOAuthCompletion = { [weak self] in
      if let authResult = $0 {
        self?.handleAuth(result: authResult)
      }
    }
    let canHandleUrl = DropboxClientsManager.handleRedirectURL(url, completion: oauthCompletion)
    return canHandleUrl
  }

}

