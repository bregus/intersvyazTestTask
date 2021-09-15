//
//  CachableImageView.swift
//  intersvyazTestTask
//
//  Created by Рома Сумороков on 14.09.2021.
//

import UIKit

let imageCache = NSCache<NSString, UIImage>()

class CachableImageView : UIImageView {
        
    var imageUrlString : String?

    func setImage(from url: String ) {
        imageUrlString = url
    
        if let imageFromCache = imageCache.object(forKey: url as NSString) {
            image = imageFromCache
            return
        }

        image = UIImage(named: "placeholder")

        guard let curl = URL(string: url) else { return }
        
        Api.request(with: curl) { response in
            guard let image = UIImage(data: response) else { return }
            DispatchQueue.main.sync() { [weak self] in
                if self?.imageUrlString == url {
                    self?.image = image
                }
                imageCache.setObject(image, forKey: url as NSString)
            }
        }
    }
    
}
