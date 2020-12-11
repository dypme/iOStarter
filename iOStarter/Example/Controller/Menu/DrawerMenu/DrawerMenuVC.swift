//
//  DrawerMenuVC.swift
//  iOStarter
//
//  Created by Crocodic MBP-2 on 25/07/18.
//  Copyright © 2018 WahyuAdyP. All rights reserved.
//

import UIKit

/// Class view controller for side menu
class DrawerMenuVC: TableViewController {

    // MARK: - Property
    @IBOutlet weak var photoView: UIImageView!
    @IBOutlet weak var nameLbl: UILabel!
    
    fileprivate let menuIdentifier = "DrawerMenuCell"
    
    // MARK: - Data
    var viewModel = MenuVM()
    
    var currentMenu: Int = 0
    
    // MARK: - Starting
    override func setupView() {
        super.setupView()
        
        viewModel.setPhotoProfile(in: photoView)
        nameLbl.text = viewModel.name
    }
    
    // MARK: - Action
    func refresh() {
        viewModel = MenuVM()
        
        setupView()
        
        tableView.reloadData()
    }
    
    func updatePosition(indexPath: IndexPath) {
        let type = viewModel.typeOfMenu(at: indexPath.row)
        switch type {
        case .logout:
            self.presentAlert(title: nil, message: "Apakah Anda yakin ingin keluar?", action: { [weak self] in
                UserSession.shared.setLoggedOut()
                if let root = AppDelegate.shared.window?.rootViewController, root is LoginVC {
                    AppDelegate.shared.mainVC?.dismiss(animated: true, completion: nil)
                } else {
                    let vc = StoryboardScene.Auth.loginVC.instantiate()
                    vc.modalPresentationStyle = .fullScreen
                    self?.present(vc, animated: true, completion: nil)
                }
            })
        default:
            currentMenu = indexPath.row
            
            if let vc = viewModel.viewControllerForDrawerMenu(at: indexPath) {
                DrawerMenu.shared.setCenter(vc)
            }
            break
        }
        
        tableView.reloadData()
        DrawerMenu.shared.closeDrawer()
    }


}

// MARK: TableView DataSource
extension DrawerMenuVC {
    override var numberOfItems: Int {
        return viewModel.numberOfMenus
    }

    override func cellOfItem(_ tableView: UITableView, at indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: menuIdentifier, for: indexPath) as! DrawerMenuCell
        cell.viewModel = viewModel.viewModelOfMenu(at: indexPath)
        cell.selectedIndicatorView.isHidden = indexPath.row != currentMenu
        return cell
    }
    
    override func didSelect(_ tableView: UITableView, at indexPath: IndexPath) {
        updatePosition(indexPath: indexPath)
    }
}
