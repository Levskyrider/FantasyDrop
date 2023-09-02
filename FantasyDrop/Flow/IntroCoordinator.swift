//
//  IntroCoordinator.swift
//  FantasyDrop
//
//  Created by Dmitro Levkutnyk on 01.09.2023.
//

import UIKit

class IntroCoordinator: Coordinator {
  
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

    set(controller: introViewController)
  }
  
  func finish() {
    print("Finish")
  }
  
  
}
