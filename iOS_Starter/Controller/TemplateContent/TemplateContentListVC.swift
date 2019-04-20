
//
//  ContentListVC.swift
//  iOS_Starter
//
//  Created by Crocodic MBP-2 on 26/07/18.
//  Copyright © 2018 Crocodic. All rights reserved.
//

import UIKit

/// Template of list your content data. Copy this file more recommended than modify this file for your new list controller
class TemplateContentListVC: UIViewController {

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var activityId: UIActivityIndicatorView!
    
    var viewModel = TemplateContentVM()
    
    let refreshControl = UIRefreshControl()
    private let cellIdentifier = "TemplateContentCell"
    
    /// This is example use to push view controller if this view embed in other view, you must pass navigation controller from view that embed this view because if this view embeded, this view doesn't have navigation controller that use for push viewcontroller
    ///
    /// You can delete this if you use this template and not use this view in other view
    var navController: UINavigationController?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupMethod()
        setupView()
        
        fetch()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /// Setup add function/ action in object (ex: add button action, add delegate, add gesture)
    func setupMethod() {
        tableView.dataSource = self
        tableView.delegate = self
        
        searchBar.delegate = self
        
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
    }
    
    /// Setup layout view
    func setupView() {
        tableView.addSubview(refreshControl)
    }
    
    /// Refresh content in list
    @objc func refresh() {
        fetch(isRefresh: true)
    }
    
    /// Get data list content
    ///
    /// - Parameter isRefresh: Pass true to get data from first and false to get load more content
    func fetch(isRefresh: Bool = false, isLoadMore: Bool = false) {
        if viewModel.isContentsEmpty {
            activityId.startAnimating()
        }
        
        ErrorView.shared.removeView()
        let searchText = searchBar.text!
        viewModel.fetch(isRefresh: isRefresh, isLoadMore: isLoadMore,  searchText: searchText) { (message) in
            self.activityId.stopAnimating()
            self.refreshControl.endRefreshing()
            
            if self.viewModel.isContentsEmpty {
                self.tableView.setErrorView(message: message, tapReload: {
                    self.fetch(isRefresh: isRefresh)
                })
            }
            
            self.tableView.reloadData()
            
            self.tableView.activityLoadMore(isHidden: !self.viewModel.canLoadMore)
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

extension TemplateContentListVC: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        view.endEditing(true)
        
        fetch(isRefresh: true)
    }
}

extension TemplateContentListVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfItems
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! TemplateContentCell
        cell.viewModel = viewModel.viewModelOfItem(at: indexPath)
        return cell
    }
}

extension TemplateContentListVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = StoryboardScene.TemplateContent.templateContentDetailVC.instantiate()
        vc.viewModel = viewModel.viewModelOfItem(at: indexPath)
        
        // This for handle push view controller when view in other view or not
        // You can delete this, this just use example, because TabBarStrip using this view as content
        let navController = self.navController == nil ? self.navigationController : self.navController
        
        navController?.pushViewController(vc, animated: true)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == viewModel.numberOfItems - 1 && viewModel.canLoadMore {
            fetch(isRefresh: false, isLoadMore: true)
        }
    }
}
