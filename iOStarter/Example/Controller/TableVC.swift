//
//  TableVC.swift
//  iOStarter
//
//  Created by Macintosh on 05/04/22.
//  Copyright © 2022 WahyuAdyP. All rights reserved.
//

import UIKit

class TableVC: TableViewController {
    let viewModel = ListVM()
    
    override func fetch(isLoadMore: Bool = false) {
        viewModel.fetch(isLoadMore: isLoadMore) { [weak self] backgroundView, footerView in
            self?.tableView.backgroundView = backgroundView
            self?.tableView.tableFooterView = footerView
        } fetchDidFinish: { [weak self] isSuccess, message in
            self?.tableView.reloadData()
            self?.refreshControl.endRefreshing()
        }
    }
}

extension TableVC {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.numberOfItems
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = viewModel.viewModelOfItem(at: indexPath).name
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = StoryboardScene.Menu.exampleVC.instantiate()
        vc.viewModel = viewModel.viewModelOfItem(at: indexPath)
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
