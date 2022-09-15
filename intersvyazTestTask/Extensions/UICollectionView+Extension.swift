import UIKit

public enum CollectionViewKindSection: String {
  case header = "UICollectionElementKindSectionHeader"
  case footer = "UICollectionElementKindSectionFooter"
}

public extension UICollectionView {
  func registerCell<Cell: UICollectionViewCell>(_ cell: Cell.Type) {
    register(Cell.self, forCellWithReuseIdentifier: reuseIdentifier(for: cell))
  }

  private func reuseIdentifier<T>(for reuse: T.Type) -> String {
    String(describing: reuse)
  }

  func dequeueCell<Cell: UICollectionViewCell>(_ cell: Cell.Type, for indexPath: IndexPath) -> Cell {
    if let cell = dequeueReusableCell(withReuseIdentifier: String(describing: cell), for: indexPath) as? Cell {
      return cell
    }
    return Cell()
  }

  func registerReusableView<View: UIView>(_ view: View.Type, elementKindSection: CollectionViewKindSection) {
    register(View.self, forSupplementaryViewOfKind: elementKindSection.rawValue, withReuseIdentifier: reuseIdentifier(for: view))
  }

  func dequeueReusableView<View: UIView>(_ view: View.Type, elementKindSection: CollectionViewKindSection, for indexPath: IndexPath) -> View {
    if let reusableView = self.dequeueReusableSupplementaryView(
      ofKind: elementKindSection.rawValue,
      withReuseIdentifier: reuseIdentifier(for: view),
      for: indexPath) as? View {
      return reusableView
    }
    return View()
  }
}
