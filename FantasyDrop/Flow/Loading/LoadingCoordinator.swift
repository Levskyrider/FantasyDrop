//
//  LoadingCoordinator.swift
//  FantasyDrop
//
//  Created by Dmitro Levkutnyk on 08.09.2023.
//

import UIKit

class LoadingCoordinator: Coordinator {
  
  var onAppLoaded: (() -> ())?
  var childCoordinators: [Coordinator] = []
  var navigationController: UINavigationController
  var api: Api
  
  var appLoaded: Bool = false {
    didSet {
      checkAppLoaded()
    }
  }
  var tokenLoaded: Bool = false {
    didSet {
      checkAppLoaded()
    }
  }
  
  func checkAppLoaded() {
    if appLoaded && tokenLoaded {
      onAppLoaded?()
    }
  }
  
  init(navigationController: UINavigationController, api: Api) {
    self.navigationController = navigationController
    self.api = api
  }
  
  func start() {
    startIntroViewController()
    startLoadingToken()
  }
  
  func startLoadingToken() {
    api.refreshToken { [weak self] token in
      if token != nil {
        self?.tokenLoaded = true
      }
    }
  }
  
  func startIntroViewController() {
    let introViewController = IntroViewController()
    introViewController.onIntroLoaded = { [weak self] in
      guard let self = self else { return }
      self.appLoaded = true
    }
    set(controller: introViewController)
  }
  
  func finish() {
    for coordinator in childCoordinators {
      coordinator.finish()
    }
  }
  
}
