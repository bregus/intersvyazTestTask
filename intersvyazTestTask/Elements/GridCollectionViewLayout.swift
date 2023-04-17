//
//  GridCollectionViewLayout.swift
//  intersvyazTestTask
//
//  Created by Рома Сумороков on 25.03.2023.
//

import UIKit

final class GridCollectionViewLayout: UICollectionViewCompositionalLayout {
  enum GridItemSize: CGFloat {
    case list = 1
    case half = 0.5
    case third = 0.33333
    case quarter = 0.25
  }

  init(gridItemSize: GridItemSize) {
    let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(gridItemSize.rawValue),
                                          heightDimension: .fractionalHeight(1.0))
    let item = NSCollectionLayoutItem(layoutSize: itemSize)
    item.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 5, bottom: 5, trailing: 5)
    let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                           heightDimension: .fractionalWidth(gridItemSize.rawValue))
    let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
    let section = NSCollectionLayoutSection(group: group)
    super.init(section: section)
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
