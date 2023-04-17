//
//  ImageDescriptionViewController.swift
//  intersvyazTestTask
//
//  Created by Рома Сумороков on 14.09.2021.
//

import UIKit
import AlamofireImage

class ImageDescriptionViewController: UIViewController {
  private var item: ImageModel
  
  let imageView: UIImageView = {
    let imageView = UIImageView()
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
//    navigationController?.setNavigationBarHidden(true, animated: false)
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
//    toggleNavBar()
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

    guard let url = URL(string: item.download_url) else { return }

    imageView.af.setImage(withURL: url, imageTransition: .crossDissolve(0.2)) { res in
      switch res.result {
      case .success(let image):
        let width = self.view.bounds.width
        let height = (image.size.height) * (width / (image.size.width))
        self.preferredContentSize = CGSize(width: width, height: height)
      case .failure:
        self.navigationController?.popViewController(animated: true)
      }
    }
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
