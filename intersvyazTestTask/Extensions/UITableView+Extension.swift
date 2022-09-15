import UIKit

extension UITableView {
  public func registerCell(_ cell: UITableViewCell.Type) {
    register(cell, forCellReuseIdentifier: reuseIdentifier(for: cell))
  }
  
  func reuseIdentifier(for cell: UITableViewCell.Type) -> String {
    String(describing: cell)
  }
  
  public func dequeueCell<Cell: UITableViewCell>(_ cell: Cell.Type, for indexPath: IndexPath) -> Cell {
    if let cell = dequeueReusableCell(withIdentifier: String(describing: cell), for: indexPath) as? Cell {
      return cell
    }
    return Cell()
  }
  
  public func setContentInset(top: CGFloat = 0, left: CGFloat = 0, right: CGFloat = 0, bottom: CGFloat = 0) {
    contentInset = UIEdgeInsets(top: top, left: left, bottom: right, right: bottom)
  }
}
