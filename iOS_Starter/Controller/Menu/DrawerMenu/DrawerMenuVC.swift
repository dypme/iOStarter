//
//  DrawerMenuVC.swift
//  iOS_Starter
//
//  Created by Crocodic MBP-2 on 25/07/18.
//  Copyright © 2018 Crocodic. All rights reserved.
//

import UIKit

/// Class view controller for side menu
class DrawerMenuVC: UIViewController {

    @IBOutlet weak var photoView: UIImageView!
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    fileprivate let menuIdentifier = "DrawerMenuCell"
    
    var viewModel = MenuVM()
    
    var currentMenu: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupMethod()
        setupView()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setupMethod() {
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    func setupView() {
        viewModel.setPhotoProfile(in: photoView)
        nameLbl.text = viewModel.name
    }
    
    func refresh() {
        viewModel = MenuVM()
        
        setupView()
        
        tableView.reloadData()
    }
    
    func updatePosition(indexPath: IndexPath) {
        let type = viewModel.typeOfMenu(at: indexPath.row)
        switch type {
        case .logout:
            self.cAlertShow(title: nil, message: "Apakah Anda yakin ingin keluar?", isCancelable: true) {
                UserSession.shared.setLoggedOut()
                if let root = AppDelegate.shared.window?.rootViewController, root is LoginVC {
                    AppDelegate.shared.mainVC?.dismiss(animated: true, completion: nil)
                } else {
                    let vc = StoryboardScene.Auth.loginVC.instantiate()
                    self.present(vc, animated: true, completion: nil)
                }
            }
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

extension DrawerMenuVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfMenus
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: menuIdentifier, for: indexPath) as! DrawerMenuCell
        cell.viewModel = viewModel.viewModelOfMenu(at: indexPath)
        cell.selectedIndicatorView.isHidden = indexPath.row != currentMenu
        return cell
    }
}

extension DrawerMenuVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        updatePosition(indexPath: indexPath)
    }
}
