//
//  EndpointCases.swift
//  intersvyazTestTask
//
//  Created by Рома Сумороков on 22.08.2022.
//

import Foundation

//struct PicsumApi: APIService {
//  var baseURLString: String { "https://picsum.photos" }
//
//  static func images(page: Int) {
//    Endpoint(httpMethod: .get, path: "v2/list?page=\(page)&limit=10&grayscale")
//  }
//}
//
//enum PicsumEndpoints: Endpoint {
//
//  case getImages(page: Int)
//
//  var baseURLString: String {
//    return "https://picsum.photos"
//  }
//
//  var httpMethod: HTTPMethod {
//    switch self {
//    case .getImages:
//      return .get
//    }
//  }
//
//  var path: String {
//    switch self {
//    case .getImages(let page):
//      return "v2/list?page=\(page)&limit=10&grayscale"
//    }
//  }
//
//  var headers: [String: Any]? {
//    switch self {
//    case .getImages:
//      return [:]
//    }
//  }
//
//  var body: [String : Any]? {
//    switch self {
//    case .getImages:
//      return [:]
//    }
//  }
//}
