//
//  ApplicationCoordinator.swift
//  FantasyDrop
//
//  Created by Dmitro Levkutnyk on 01.09.2023.
//

import UIKit
import SwiftyDropbox

class ApplicationCoordinator: Coordinator  {
  
  private var api: Api
  weak var finishDelegate: CoordinatorFinishDelegate?
  var childCoordinators: [Coordinator] = []
  var navigationController: UINavigationController
  
  required init(navigationController: UINavigationController, api: Api = Api()) {
    self.navigationController = navigationController
    self.api = api
  }
  
  func start() {
    startIntro()
  }
  
  func startIntro() {
    let authCoordinator = AuthCoordinator(navigationController: navigationController, api: api)
    authCoordinator.start()
    addDependency(coordinator: authCoordinator)
  }
  
  func finish() {
    print("Finish")
  }
  
}

//MARK: - Dropbox

extension ApplicationCoordinator {
  
  func authResultHandled(_ result: DropboxOAuthResult) {
    for coordinator in childCoordinators {
      if coordinator is AuthCoordinator {
        coordinator.authResultHandled(result)
      }
    }
  }
  
}
