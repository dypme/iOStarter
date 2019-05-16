//
//  MenuViewModel.swift
//  iOS_Starter
//
//  Created by Crocodic MBP-2 on 25/07/18.
//  Copyright © 2018 Crocodic. All rights reserved.
//

import Foundation
import UIKit
import Kingfisher

class MenuVM {
    private var menus = [Menu]()
    
    /// Number of column that used for in grid menu
    let numberOfColumn: CGFloat = 1
    /// Spacing in every cell item
    let cellSpacing: CGFloat    = 8
    
    /// Make height cell ratio of collectionview height, set 0 if want cell height fit with number of item
    let heightCellRatio: CGFloat = 0.35
    
    init() {
        let home = Menu(type: .home, name: "Home", image: "ic_home")
        let templateContent = Menu(type: .templateContent, name: "Template Content", image: "ic_list")
        let tabStripContent = Menu(type: .tabStripContent, name: "Content With Tab Strip", image: "ic_list")
        let profile = Menu(type: .profile, name: "Profile", image: "ic_account")
        let logout = Menu(type: .logout, name: "Logout", image: "ic_logout")
        menus.append(home)
        menus.append(templateContent)
        menus.append(tabStripContent)
        menus.append(profile)
        menus.append(logout)
    }
    
    /// Number of menu item
    var numberOfMenus: Int {
        return menus.count
    }
    
    /// Identity viewcontroller for every item
    ///
    /// - Parameter indexPath: Position of menu that want to get
    /// - Returns: UIViewController for selected menu
    func viewController(at indexPath: IndexPath) -> UIViewController? {
        let menu = menus[indexPath.row]
        return viewController(menu: menu)
    }
    
    /// View controller for each menu, make sure you return navigation controller if you use drawer menu
    ///
    /// - Parameter menu: Menu that want identity for viewcontroller
    /// - Returns: Viewcontroller of menu
    func viewController(menu: Menu) -> UIViewController? {
        switch menu.type {
        case .home:
            return StoryboardScene.Main.viewController.instantiate()
        case .templateContent:
            return StoryboardScene.TemplateContent.templateContentListVC.instantiate()
        case .profile:
            return StoryboardScene.Profile.profileVC.instantiate()
        case .tabStripContent:
            return StoryboardScene.TabStripPager.tabStripPagerVC.instantiate()
        default:
            return nil
        }
    }
    
    /// Example identity viewcontroller for every item for drawer menu
    ///
    /// - Parameter indexPath: Position of menu that want to get
    /// - Returns: UIViewController for selected menu
    func viewControllerForDrawerMenu(at indexPath: IndexPath) -> UIViewController? {
        let menu = menus[indexPath.row]
        return viewControllerForDrawerMenu(menu: menu)
    }
    
    /// Example function view controller for each menu for drawer menu type
    ///
    /// - Parameter menu: Menu that want identity for viewcontroller
    /// - Returns: Viewcontroller of menu
    func viewControllerForDrawerMenu(menu: Menu) -> UIViewController? {
        var navController: UINavigationController?
        switch menu.type {
        case .home:
            navController = StoryboardScene.Main.viewControllerNav.instantiate()
        case .templateContent:
            navController = StoryboardScene.TemplateContent.templateContentListVCNav
                .instantiate()
        case .profile:
            navController = StoryboardScene.Profile.profileVCNav.instantiate()
        case .tabStripContent:
            navController = StoryboardScene.TabStripPager.tabStripPagerVCNav
                .instantiate()
        default:
            navController = nil
        }
        // Add drawer bar button item for open drawer, You can add manually from your storyboard or when you no need drawer button add delete this
        navController?.topViewController?.navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "ic_drawer"), style: .plain, target: DrawerMenu.shared, action: #selector(DrawerMenu.shared.openDrawer))
        return navController
    }
    
    /// Get all view controller that not nil
    ///
    /// - Returns: Array of view controller
    var allMenuController: [UIViewController] {
        var viewControllers = [UIViewController]()
        
        for aMenu in menus {
            guard let vc = viewController(menu: aMenu) else { continue }
            let nc = StoryboardScene.Main.tabBarMenuVCNav.instantiate()
            nc.setViewControllers([vc], animated: false)
            let image = UIImage(named: aMenu.image)
            nc.tabBarItem = UITabBarItem(title: aMenu.name, image: image, selectedImage: nil)
            vc.navigationItem.title = aMenu.name
            viewControllers.append(nc)
        }
        
        return viewControllers
    }
    
    /// Type of menu with specific index
    ///
    /// - Parameter index: Position of menu that want to get
    /// - Returns: Menu type
    func typeOfMenu(at index: Int) -> Menu.MenuType {
        let menu = menus[index]
        return menu.type
    }
    
    /// Get view model item with specific menu
    ///
    /// - Parameter indexPath: Position of menu that select
    /// - Returns: View model menu item
    func viewModelOfMenu(at indexPath: IndexPath) -> MenuItemVM {
        let menu = menus[indexPath.row]
        return MenuItemVM(menu: menu)
    }
    
    /// Setting photo profile in view
    ///
    /// - Parameter view: image view that set the image
    func setPhotoProfile(in view: UIImageView) {
        if let image = UserSession.shared.profile?.image {
            if let url = URL(string: image) {
                view.kf.indicatorType = .activity
                view.kf.setImage(with: url, placeholder: #imageLiteral(resourceName: "blank_image"))
            } else {
                view.image = #imageLiteral(resourceName: "blank_image")
            }
        } else {
            view.image = #imageLiteral(resourceName: "blank_image")
        }
    }
    
    /// User profile name
    var name: String? {
        return UserSession.shared.profile?.name
    }
    
    func fetchImageSlider(onFailed: ((String) -> Void)?, onSuccess: (([String]) -> Void)?) {
        var sources = [String]()
        sources.append("https://images.pexels.com/photos/658687/pexels-photo-658687.jpeg?auto=compress&cs=tinysrgb&h=350")
        sources.append("https://www.jqueryscript.net/images/Simplest-Responsive-jQuery-Image-Lightbox-Plugin-simple-lightbox.jpg")
        sources.append("https://demo.phpgang.com/crop-images/demo_files/pool.jpg")
        onSuccess?(sources)
//        ApiHelper.shared.example(value: name ?? "") { (json, isSuccess, message) in
//            if isSuccess {
//                let data = json["data"].arrayValue
//                var sources = [String]()
//                for aData in data {
//                    let image = aData["image"].stringValue
//                    sources.append(image)
//                }
//                success?(sources)
//            } else {
//                onFailed?(message)
//            }
//        }
    }
    
    /// Calculate size for grid cell menu
    ///
    /// - Parameter collectionView: Collection view that want item resizing
    /// - Returns: Size of item
    func sizeOfCell(in collectionView: UICollectionView) -> CGSize {
//        collectionView.contentInset = UIEdgeInsets(top: cellSpacing, left: cellSpacing, bottom: cellSpacing, right: cellSpacing)
        
        let width: CGFloat = (collectionView.frame.size.width - (cellSpacing * (numberOfColumn + 1))) / numberOfColumn
        
        var height: CGFloat = width
        if numberOfColumn == 1.0 {
            if heightCellRatio == 0.0 {
                height = (collectionView.frame.height - (cellSpacing * CGFloat(menus.count + 1))) / CGFloat(menus.count)
            } else {
                height = (collectionView.frame.height - (cellSpacing * CGFloat(menus.count + 1))) * heightCellRatio
            }
        }
        
        return CGSize(width: width, height: height)
    }
}
