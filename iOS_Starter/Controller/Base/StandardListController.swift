//
//  TableListController.swift
//  iOS_Starter
//
//  Created by macbook on 14/05/19.
//  Copyright © 2019 Crocodic. All rights reserved.
//

import UIKit

class StandardListController: UIViewController {
    
    @IBOutlet weak private(set) var tableView: UITableView!
    
    private(set) var refreshControl = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupMethod()
        setupView()
        
        fetch()
    }
    
    open func setupMethod() {
        tableView.delegate = self
        tableView.dataSource = self
        
        refreshControl.addTarget(self, action: #selector(fetch), for: .touchUpInside)
    }
    
    open func setupView() {
        tableView.addSubview(refreshControl)
    }
    
    /// Fetch list data
    @objc open func fetch(isLoadMore: Bool = false) {
        
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension StandardListController {
    /// Indicate that list can load more
    @objc open var canLoadMore: Bool {
        return false
    }
    
    /// Number of items property of data list
    @objc open var numberOfItems: Int {
        fatalError("Number items method not defined")
    }
    
    /// Instantiate cell identifier to tableview list
    ///
    /// - Parameters:
    ///   - tableView: Table view container
    ///   - indexPath: Indexpath position of cell
    /// - Returns: Tableviewcell that has instantiate
    @objc open func cellOfItem(_ tableView: UITableView, at indexPath: IndexPath) -> UITableViewCell {
        fatalError("Cell tableview not set")
    }
    
    /// Did select table view item
    ///
    /// - Parameters:
    ///   - tableView: Table view container
    ///   - indexPath: Indexpath position of cell
    @objc open func didSelectRow(_ tableView: UITableView, at indexPath: IndexPath) {
        
    }
}

extension StandardListController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return numberOfItems
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return cellOfItem(tableView, at: indexPath)
    }
}

extension StandardListController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        didSelectRow(tableView, at: indexPath)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == numberOfItems - 1 && canLoadMore {
            fetch(isLoadMore: true)
        }
    }
}
