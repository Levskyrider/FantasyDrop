//
//  IntroCoordinator.swift
//  FantasyDrop
//
//  Created by Dmitro Levkutnyk on 01.09.2023.
//

import UIKit
import SwiftyDropbox

enum AuthCoordinatorEvent {
  
}
 
class AuthCoordinator: Coordinator {
  
  var onEvent: (() -> ())?
  var childCoordinators: [Coordinator] = []
  var navigationController: UINavigationController
  var api: Api
  
  init(navigationController: UINavigationController, api: Api) {
    self.navigationController = navigationController
    self.api = api
  }
  
  func start() {
    startIntroViewController()
  }
  
  func startIntroViewController() {
    let introViewController = IntroViewController()
    introViewController.onIntroLoaded = { [weak self] in
      guard let self = self else { return }
      self.startAuth()
    }
    set(controller: introViewController)
  }
  
  func startAuth() {
    let viewModel = AuthViewModel(api: self.api)
    let authViewControler = AuthViewController(viewModel: viewModel)
    authViewControler.onEvent = { [weak self] event in
      guard let self = self else { return }
      switch event {
      case .loggedIn:
        print("User logged in")
      }
    }
    set(controller: authViewControler)
  }
  
  func finish() {
    print("Finish")
  }
  
  
}

extension AuthCoordinator {
  func authResultHandled(_ result: DropboxOAuthResult) {
    for vc in navigationController.viewControllers {
      if vc is AuthViewController {
        vc
      }
    }
  }
}
