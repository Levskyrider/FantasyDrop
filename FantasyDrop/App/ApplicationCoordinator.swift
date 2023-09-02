//
//  ApplicationCoordinator.swift
//  FantasyDrop
//
//  Created by Dmitro Levkutnyk on 01.09.2023.
//

import UIKit

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
    let introCoordinator = IntroCoordinator(navigationController: navigationController, api: api)
    introCoordinator.start()
    addDependency(coordinator: introCoordinator)
  }
  
  func finish() {
    print("Finish")
  }
  
  
}
