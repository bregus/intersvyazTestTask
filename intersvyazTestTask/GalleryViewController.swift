//
//  ViewController.swift
//  intersvyazTestTask
//
//  Created by Рома Сумороков on 14.09.2021.
//

import UIKit

class GalleryViewController: UIViewController {
    
    var items: [Response] = []
    var page: Int = 0
    var loadingNextPage: Bool = false
    
    lazy var collectionView: UICollectionView = {
        let collection = UICollectionView(frame: CGRect.zero, collectionViewLayout: UICollectionViewFlowLayout())
        collection.delegate = self
        collection.dataSource = self
        collection.backgroundColor = .systemBackground
        collection.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "default")
        collection.register(GalleryCollectionViewCell.self, forCellWithReuseIdentifier: "image")
        collection.isPrefetchingEnabled = true
        collection.alwaysBounceVertical = true
        collection.translatesAutoresizingMaskIntoConstraints = false
        return collection
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(collectionView)
        
        view.backgroundColor = .systemBackground
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    func loadNextPage() {
        Api.fetchImages(page: page) { response in
            DispatchQueue.main.async {
                self.items += response
                self.collectionView.reloadData()
                if response.count != 0 {
                    self.loadingNextPage = false
                }
            }
        }
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        self.collectionView.reloadData()
    }
    
}

extension GalleryViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "image", for: indexPath) as! GalleryCollectionViewCell
        cell.setup(url: items[indexPath.item].croppedUrl)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = ImageDescriptionViewController()
        vc.item = items[indexPath.item]
        self.navigationController?.pushViewController(vc, animated: true)
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
            if !loadingNextPage {
                loadingNextPage = true
                page += 1
                loadNextPage()
            }
        }
    }
    
}

extension GalleryViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let items = Int(collectionView.frame.width / 95)
        let size = collectionView.frame.width - CGFloat(items * 10)
        let cellsize =  size / CGFloat(items)
        return CGSize(width: cellsize, height: cellsize)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
    }
    
}
