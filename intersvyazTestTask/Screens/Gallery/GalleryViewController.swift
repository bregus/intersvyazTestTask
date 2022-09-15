//
//  ViewController.swift
//  intersvyazTestTask
//
//  Created by Рома Сумороков on 14.09.2021.
//

import UIKit
import SnapKit
import Hero
import NetShears

class GalleryViewController: UIViewController {
  private let viewModel = GalleryViewModel()
  var expanded = true
  lazy var collectionView: UICollectionView = {
    let collection = UICollectionView(frame: CGRect.zero, collectionViewLayout: UICollectionViewFlowLayout())
    collection.delegate = self
    collection.dataSource = self
    collection.registerCell(GalleryCollectionViewCell.self)
    collection.registerReusableView(SelectorView.self, elementKindSection: .header)
    return collection
  }()
    
  override func viewDidLoad() {
    super.viewDidLoad()
    setNavigation()
    viewModel.items.bind { [weak self] in
      self?.updateColletionView()
    }
    viewModel.loadNextPage()
  }
  
  override func loadView() {
    self.view = collectionView
  }
  
  private func setNavigation() {
    view.backgroundColor = .systemBackground
    navigationItem.title = "Gallery"
    navigationController?.navigationBar.prefersLargeTitles = true
    navigationItem.largeTitleDisplayMode = .automatic
    let interceptorButton = UIBarButtonItem(barButtonSystemItem: .bookmarks, target: self, action: #selector(showLogger))
    navigationItem.rightBarButtonItems = [interceptorButton]
  }
    
  override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
    self.collectionView.reloadData()
  }
  
  func updateColletionView() {
    DispatchQueue.main.async { self.collectionView.reloadSections(NSIndexSet(index: 0) as IndexSet) }
  }
  
  @objc func showLogger() {
    NetShears.shared.presentNetworkMonitor()
  }
}

extension GalleryViewController: UICollectionViewDelegate, UICollectionViewDataSource {
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return expanded ? viewModel.items.value.count : 0
  }
    
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueCell(GalleryCollectionViewCell.self, for: indexPath)
    cell.setup(url: viewModel.items.value[indexPath.item].croppedUrl)
    return cell
  }
  
  func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
    let header = collectionView.dequeueReusableView(SelectorView.self, elementKindSection: .header, for: indexPath)
    header.subtitle = "hello"
    header.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(expandSection)))
    return header
  }
  
  @objc func expandSection() {
    expanded.toggle()
    updateColletionView()
  }
    
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    let vc = ImageDescriptionViewController(item: viewModel.items.value[indexPath.item])
    present(vc.embended, animated: true)
  }
    
  func collectionView(_ collectionView: UICollectionView, didHighlightItemAt indexPath: IndexPath) {
    UIView.animate(withDuration: 0.2) {
      if let cell = collectionView.cellForItem(at: indexPath) {
        cell.transform = .init(scaleX: 0.9, y: 0.9)
      }
    }
  }

  func collectionView(_ collectionView: UICollectionView, didUnhighlightItemAt indexPath: IndexPath) {
    UIView.animate(withDuration: 0.5) {
      if let cell = collectionView.cellForItem(at: indexPath) {
        cell.transform = .identity
      }
    }
  }
    
  func scrollViewDidScroll(_ scrollView: UIScrollView) {
    let offsetY = scrollView.contentOffset.y
    let contentHeight = scrollView.contentSize.height
    
    if offsetY > contentHeight - scrollView.frame.height + 50 {
      viewModel.loadNextPage()
    }
  }
}

extension GalleryViewController: UICollectionViewDelegateFlowLayout {
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    let items = 2
    let size = collectionView.frame.width - CGFloat(items * 10)
    let cellsize =  size / CGFloat(items)
    return CGSize(width: cellsize, height: cellsize)
  }
    
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
    return UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
    CGSize(width: collectionView.frame.width, height: 66)
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
