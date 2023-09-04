//
//  FileListViewModel.swift
//  FantasyDrop
//
//  Created by Dmitro Levkutnyk on 03.09.2023.
//

import UIKit

enum FileListViewModelEvent {
  
}

class FileListViewModel {
  
  var onEvent: ((FileListViewModelEvent) -> ())?
  var api: Api
  
  init(api: Api = Api()) {
    self.api = api
  }
  
  func readFiles() {
    api.readFiles()
  }
  
}
