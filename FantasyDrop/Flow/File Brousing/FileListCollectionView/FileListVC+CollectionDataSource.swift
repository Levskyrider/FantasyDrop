//
//  FileListVC+CollectionDataSource.swift
//  FantasyDrop
//
//  Created by Dmitro Levkutnyk on 04.09.2023.
//

import UIKit

//MARK: - CollectionViewDataSource

extension FileListViewController: UICollectionViewDataSource {
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return viewModel.dataSource.count
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FileCollectionViewCell.identrifier, for: indexPath) as! FileCollectionViewCell
    let elementViewModel = viewModel.dataSource[indexPath.row]
    cell.viewModel = elementViewModel
    
    return cell
  }
  
  
}
