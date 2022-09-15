//
//  GalleryCollectionViewCell.swift
//  intersvyazTestTask
//
//  Created by Рома Сумороков on 14.09.2021.
//

import UIKit

class GalleryCollectionViewCell: UICollectionViewCell {
  let imageView: CachableImageView = {
    let imageView = CachableImageView()
    imageView.contentMode = .scaleAspectFill
    imageView.clipsToBounds = true
    return imageView
  }()
    
  override init(frame: CGRect) {
    super.init(frame: frame)
    self.contentView.addSubview(imageView)
    self.contentView.autoresizingMask.insert(.flexibleHeight)
    self.contentView.autoresizingMask.insert(.flexibleWidth)
    imageView.backgroundColor = .secondarySystemBackground
    imageView.snp.makeConstraints { $0.edges.equalToSuperview() }
  }
    
  override func layoutSubviews() {
    imageView.layer.cornerRadius = 20
  }
    
  func setup(url: String) {
    self.imageView.setImage(from: url, needPlaceholder: false)
  }
    
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}