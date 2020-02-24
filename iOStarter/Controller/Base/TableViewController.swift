//
//  TableListController.swift
//  iOStarter
//
//  Created by macbook on 14/05/19.
//  Copyright © 2019 WahyuAdyP. All rights reserved.
//

import UIKit

class TableViewController: ViewController {
    
    @IBOutlet weak private(set) var tableView: UITableView!
    
    private(set) var refreshControl = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func setupMethod() {
        super.setupMethod()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        refreshControl.addTarget(self, action: #selector(fetch), for: .valueChanged)
    }
    
    override func setupView() {
        super.setupView()
        
        tableView.addSubview(refreshControl)
    }
    
    @objc override func fetch() {
        super.fetch()
        
        fetch(isLoadMore: false)
    }
    
    /// Fetch list data
    @objc func fetch(isLoadMore: Bool = false) {
        
    }
    
}

extension TableViewController {
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
    @objc open func didSelect(_ tableView: UITableView, at indexPath: IndexPath) {
        
    }
}

extension TableViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return numberOfItems
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return cellOfItem(tableView, at: indexPath)
    }
}

extension TableViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        didSelect(tableView, at: indexPath)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offset = scrollView.contentOffset
        let bounds = scrollView.bounds
        let size = scrollView.contentSize
        let inset = scrollView.contentInset
        let y = offset.y + bounds.size.height - inset.bottom
        let h = size.height
        let reload_distance:CGFloat = 20.0
        if y > (h + reload_distance) {
            if canLoadMore {
                fetch(isLoadMore: true)
            }
        }
    }
}
