//
//  ExampleListVC.swift
//  iOStarter
//
//  Created by Crocodic Studio on 07/12/19.
//  Copyright © 2019 WahyuAdyP. All rights reserved.
//

import UIKit

class ExampleListVC: TableViewController {

    let viewModel = ExampleListVM()
    
    private let cellIdentifier = "cell"
    
    override func viewDidLoad() {
        super.viewDidLoad()

        fetch()
    }
    
    override func fetch(isLoadMore: Bool = false) {
        viewModel.fetch(isLoadMore: isLoadMore) { [weak self] (isSuccess, message) in
            self?.refreshControl.endRefreshing()
            self?.tableView.reloadData()
        }
    }
}

extension ExampleListVC {
    override var numberOfItems: Int {
        return viewModel.numberOfItems
    }
    
    override var canLoadMore: Bool {
        return viewModel.canLoadMore
    }
    
    override func cellOfItem(_ tableView: UITableView, at indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! ExampleCell
        cell.viewModel = viewModel.viewModelOfItem(at: indexPath)
        return cell
    }
    
    override func didSelect(_ tableView: UITableView, at indexPath: IndexPath) {
        let vc = StoryboardScene.Example.exampleDetailVC.instantiate()
        vc.viewModel = viewModel.viewModelOfItem(at: indexPath)
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
