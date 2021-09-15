//
//  ImageDescriptionViewController.swift
//  intersvyazTestTask
//
//  Created by Рома Сумороков on 14.09.2021.
//

import UIKit

class ImageDescriptionViewController: UIViewController {

    var item: Response!
    
    let imageView: CachableImageView = {
        let imageView = CachableImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    let authorLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let scrollView: UIScrollView = {
        let view = UIScrollView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.showsVerticalScrollIndicator = false
        return view
    }()

    let stackView: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.spacing = 10
        view.layoutMargins = UIEdgeInsets(top: 10, left: 10, bottom: 0, right: 10)
        view.isLayoutMarginsRelativeArrangement = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.addSubview(self.scrollView)
        self.scrollView.addSubview(self.stackView)
        stackView.addArrangedSubview(imageView)
        stackView.addArrangedSubview(authorLabel)

        self.view.backgroundColor = .systemBackground
        navigationController?.navigationBar.tintColor = .label
        
        self.imageView.setImage(from: item.download_url)
        self.authorLabel.text = item.author

        let button = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(share))
        self.navigationItem.rightBarButtonItem = button
                
        let ratio = CGFloat(item.height) / CGFloat(item.width)
        
        NSLayoutConstraint.activate([
            self.imageView.heightAnchor.constraint(equalTo: self.imageView.widthAnchor, multiplier: ratio)
        ])
        
        NSLayoutConstraint.activate([
            self.scrollView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            self.scrollView.topAnchor.constraint(equalTo: self.view.topAnchor),
            self.scrollView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            self.scrollView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            self.stackView.leadingAnchor.constraint(equalTo: self.scrollView.leadingAnchor),
            self.stackView.topAnchor.constraint(equalTo: self.scrollView.topAnchor),
            self.stackView.trailingAnchor.constraint(equalTo: self.scrollView.trailingAnchor),
            self.stackView.bottomAnchor.constraint(equalTo: self.scrollView.bottomAnchor),
            self.stackView.widthAnchor.constraint(equalTo: self.view.widthAnchor, constant: 0)
        ])
    }
    
    @objc func share() {
        if let image = imageView.image {
            let activity = UIActivityViewController(activityItems: [image], applicationActivities: nil)
            present(activity, animated: true)
        }
    }
    
}
