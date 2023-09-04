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
      
      let api = Api()
      
      applicationCoordinator = ApplicationCoordinator(navigationController: rootVC, api: api)
      applicationCoordinator.start()
    }
  }
  
//  func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
//    let oauthCompletion: DropboxOAuthCompletion = { [weak self] in
//      if let authResult = $0 {
//          switch authResult {
//          case .success:
//              print("Success! User is logged into DropboxClientsManager.")
//          case .cancel:
//              print("Authorization flow was manually canceled by user!")
//          case .error(_, let description):
//              print("Error: \(String(describing: description))")
//          }
//      }
//    
//    }
//    
//    for context in URLContexts {
//      // stop iterating after the first handle-able url
//      if DropboxClientsManager.handleRedirectURL(context.url, completion: oauthCompletion) { break }
//    }
//  }
  
}
