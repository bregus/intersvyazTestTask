//
//  ImageDescriptionViewController.swift
//  intersvyazTestTask
//
//  Created by Рома Сумороков on 14.09.2021.
//

import UIKit

class ImageDescriptionViewController: UIViewController {
  private var item: ImageModel
  
  let imageView: CachableImageView = {
    let imageView = CachableImageView()
    imageView.contentMode = .scaleAspectFit
    imageView.clipsToBounds = true
    return imageView
  }()

  init(item: ImageModel) {
    self.item = item
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .systemBackground
    setView()
    setNavigation()
    setImageView()
    navigationController?.setNavigationBarHidden(true, animated: false)
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    toggleNavBar()
  }
  
  override var prefersHomeIndicatorAutoHidden: Bool {
    guard let navigationController = navigationController else { return false }
    return navigationController.isNavigationBarHidden
  }
  
  private func setImageView() {
    view.addSubview(imageView)

    imageView.snp.makeConstraints { make in
      make.center.equalToSuperview()
      make.left.right.lessThanOrEqualTo(view.safeAreaLayoutGuide)
    }

    self.imageView.setImage(from: item.croppedUrl)
    
    let width = view.bounds.width
    let height = (imageView.image?.size.height ?? 1) * (width / (imageView.image?.size.width ?? 1))
    preferredContentSize = CGSize(width: width, height: height)
    self.imageView.setImage(from: item.download_url, needPlaceholder: false)
  }
  
  @objc func dismissVC() {
    dismiss(animated: true)
  }
  
  private func setView() {
    let tapGesture = UITapGestureRecognizer(target: self, action: #selector(toggleNavBar))
    view.addGestureRecognizer(tapGesture)
  }
  
  private func setNavigation() {
    navigationItem.largeTitleDisplayMode = .never
    navigationController?.navigationBar.tintColor = .label
//    navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .close, target: self, action: #selector(close))
    let button = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(share))
    navigationItem.rightBarButtonItem = button
    navigationItem.title = item.author
    navigationController?.navigationBar.installBlurEffect()
  }
  
  @objc private func toggleNavBar() {
    guard let navigationController = navigationController else {return}
    navigationController.setNavigationBarHidden(!navigationController.navigationBar.isHidden, animated: false)
    view.backgroundColor = navigationController.isNavigationBarHidden ? .black : .systemBackground
  }
  
  @objc private func share() {
    if let image = imageView.image {
      let activity = UIActivityViewController(activityItems: [image], applicationActivities: nil)
      present(activity, animated: true)
    }
  }
  
  @objc private func close() {
    toggleNavBar()
    view.backgroundColor = .clear
    self.dismiss(animated: true)
  }
}
