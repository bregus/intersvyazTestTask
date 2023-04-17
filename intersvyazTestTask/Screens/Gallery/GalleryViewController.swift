//
//  ViewController.swift
//  intersvyazTestTask
//
//  Created by Рома Сумороков on 14.09.2021.
//

import UIKit

class GalleryViewController: UIViewController {

  typealias Snapshot = NSDiffableDataSourceSnapshot<Int, ImageModel>
  typealias DataSource = UICollectionViewDiffableDataSource<Int, ImageModel>

  private let viewModel = GalleryViewModel()

  let transition = PushAnimator()
  var datasource: DataSource!

  private lazy var sizeMenu: UIMenu = { [unowned self] in
    return UIMenu(title: "Select size", image: nil, identifier: nil, options: [.displayInline], children: [
      UIAction(title: "List", image: UIImage(systemName: "rectangle.inset.filled"), handler: { (_) in
        self.collectionView.setCollectionViewLayout(GridCollectionViewLayout(gridItemSize: .list), animated: true)
      }),
      UIAction(title: "Half", image: UIImage(systemName: "square.grid.2x2.fill"), handler: { (_) in
        self.collectionView.setCollectionViewLayout(GridCollectionViewLayout(gridItemSize: .half), animated: true)
      }),
      UIAction(title: "Third", image: UIImage(systemName: "square.grid.3x2.fill"), handler: { (_) in
        self.collectionView.setCollectionViewLayout(GridCollectionViewLayout(gridItemSize: .third), animated: true)
      }),
      UIAction(title: "Quarter", image: UIImage(systemName: "square.grid.4x3.fill"), handler: { (_) in
        self.collectionView.setCollectionViewLayout(GridCollectionViewLayout(gridItemSize: .quarter), animated: true)
      }),
    ])
  }()

  lazy var collectionView: UICollectionView = {
    let collection = UICollectionView(frame: CGRect.zero, collectionViewLayout: GridCollectionViewLayout(gridItemSize: .half))
    collection.alwaysBounceVertical = true
    collection.delegate = self
    collection.registerCell(GalleryCollectionViewCell.self)
    return collection
  }()
    
  override func viewDidLoad() {
    super.viewDidLoad()
    setNavigation()
//    transitioningDelegate = self
    configureDatasource()
    viewModel.$items.sink { [weak self] _ in
      guard let self else { return }
      self.datasource.apply(self.snapshot(), animatingDifferences: true)
    }
    Task { await viewModel.loadNextPage() }
  }
  
  override func loadView() {
    self.view = collectionView
  }
  
  private func setNavigation() {
    view.backgroundColor = .systemBackground
    navigationItem.title = "Gallery"
    navigationController?.navigationBar.prefersLargeTitles = true
    navigationItem.largeTitleDisplayMode = .automatic
//    let interceptorButton = UIBarButtonItem(barButtonSystemItem: .bookmarks, target: self, action: #selector(showLogger))
    let gridButton = UIBarButtonItem(systemItem: .edit, primaryAction: nil, menu: sizeMenu)
    navigationItem.rightBarButtonItems = [gridButton]
  }

  @objc func showLogger() {
  }

  private func configureDatasource() {
    datasource = DataSource(collectionView: collectionView, cellProvider: { [unowned self] collectionView, indexPath, item in
      return self.cell(collectionView: collectionView, indexPath: indexPath, item: item)
    })

    datasource.apply(snapshot(), animatingDifferences: true)
  }

  private func snapshot() -> Snapshot {
    var snapshot = Snapshot()
    snapshot.appendSections([0])
    snapshot.appendItems(viewModel.items, toSection: 0)
    return snapshot
  }

  private func cell(collectionView: UICollectionView, indexPath: IndexPath, item: ImageModel) -> UICollectionViewCell {
    let cell = collectionView.dequeueCell(GalleryCollectionViewCell.self, for: indexPath)
    cell.setup(url: item.download_url)
    return cell
  }
}

extension GalleryViewController: UICollectionViewDelegate {
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    let vc = ImageDescriptionViewController(item: viewModel.items[indexPath.item])
    navigationController?.pushViewController(vc, animated: true)
  }

  func collectionView(_ collectionView: UICollectionView, contextMenuConfigurationForItemsAt indexPaths: [IndexPath], point: CGPoint) -> UIContextMenuConfiguration? {
    UIContextMenuConfiguration(previewProvider: { () -> UIViewController? in
      guard let index = indexPaths.first?.item else { return nil }
      return ImageDescriptionViewController(item: self.viewModel.items[index])
    })
  }

  func collectionView(_ collectionView: UICollectionView, willPerformPreviewActionForMenuWith configuration: UIContextMenuConfiguration, animator: UIContextMenuInteractionCommitAnimating) {
    animator.addCompletion {
      if let viewController = animator.previewViewController {
        self.show(viewController, sender: self)
      }
    }
  }

  func scrollViewDidScroll(_ scrollView: UIScrollView) {
    let offsetY = scrollView.contentOffset.y
    let contentHeight = scrollView.contentSize.height
    
    if offsetY > contentHeight - scrollView.frame.height + 50 {
      Task { await viewModel.loadNextPage() }
    }
  }
}

//extension GalleryViewController: UIViewControllerTransitioningDelegate {
//  func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
//    guard let selectedIndexPathCell = collectionView.indexPathsForSelectedItems?.first,
//          let selectedCell = collectionView.cellForItem(at: selectedIndexPathCell),
//          let selectedCellSuperview = selectedCell.superview
//    else {
//      return nil
//    }
//    selectedCell.isHidden = false
//    transition.originFrame = selectedCellSuperview.convert(selectedCell.frame, to: nil)
//    let ratio = view.frame.width / view.frame.height
//    let diff = (transition.originFrame.height * ratio) / 2
//    transition.originFrame = CGRect(
//      x: transition.originFrame.origin.x,
//      y: transition.originFrame.origin.y - diff,
//      width: transition.originFrame.size.width,
//      height: transition.originFrame.size.height + diff
//    )
//    transition.presenting = false
//    return transition
//  }
//
//  func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
//    guard let selectedIndexPathCell = collectionView.indexPathsForSelectedItems?.first,
//          let selectedCell = collectionView.cellForItem(at: selectedIndexPathCell),
//          let selectedCellSuperview = selectedCell.superview
//    else {
//      return nil
//    }
//    selectedCell.isHidden = true
//    transition.originFrame = selectedCellSuperview.convert(selectedCell.frame, to: nil)
//    let ratio = view.frame.width / view.frame.height
//    let diff = (transition.originFrame.height * ratio) / 2
//    transition.originFrame = CGRect(
//      x: transition.originFrame.origin.x,
//      y: transition.originFrame.origin.y - diff,
//      width: transition.originFrame.size.width,
//      height: transition.originFrame.size.height + diff
//    )
//    transition.presenting = true
//    return transition
//  }
//}
