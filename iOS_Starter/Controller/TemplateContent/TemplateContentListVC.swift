
//
//  ContentListVC.swift
//  iOS_Starter
//
//  Created by Crocodic MBP-2 on 26/07/18.
//  Copyright © 2018 Crocodic. All rights reserved.
//

import UIKit

/// Template of list your content data. Copy this file more recommended than modify this file for your new list controller
class TemplateContentListVC: StandardListController {

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var activityId: UIActivityIndicatorView!
    
    var viewModel = TemplateContentVM()
    
    private let cellIdentifier = "TemplateContentCell"
    
    /// This is example use to push view controller if this view embed in other view, you must pass navigation controller from view that embed this view because if this view embeded, this view doesn't have navigation controller that use for push viewcontroller
    ///
    /// You can delete this if you use this template and not use this view in other view
    var navController: UINavigationController?
    
    /// Setup add function/ action in object (ex: add button action, add delegate, add gesture)
    override func setupMethod() {
        super.setupMethod()
        
        searchBar.delegate = self
    }
    
    /// Setup layout view
    override func setupView() {
        super.setupView()
    }
    
    /// Get data list content
    ///
    /// - Parameter isRefresh: Pass true to get data from first and false to get load more content
    override func fetch(isLoadMore: Bool = false) {
        if viewModel.numberOfItems == 0 {
            activityId.startAnimating()
        }
        
        ErrorView.shared.removeView()
        let searchText = searchBar.text!
        viewModel.fetch(isLoadMore: isLoadMore, searchText: searchText) { [weak self] (message) in
            self?.activityId.stopAnimating()
            self?.refreshControl.endRefreshing()
            
            if self?.viewModel.numberOfItems == 0 {
                self?.tableView.setErrorView(message: message, tapReload: {
                    self?.fetch(isLoadMore: isLoadMore)
                })
            }
            
            self?.tableView.reloadData()
            
            self?.tableView.activityLoadMore(isHidden: !(self?.viewModel.canLoadMore ?? false))
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
        
        fetch()
    }
}

extension TemplateContentListVC {
    override var canLoadMore: Bool {
        return viewModel.canLoadMore
    }
    
    override var numberOfItems: Int {
        return viewModel.numberOfItems
    }
    
    override func cellOfItem(_ tableView: UITableView, at indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! TemplateContentCell
        cell.viewModel = viewModel.viewModelOfItem(at: indexPath)
        return cell
    }
    
    override func didSelectRow(_ tableView: UITableView, at indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        if indexPath.row % 2 == 0 {
            baseAlertShow(title: "Alert", message: "Content of alert", action: nil)
        } else {
            let alert = UIAlertController(title: "Alert", message: "Content of alert", preferredStyle: .alert)
            let cancel = UIAlertAction(title: "Cancel", style: .default, handler: nil)
            let submit = UIAlertAction(title: "Submit", style: .default, handler: nil)
            alert.addAction(cancel)
            alert.addAction(submit)
            self.present(alert, animated: true, completion: nil)
        }
        
        return;
        let vc = StoryboardScene.TemplateContent.templateContentDetailVC.instantiate()
        vc.viewModel = viewModel.viewModelOfItem(at: indexPath)
        
        // This for handle push view controller when view in other view or not
        // You can delete this, this just use example, because TabBarStrip using this view as content
        let navController = self.navController == nil ? self.navigationController : self.navController
        
        navController?.pushViewController(vc, animated: true)
    }
}
