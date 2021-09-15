//
//  Api.swift
//  intersvyazTestTask
//
//  Created by Рома Сумороков on 14.09.2021.
//

import Foundation

struct Response: Codable {
    let id: String
    let author: String
    let width: Int
    let height: Int
    let url: String
    let download_url: String
    
    var croppedUrl: String {
        get { return "https://picsum.photos/id/\(id)/200" }
    }
}

struct Api {
    static func fetchImages(page: Int, completion: @escaping ([Response])->Void) {
        guard let url = URL(string: "https://picsum.photos/v2/list?page=\(page)") else { return }
        
        request(with: url) { response in
            do {
                let responseDecoded = try JSONDecoder().decode([Response].self, from: response)
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
