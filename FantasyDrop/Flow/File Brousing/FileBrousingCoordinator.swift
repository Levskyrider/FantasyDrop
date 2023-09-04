//
//  FileBrousingCoordinator.swift
//  FantasyDrop
//
//  Created by Dmitro Levkutnyk on 03.09.2023.
//

import UIKit

class FileBrousingCoordinator: Coordinator {
  
  var onEvent: ((AuthCoordinatorEvent) -> ())?
  var childCoordinators: [Coordinator] = []
  var navigationController: UINavigationController
  var api: Api
  
  init(navigationController: UINavigationController, api: Api) {
    self.navigationController = navigationController
    self.api = api
  }
  
  func start() {
    let viewModel = FileListViewModel(api: api)
    let fileListViewController = FileListViewController(viewModel: viewModel)
    set(controller: fileListViewController)
  }
  
  func finish() {
    print("Finish")
  }
  
}
