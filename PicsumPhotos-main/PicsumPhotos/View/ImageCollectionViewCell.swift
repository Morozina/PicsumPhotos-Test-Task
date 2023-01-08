//
//  ImageCollectionViewCell.swift
//  PicsumPhotos
//
//  Created by Vladyslav Moroz on 17.12.2022.
//

import Foundation
import UIKit

class ImageCollectionViewCell: UICollectionViewCell {
    
    var imageView: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.contentMode = .scaleToFill
        image.clipsToBounds = true
        return image
    }()
    
    var activityView: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.hidesWhenStopped = true
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        contentView.addSubview(imageView)
        imageView.addSubview(activityView)
        NSLayoutConstraint.activate([
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Layout.leading),
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: Layout.top),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: Layout.trailing),
            imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: Layout.bottom),
            
            activityView.centerXAnchor.constraint(equalTo: imageView.centerXAnchor),
            activityView.centerYAnchor.constraint(equalTo: imageView.centerYAnchor)
        ])
    }
}

extension ImageCollectionViewCell {
    private enum Layout {
        static let leading: CGFloat = 8.0
        static let trailing: CGFloat = 8.0
        static let top: CGFloat = 8.0
        static let bottom: CGFloat = 8.0

    }
}
