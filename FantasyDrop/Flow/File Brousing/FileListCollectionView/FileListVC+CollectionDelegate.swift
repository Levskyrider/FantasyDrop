//
//  FileListVC+CollectionDelegate.swift
//  FantasyDrop
//
//  Created by Dmitro Levkutnyk on 04.09.2023.
//

import UIKit

//MARK: - CollectionViewDelegate

extension FileListViewController: UICollectionViewDelegate {
  func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
    if viewModel.nextCellIndexToDownloadNewFiles == indexPath.row {
      viewModel.downloadNew()
    }
  }
  
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    let element = viewModel[elementForIndexPath: indexPath]
    onEvent?(.shouldOpenFile(element.fileType, element.path))
  }
  
}
