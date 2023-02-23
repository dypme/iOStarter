//
//  GridVC.swift
//  iOStarter
//
//  Created by MBP2022_1 on 15/02/23.
//  Copyright © 2023 dypme. All rights reserved.
//

import UIKit
import Reusable

class GridVC: CollectionViewController {

    let viewModel = ListVM()
    
    override func registerCell() {
        collectionView.register(cellType: GridCell.self)
    }
    
    override func fetch(isLoadMore: Bool = false) async {
        collectionView.backgroundView = loadingView
        await viewModel.fetch(isLoadMore: isLoadMore)
        refreshControl.endRefreshing()
        collectionView.backgroundView = errorView
        collectionView.reloadData()
    }
}

extension GridVC {
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModel.numberOfItems
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: GridCell = collectionView.dequeueReusableCell(for: indexPath)
        cell.viewModel = viewModel.viewModelOfItem(at: indexPath)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = DetailVC(viewModel: viewModel.viewModelOfItem(at: indexPath))
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension GridVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        fitItemSize(collectionView, layout: collectionViewLayout, minimumSize: CGSize(width: 200, height: 200), minimumColumn: 2)
    }
}
