//
//  UIViewController+Extensions.swift
//  intersvyazTestTask
//
//  Created by Рома Сумороков on 28.04.2022.
//

import Foundation
import UIKit

extension UIViewController {
  var embended: UINavigationController {
    return UINavigationController(rootViewController: self)
  }
}

extension UINavigationBar {
  func installBlurEffect() {
    isTranslucent = true
    setBackgroundImage(UIImage(), for: .default)
    backgroundColor = .clear
    let window = UIApplication.shared.windows.filter {$0.isKeyWindow}.first
    let statusBarHeight = window?.windowScene?.statusBarManager?.statusBarFrame.height ?? 0
    print(statusBarHeight)
    var blurFrame = bounds
    blurFrame.size.height += statusBarHeight
    blurFrame.origin.y -= statusBarHeight
    let blurView  = UIVisualEffectView(effect: UIBlurEffect(style: .systemMaterial))
    blurView.isUserInteractionEnabled = false
    blurView.frame = blurFrame
    blurView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    addSubview(blurView)
    blurView.layer.zPosition = -1
  }
}
