//
//  IntroCoordinator.swift
//  FantasyDrop
//
//  Created by Dmitro Levkutnyk on 01.09.2023.
//

import UIKit
import SwiftyDropbox

enum AuthCoordinatorEvent {
  case userLoggedIn
}

protocol AuthResultHandler {
  func authSuccess()
  func authCanceled()
  func authError(description: String?)
}
 
class AuthCoordinator: Coordinator {
  
  var onEvent: ((AuthCoordinatorEvent) -> ())?
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
        self.onEvent?(.userLoggedIn)
      }
    }
    set(controller: authViewControler)
  }
  
  func finish() {
    print("Finish")
  }
  
}

//MARK: - Dropbox auth

extension AuthCoordinator {
  func authResultHandled(_ authResult: DropboxOAuthResult) {
    for vc in navigationController.viewControllers {
      if let vc = vc as? AuthResultHandler {
        switch authResult {
        case .success:
          print("Success! User is logged into DropboxClientsManager.")
          vc.authSuccess()
        case .cancel:
          print("Authorization flow was manually canceled by user!")
          vc.authCanceled()
        case .error(_, let description):
          print("Error: \(String(describing: description))")
          vc.authError(description: description)
        }
      }
    }
  }
}
