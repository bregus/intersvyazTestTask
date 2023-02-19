//
//  ImageDescriptionViewController.swift
//  intersvyazTestTask
//
//  Created by Рома Сумороков on 14.09.2021.
//

import UIKit
import Hero

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
    imageView.pin.all(view.pin.safeArea).center()
    self.imageView.setImage(from: item.croppedUrl)
    self.imageView.setImage(from: item.download_url, needPlaceholder: false)
    
//    imageView.isUserInteractionEnabled = true
//    imageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dismissVC)))
//    imageView.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(handlePan)))
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
    navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .close, target: self, action: #selector(close))
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
  
  @objc func handlePan(_ sender: UIPanGestureRecognizer) {
      let translation = sender.translation(in: nil)
      let progress = translation.y / 2 / view.bounds.height
      switch sender.state {
      case .began:
        hero.dismissViewController()
      case .changed:
          Hero.shared.update(progress)
          let currentPosition = CGPoint(x: translation.x + imageView.center.x, y: translation.y + imageView.center.y)
          Hero.shared.apply(modifiers: [.position(currentPosition)], to: imageView)
      default:
          // to dismiss for up and down direction
          Hero.shared.finish()
          // to dismiss for down direction only, must uncomment this if statement
//            if progress > 0.1 {
//                Hero.shared.finish()
//            } else {
//                Hero.shared.cancel()
//            }
      }
  }
}
