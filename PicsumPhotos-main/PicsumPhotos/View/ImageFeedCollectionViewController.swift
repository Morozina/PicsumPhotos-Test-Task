//
//  ImageFeedCollectionViewController.swift
//  PicsumPhotos
//
//  Created by Vladyslav Moroz on 17.12.2022.
//
import UIKit

private let reuseIdentifier = "Cell"

protocol ImageFeedCollectionViewControllerDelegate: AnyObject {
    func didSelect(feed: Feed, on viewController: ImageFeedCollectionViewController)
}

class ImageFeedCollectionViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    private var collectionView: UICollectionView = {
        let view = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private var viewModel: FeedImageViewModel
    
    var cellControllers = [CellController]() {
        didSet {
            collectionView.reloadData()
        }
    }
    
    weak var delegate: ImageFeedCollectionViewControllerDelegate?
    
    init(viewModel: FeedImageViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
        title = viewModel.title
        loadFeed()
    }
    
    private func loadFeed() {
        viewModel.load()
    }
    
    private func setupCollectionView() {
        self.view.addSubview(collectionView)
        collectionView.register(ImageCollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        collectionView.delegate = self
        collectionView.dataSource = self
        NSLayoutConstraint.activate([
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

    // MARK: UICollectionViewDataSource

     func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }


     func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cellControllers.count
    }

     func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = cellControllers[indexPath.row].view(for: collectionView, indexpath: indexPath)
        return cell
    }
}

extension ImageFeedCollectionViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (view.frame.size.width/2 - 3), height: (view.frame.size.height/3 - 3))
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
        if (indexPath.row == cellControllers.count - 1) {
            viewModel.load()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegate?.didSelect(feed: cellControllers[indexPath.row].feed, on: self)
    }
}
