//
//  ListVC.swift
//  iOStarter
//
//  Created by MBP2022_1 on 14/02/23.
//  Copyright © 2023 dypme. All rights reserved.
//

import UIKit

class ListVC: TableViewController {

    let viewModel = ListVM()
    
    override func registerCell() {
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }
    
    override func fetch(isLoadMore: Bool = false) async {
        viewModel.fetch(isLoadMore: isLoadMore)
        tableView.reloadData()
    }
    
}

extension ListVC {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.numberOfItems
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = viewModel.viewModelOfItem(at: indexPath).name
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = DetailVC(viewModel: viewModel.viewModelOfItem(at: indexPath))
        navigationController?.pushViewController(vc, animated: true)
    }
}
