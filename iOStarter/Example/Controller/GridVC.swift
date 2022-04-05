//
//  GridVC.swift
//  iOStarter
//
//  Created by Macintosh on 05/04/22.
//  Copyright © 2022 WahyuAdyP. All rights reserved.
//

import UIKit

class GridVC: CollectionViewController {
    let viewModel = ListVM()
    
    override func fetch(isLoadMore: Bool = false) {
        viewModel.fetch(isLoadMore: isLoadMore) { [weak self] backgroundView, footerView in
            self?.collectionView.backgroundView = backgroundView
        } fetchDidFinish: { [weak self] isSuccess, message in
            self?.collectionView.reloadData()
            self?.refreshControl.endRefreshing()
        }
    }
}

extension GridVC {
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModel.numberOfItems
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! ItemCell
        cell.viewModel = viewModel.viewModelOfItem(at: indexPath)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = StoryboardScene.Menu.exampleVC.instantiate()
        vc.viewModel = viewModel.viewModelOfItem(at: indexPath)
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
