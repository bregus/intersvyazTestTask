//
//  Request.swift
//  intersvyazTestTask
//
//  Created by Рома Сумороков on 22.08.2022.
//

import Foundation
import AVFoundation

protocol APIService {
  var baseURLString: String { get }
  func request<T: Decodable>(endpoint: Endpoint, completion: @escaping (T?, Error?) -> Void)
}

extension APIService {
  func request<T: Decodable>(endpoint: Endpoint, completion: @escaping (T?, Error?) -> Void) {
    let session = URLSession.shared
    let url = URL(string: baseURLString + endpoint.path)!
    var urlRequest = URLRequest(url: url)
    
    urlRequest.httpMethod = endpoint.httpMethod.rawValue
    
    endpoint.headers?.forEach({ header in
      urlRequest.setValue(header.value as? String, forHTTPHeaderField: header.key)
    })
    
    let task = session.dataTask(with: urlRequest) { data, response, error in
      do {
        let responseDecoded = try JSONDecoder().decode(T.self, from: data!)
        completion(responseDecoded, error)
      } catch {
        print(error.localizedDescription)
      }
    }
    task.resume()
  }
}
