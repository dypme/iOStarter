//
//  CollectionViewController.swift
//  iOStarter
//
//  Created by Crocodic Studio on 09/12/19.
//  Copyright © 2019 WahyuAdyP. All rights reserved.
//

import UIKit

class CollectionViewController: ViewController {

    @IBOutlet weak private(set) var collectionView: UICollectionView!
    
    private(set) var refreshControl = UIRefreshControl()
    
    override func setupMethod() {
        super.setupMethod()
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        refreshControl.addTarget(self, action: #selector(fetch), for: .valueChanged)
    }
    
    override func setupView() {
        super.setupView()
        
        collectionView.addSubview(refreshControl)
    }
    
    @objc override func fetch() {
        super.fetch()
        
        fetch(isLoadMore: false)
    }
    
    /// Fetch list data
    @objc func fetch(isLoadMore: Bool = false) {
        
    }
}

extension CollectionViewController {
    /// Indicate that list can load more
    @objc open var isAllowLoadMore: Bool {
        false
    }
    
    /// Distance from bottom to trigger load more
    @objc open var loadMoreDistance: CGFloat {
        40
    }
}

extension CollectionViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        fatalError("Number items method not defined")
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        fatalError("Cell collectionView not set")
    }
}

extension CollectionViewController: UICollectionViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offset = scrollView.contentOffset
        let bounds = scrollView.bounds
        let size = scrollView.contentSize
        let inset = scrollView.contentInset
        let y = offset.y + bounds.size.height - inset.bottom
        let h = size.height
        if y > (h + loadMoreDistance) {
            if isAllowLoadMore {
                fetch(isLoadMore: true)
            }
        }
    }
}
