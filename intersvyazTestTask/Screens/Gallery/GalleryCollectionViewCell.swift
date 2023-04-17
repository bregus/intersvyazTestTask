//
//  GalleryCollectionViewCell.swift
//  intersvyazTestTask
//
//  Created by Рома Сумороков on 14.09.2021.
//

import UIKit
import SnapKit
import AlamofireImage

class GalleryCollectionViewCell: UICollectionViewCell {
  let imageView: UIImageView = {
    let imageView = UIImageView()
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

  override func prepareForReuse() {
    super.prepareForReuse()
    imageView.image = nil
  }
    
  override func layoutSubviews() {
    imageView.layer.cornerRadius = 20
  }
    
  func setup(url: String) {
    guard let url = URL(string: url) else { return }
    imageView.af.setImage(withURL: url, filter: AspectScaledToFillSizeFilter(size: frame.size), imageTransition: .crossDissolve(0.2))//.setImage(from: url, needPlaceholder: false)
  }
    
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
