//
//  FileListViewController.swift
//  FantasyDrop
//
//  Created by Dmitro Levkutnyk on 03.09.2023.
//

import UIKit

fileprivate enum Defaults {
  static let title: String = "Files"
}

enum FileListViewControllerEvent {
  case shouldOpenFile(FileType, String)
}

class FileListViewController: UIViewController {
  
  //MARK: - Variables
  
  var viewModel: FileListViewModel!
  var onEvent: ((FileListViewControllerEvent) -> ())?
  
  //MARK: - UI
  
  private var backgroundImageView: UIImageView = {
    let imageView = UIImageView()
    imageView.contentMode = .scaleAspectFill
    imageView.image = UIImage(named: "default_background")
    return imageView
  }()
  
  private var collectionView: UICollectionView!
  
  //MARK: - Init
  
  init(viewModel: FileListViewModel) {
    super.init(nibName: nil, bundle: nil)
    self.viewModel = viewModel
    
    viewModel.onEvent = { [weak self] event in
      guard let self = self else { return }
      switch event {
      case .startLoadingFilesList:
        print("Start loading")
      case .listLoaded:
        self.reloadCollectionView()
      case .errorLoadingFileList(let errorDescription):
        print(errorDescription)
      }
    }
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  //MARK: - Life cycle
  
  override func viewDidLoad() {
    viewModel.loadFilesList()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    setupNavigationBar()
    setupCollectionView()
    
    setupUI()
  }
  
  //MARK: - Setup UI
  
  func setupUI() {
    self.view.addSubview(backgroundImageView)
    backgroundImageView.snp.makeConstraints { make in
      make.top.left.right.bottom.equalTo(self.view)
    }
    
    self.view.addSubview(collectionView)
    collectionView.snp.makeConstraints { make in
      make.top.left.right.equalTo(self.view.safeAreaLayoutGuide)
      make.bottom.equalTo(self.view)
    }
  }
  
  func setupNavigationBar() {
    title = Defaults.title
    if let navigationController = self.navigationController as? BaseNavigationController {
      navigationController.isNavigationBarHidden = false
      navigationController.setup(color: .white)
    }
  }
  
  func setupCollectionView() {
    
    let layout = UICollectionViewFlowLayout()
    layout.scrollDirection = .vertical
    layout.minimumInteritemSpacing = 0
    let squareItemSize = self.view.bounds.width / 2
    layout.itemSize = CGSize(width: squareItemSize, height: squareItemSize)
    
    collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: layout)
    collectionView.backgroundColor = .clear
    collectionView.dataSource = self
    collectionView.delegate = self
    
    collectionView.register(FileCollectionViewCell.self, forCellWithReuseIdentifier: FileCollectionViewCell.identrifier)
  }
  
  //MARK: - UI logic
  
  func reloadCollectionView() {
    collectionView.reloadData()
  }
    
}
