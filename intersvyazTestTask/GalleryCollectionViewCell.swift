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
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.contentView.addSubview(imageView)
        self.contentView.autoresizingMask.insert(.flexibleHeight)
        self.contentView.autoresizingMask.insert(.flexibleWidth)
        
        NSLayoutConstraint.activate([
            self.imageView.topAnchor.constraint(equalTo: self.contentView.topAnchor),
            self.imageView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor),
            self.imageView.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor),
            self.imageView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor)
        ])
 
        layoutIfNeeded()
    }
    
    override func layoutSubviews() {
        imageView.layer.cornerRadius = imageView.frame.height / 10
    }
    
    func setup(url: String) {
        self.imageView.setImage(from: url)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
