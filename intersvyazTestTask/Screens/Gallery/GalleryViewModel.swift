//
//  GalleryViewModel.swift
//  intersvyazTestTask
//
//  Created by Рома Сумороков on 10.06.2022.
//

import Foundation

class GalleryViewModel {
  @Box var items: [ImageModel] = []
  private var page: Int = 1
  private var loadingNextPage: Bool = false
}

extension GalleryViewModel {
  func loadNextPage() async {
    if !loadingNextPage {
      loadingNextPage = true
      items += await getPage(index: page)
      page += 1
    }
  }
  
  func getPage(index: Int) async -> [ImageModel] {
    let images: [ImageModel] = await withCheckedContinuation({ continuation in
      Api.fetchImages(page: index) { result in
        self.loadingNextPage = false
        continuation.resume(returning: result)
      }
    })
    return images
  }
}
