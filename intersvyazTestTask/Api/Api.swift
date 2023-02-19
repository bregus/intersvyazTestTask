//
//  Api.swift
//  intersvyazTestTask
//
//  Created by Рома Сумороков on 14.09.2021.
//

import Foundation
import UIKit

struct ImageModel: Codable, Equatable {
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

  static func fetchImages(page: Int, onCompletion: @escaping (DataResponse<[ImageModel], RequestError>) -> Void) {
    let url = "https://picsum.photos/v2/list?page=\(page)&limit=10&grayscale"
    request(with: url, completion: onCompletion)
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

  static func request<T: Decodable>(with url: URLConvertible, completion: @escaping (DataResponse<T, RequestError>) -> Void ) {
    do {
      let url = try url.asURL()
    } catch {

    }
//    URLSession.shared.dataTask(with: url) { data, response, error in
//
//    }.resume()
//    do {
//      let response = DataRequest(response: (data, response, error))
//      let result = try response.decode(type: T.self)
//      completion(DataResponse(result: Result<T, RequestError>.success(result)))
//    } catch {
//
//    }
  }
}

public protocol URLConvertible {
  func asURL() throws -> URL
}

extension String: URLConvertible {
  public func asURL() throws -> URL {
    guard let url = URL(string: self) else { throw RequestError.invalidURL(url: self) }
    return url
  }
}

public enum RequestError: Error {
  case invalidURL(url: String)
  case failParseData
}

struct DataRequest {
  let response: (Data?, URLResponse?, Error?)

  func decode<Success: Decodable>(type: Success.Type) throws -> Success {
    guard let data = response.0 else { throw NSError() }
    do {
      return try JSONDecoder().decode(Success.self, from: data)
    } catch {
      throw RequestError.failParseData
    }
  }
}

struct DataResponse<Success, Failure: Error> {
  let result: Result<Success, Failure>

  var value: Success? { result.success }

  var error: Failure? { result.failure }

  func map<NewSuccess>(_ transform: (Success) -> NewSuccess) -> DataResponse<NewSuccess, Failure> {
    DataResponse<NewSuccess, Failure>(result: result.map(transform))
  }

  public func mapError<NewFailure: Error>(_ transform: (Failure) -> NewFailure) -> DataResponse<Success, NewFailure> {
      DataResponse<Success, NewFailure>(result: result.mapError(transform))
  }
}

extension Result {
  var success: Success? {
      guard case let .success(value) = self else { return nil }
      return value
  }

  /// Returns the associated error value if the result is a failure, `nil` otherwise.
  var failure: Failure? {
      guard case let .failure(error) = self else { return nil }
      return error
  }
}
