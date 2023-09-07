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
    startFileBrousing()
  }
  
  func startFileBrousing() {
    let viewModel = FileListViewModel(api: api)
    let fileListViewController = FileListViewController(viewModel: viewModel)
    fileListViewController.onEvent = { [weak self] event in
      guard let self = self else { return }
      switch event {
      case .shouldOpenFile(let type, let path):
        self.showFileDetail(path: path, fileType: type)
      }
    }
    set(controller: fileListViewController)
  }
  
  func showFileDetail(path: String, fileType: FileType) {
    switch fileType {
    case .image:
      showImageDetail(path: path)
    case .video:
      showVideoDetail(path: path)
    case .other:
      break
    }
  }
  
  func showImageDetail(path: String) {
    let viewModel = ImageDetailViewModel(filePath: path, api: self.api)
    let vc = ImageDetailViewController(viewModel: viewModel)
    push(controller: vc)
  }
  
  func showVideoDetail(path: String) {
    let viewModel = VideoDetailViewModel(filePath: path, api: self.api)
    let vc = VideoDetailViewController(viewModel: viewModel)
    push(controller: vc)
  }
  
  func finish() {
    print("Finish")
  }
  
}
