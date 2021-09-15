//
//  CachableImageView.swift
//  Recogniser
//
//  Created by Рома Сумороков on 05.08.2021.
//

import UIKit

let imageCache = NSCache<NSString, UIImage>()

class CachableImageView : UIImageView {
        
    var imageUrlString : String?

    func setImage(from url: String, contentMode mode: UIView.ContentMode = .scaleAspectFill) {
        contentMode = mode
        
        imageUrlString = url
    
        guard let nsurl = URL(string: url) else {
            return
        }
 
        if let imageFromCache = imageCache.object(forKey: url as NSString) {
            print("image from cache")
            image = imageFromCache
            return
        }
        
        if let imageFromStorage = retrieveImage(forKey: url) {
            image = UIImage(data: imageFromStorage)
            print("image from storage")
            return
        } else {
            print("downloading")
        }
        image = UIImage(named: "grid_place")

        URLSession.shared.dataTask(with: nsurl) { data, response, error in
            guard
                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                let data = data, error == nil,
                let image = UIImage(data: data)
                else { return }
            DispatchQueue.main.async() { [weak self] in
                if self?.imageUrlString == url {
                    self?.image = image
                }
                imageCache.setObject(image, forKey: url as NSString)
            }
        }.resume()
    }
    
}

