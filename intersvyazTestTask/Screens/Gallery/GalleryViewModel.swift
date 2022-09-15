//
//  GalleryViewModel.swift
//  intersvyazTestTask
//
//  Created by Рома Сумороков on 10.06.2022.
//

import Foundation

class GalleryViewModel {
  var items: Box<[ImageModel]> = Box([])
  private var page: Int = 0
  private var loadingNextPage: Bool = false
}

extension GalleryViewModel {
  func loadNextPage() {
    if !loadingNextPage {
      loadingNextPage = true
      Api.fetchImages(page: page) { response in
        self.items.value += response
        self.page += 1
        if response.count != 0 {
          self.loadingNextPage = false
        }
      }
    }
  }
}
