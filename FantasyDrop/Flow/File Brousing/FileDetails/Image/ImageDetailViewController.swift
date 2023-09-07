//
//  FileImageDetailViewController.swift
//  FantasyDrop
//
//  Created by Dmitro Levkutnyk on 05.09.2023.
//

import UIKit

class ImageDetailViewController: UIViewController, UIScrollViewDelegate {
  
  //MARK: - Variables
  
  var viewModel: ImageDetailViewModel!
  
  //MARK: - UI
  
  var scrollView: UIScrollView = {
    let scrollView = UIScrollView()
    scrollView.backgroundColor = .white
    scrollView.minimumZoomScale = 1.0
    scrollView.maximumZoomScale = 2.0
    scrollView.translatesAutoresizingMaskIntoConstraints = false
    scrollView.backgroundColor = .white
    return scrollView
  }()
  
  var imageView: UIImageView = {
    let imageView = UIImageView()
    imageView.contentMode = .scaleAspectFit
    imageView.translatesAutoresizingMaskIntoConstraints = false
    return imageView
  }()
  
  var activityIndicator = UIActivityIndicatorView()
  
  //MARK: - Init
  
  init(viewModel: ImageDetailViewModel) {
    self.viewModel = viewModel
    super.init(nibName: nil, bundle: nil)
    
    
    viewModel.onEvent = { [weak self] event in
      guard let self = self else { return }
      switch event {
      case .startLoadingFile:
        self.startLoading()
      case .imageDownloaded:
        self.stopLoading()
        self.setImage()
      }
    }
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  //MARK: - Life cycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    self.view.addSubview(activityIndicator)
    activityIndicator.snp.makeConstraints { make in
      make.top.left.right.bottom.equalTo(self.view)
    }
    activityIndicator.isHidden = true
    activityIndicator.color = .darkGray
   
    scrollView.delegate = self
    if let image = viewModel.image {
      imageView.image = image
    } else {
      viewModel.startLoadImage()
    }
  }
  
  override func viewWillAppear(_ animated: Bool) {
    view.backgroundColor = .white
    setupUI()
  }
  
  func setupUI() {
    view.addSubview(scrollView)
    scrollView.snp.makeConstraints { make in
      make.top.leading.trailing.bottom.equalTo(self.view.safeAreaLayoutGuide)
    }
    
    scrollView.addSubview(imageView)
    imageView.snp.makeConstraints { make in
      make.center.equalTo(scrollView)
      make.width.equalTo(scrollView.snp.width)
      make.height.equalTo(scrollView.snp.height)
    }
    
  }
  
  //MARK: - Logic
  
  func setImage() {
    self.imageView.image = viewModel.image
  }
  
  func startLoading() {
    activityIndicator.isHidden = false
    activityIndicator.startAnimating()
  }
  
  func stopLoading() {
    activityIndicator.stopAnimating()
    activityIndicator.isHidden = true
    activityIndicator.removeFromSuperview()
  }
  
  // MARK: - UIScrollViewDelegate
  
  func viewForZooming(in scrollView: UIScrollView) -> UIView? {
    return imageView
  }
  
}
