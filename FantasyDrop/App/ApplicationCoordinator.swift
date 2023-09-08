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
    startLoadingApp()
  }
  
  func startLoadingApp() {
    let loadingCoordinator = LoadingCoordinator(navigationController: self.navigationController, api: self.api)
    loadingCoordinator.onAppLoaded = { [weak self] in
      guard let self = self else { return }
      self.startFileBrousing()
      self.removeDependency(coordinator: loadingCoordinator)
    }
    loadingCoordinator.start()
    addDependency(coordinator: loadingCoordinator)
  }
  
  func startAuth() {
    let authCoordinator = AuthCoordinator(navigationController: navigationController, api: api)
    authCoordinator.onEvent = { [weak self] event in
      guard let self = self else { return }
      switch event {
      case .userLoggedIn:
        print("User logged in")
        self.startFileBrousing()
        self.removeDependency(coordinator: authCoordinator)
      }
    }
    authCoordinator.start()
    addDependency(coordinator: authCoordinator)
  }
  
  func startFileBrousing() {
    let fileBrousingCoordinator = FileBrousingCoordinator(navigationController: navigationController, api: api)
    fileBrousingCoordinator.start()
    addDependency(coordinator: fileBrousingCoordinator)
  }
  
  func startDEBUG(vc: UIViewController, isNavigationBarHidden: Bool) {
    push(controller: vc, isNavBarHidden: isNavigationBarHidden)
  }
  
  func finish() {
    print("Finish")
  }
  
}

//MARK: - Dropbox

extension ApplicationCoordinator {
  
  func authResultHandled(_ authResult: DropboxOAuthResult) {
    for coordinator in childCoordinators {
      if let coordinator = coordinator as? AuthCoordinator {
        coordinator.authResultHandled(authResult)
      }
    }
  }
  
}
