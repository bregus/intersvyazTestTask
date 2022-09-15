//
//  Api.swift
//  intersvyazTestTask
//
//  Created by Рома Сумороков on 14.09.2021.
//

import Foundation
import UIKit

struct ImageModel: Codable {
  let id: String
  let author: String
  let width: Int
  let height: Int
  let url: String
  let download_url: String
    
  var croppedUrl: String {
    return "https://picsum.photos/id/\(id)/\(Int(croppedSize.width))/\(Int(croppedSize.height))"
  }
  
  var croppedSize: CGSize {
    let width = CGFloat(width)
    let height = CGFloat(height)
    let targetSize = CGSize(width: width / 25, height: height / 25)
    let widthRatio  = targetSize.width  / width
    let heightRatio = targetSize.height / height
    var newSize: CGSize
    if(widthRatio > heightRatio) {
        newSize = CGSize(width: width * heightRatio, height: height * heightRatio)
    } else {
        newSize = CGSize(width: width * widthRatio, height: height * widthRatio)
    }
    return newSize
  }
}


struct Api {
  static func fetchImages(page: Int, completion: @escaping ([ImageModel])->Void) {
    guard let url = URL(string: "https://picsum.photos/v2/list?page=\(page)&limit=10&grayscale") else { return }
    request(with: url) { response in
      do {
        let responseDecoded = try JSONDecoder().decode([ImageModel].self, from: response)
        completion(responseDecoded)
      } catch {
        print(error.localizedDescription)
      }
    }
  }
  
  static func request(with url: URL, completion: @escaping (Data)->Void ) {
    URLSession.shared.dataTask(with: url) { data, response, error in
      guard
        let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
        let data = data, error == nil
      else { return }
      completion(data)
    }.resume()
  }
}
