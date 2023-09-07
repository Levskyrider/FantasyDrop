//
//  SceneDelegate.swift
//  FantasyDrop
//
//  Created by Dmitro Levkutnyk on 04.09.2023.
//

import UIKit
import SwiftyDropbox

@available(iOS 13.0, *)
class SceneDelegate: UIResponder, UIWindowSceneDelegate {
  
  var window: UIWindow?
  
  var applicationCoordinator: ApplicationCoordinator!
  
  func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
    guard let _ = (scene as? UIWindowScene) else { return }
    if let windowScene = scene as? UIWindowScene {
      
      let rootVC = BaseNavigationController()
      rootVC.isNavigationBarHidden = true

      self.window = UIWindow(windowScene: windowScene)
      self.window!.rootViewController = rootVC
      self.window!.makeKeyAndVisible()
      
     //  let token = "sl.BlfmN4ZtL8Kiji6lib1awO7brsDOmei6bMqMqJ4U0_A3AQfwg1SyptUzysT7lcAZHVT8rH0eYu340MfaEOXpHOuFNxnq24p7Oqb9uXNFXf148G2smQH8ndgyiUCaKGxjmyIS3CFFcNL7am_iUH4XEHM"
      let api = Api(refreshToken: "91q26ELJ1G4AAAAAAAAAAbFJ6S7TNhSfm928x1RMbC6WX71XTQbIGUuw_ekKpfgw")
      
      applicationCoordinator = ApplicationCoordinator(navigationController: rootVC, api: api)
     // applicationCoordinator.startDEBUG(vc: DEBUGViewController(), isNavigationBarHidden: false)
      applicationCoordinator.start()
    }
  }
  
  func handleAuth(result: DropboxOAuthResult) {
    applicationCoordinator.authResultHandled(result)
  }
  
  func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
    let oauthCompletion: DropboxOAuthCompletion = { [weak self] in
      if let authResult = $0 {
        switch authResult {
        case .success(let accessToken):
          print(accessToken)
        default:break
        }
        self?.handleAuth(result: authResult)
      }
    }
    
    for context in URLContexts {
      if DropboxClientsManager.handleRedirectURL(context.url, completion: oauthCompletion) { break }
    }
  }
  
}
