//
//  CachableImageView.swift
//  intersvyazTestTask
//
//  Created by Рома Сумороков on 14.09.2021.
//

import UIKit

let imageCache = NSCache<NSString, UIImage>()

class CachableImageView : UIImageView {
  private var imageUrlString : String?

  func setImage(from url: String, needPlaceholder: Bool = true) {
    imageUrlString = url
    
    if let imageFromCache = imageCache.object(forKey: url as NSString) {
      image = imageFromCache
      return
    }
    if needPlaceholder {
      image = UIImage(named: "placeholder")
    }
    guard let curl = URL(string: url) else { return }

    Api.request(with: curl) { response in
      guard let image = UIImage(data: response) else { return }
      DispatchQueue.main.sync() { [weak self] in
        if let self, self.imageUrlString == url {
//          let image = image.downsampleImage(for: self.frame.size)
          self.image = image
        }
        imageCache.setObject(image, forKey: url as NSString)
      }
    }
  }
}

extension UIImage {
  func downsampleImage(for size: CGSize) -> UIImage? {
      var aspectFillSize = size

      let newWidth: CGFloat = size.width / self.size.width
      let newHeight: CGFloat = size.height / self.size.height

      if newHeight > newWidth {
          aspectFillSize.width = newHeight * self.size.width
      } else if newHeight < newWidth {
          aspectFillSize.height = newWidth * self.size.height
      }

      let renderer = UIGraphicsImageRenderer(size: aspectFillSize)

      return renderer.image { _ in
          self.draw(in: CGRect(origin: .zero, size: aspectFillSize))
      }
  }
}
