//
//  Endpoint.swift
//  intersvyazTestTask
//
//  Created by Рома Сумороков on 22.08.2022.
//

import Foundation

enum HTTPMethod: String {
  case get = "GET"
  case post = "POST"
  case put = "PUT"
}

//protocol Endpoint {
//  var httpMethod: HTTPMethod { get }
//  var path: String { get }
//  var headers: [String: Any]? { get }
//  var body: [String: Any]? { get }
//}

struct Endpoint {
  var httpMethod: HTTPMethod
  var path: String
  var headers: [String: Any]?
  var body: [String: Any]?
}
