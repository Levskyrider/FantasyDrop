//
//  FileListViewModel.swift
//  FantasyDrop
//
//  Created by Dmitro Levkutnyk on 03.09.2023.
//

import UIKit
import SwiftyDropbox

enum FileListViewModelEvent {
  case startLoadingFilesList
  case listLoaded
  case errorLoadingFileList(String)
}

class FileListViewModel {
  
  var onEvent: ((FileListViewModelEvent) -> ())?
  var api: Api
  
  private var lastDownloadedFileIndex: Int = -1
  var nextCellIndexToDownloadNewFiles: Int {
    get {
      return lastDownloadedFileIndex - 2
    }
  }
  
  private var dataSource: [FileCellViewModel] = []
  
  subscript (elementForIndexPath indexPath: IndexPath) -> FileCellViewModel {
    return dataSource[indexPath.row]
  }
  
  var itemsCount: Int {
    return dataSource.count
  }
  
  init(api: Api = Api()) {
    self.api = api
  }
  
  func loadFilesList() {
    api.loadFilesList { [weak self] result in
      guard let self = self else { return }
      switch result {
      case .success(let filesList):
        self.handleFilesList(filesList)
      case .error(let errorDescription):
        print(errorDescription)
        self.onEvent?(.errorLoadingFileList(errorDescription))
      }
    }
  }
  
  private func handleFilesList(_ list: Array<Files.Metadata>) {
    for el in list {
      guard let path = el.pathLower else { return }
      let viewModel = FileCellViewModel(path: path)
      dataSource.append(viewModel)
    }
    //MARK: - Test loading
    onEvent?(.listLoaded)
    
    beginLoading(fileIndex: 0, countOfElementsToDownload: 10)
  }
  
  func beginLoading(fileIndex: Int, countOfElementsToDownload: Int)  {
    for i in fileIndex..<(fileIndex + countOfElementsToDownload) {
      guard i < dataSource.count else { lastDownloadedFileIndex = dataSource.count - 1; return }
      DispatchQueue.global().async { [weak self] in
        guard let self = self else { return }
        ThumbnailManager.shared.getTHumbnail(path: self.dataSource[i].path) { result in
          switch result {
          case .success(_):
            self.dataSource[i].setImageMiniature()
          case .error(let errorDescription):
            print(errorDescription)
          }
        }
      }
    }
    lastDownloadedFileIndex = fileIndex + countOfElementsToDownload
  }
  
  func downloadNew() {
    beginLoading(fileIndex: lastDownloadedFileIndex, countOfElementsToDownload: 10)
  }
  
}
