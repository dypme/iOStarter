//
//  TabStripVM.swift
//  iOS_Starter
//
//  Created by Crocodic MBP-2 on 01/08/18.
//  Copyright © 2018 Crocodic. All rights reserved.
//

import Foundation
import UIKit

class TabStripVM {
    private var viewControllers = [UIViewController]()
    
    /// Initialization
    init() {
        
    }
    
    /// Setup data content that use to present
    ///
    /// - Parameter navController: Pass navigation controller that can be use for pushing view controller from content tab, if your content view controller no need push view controller you no need pass navigation controller
    func setContent(pushWith navController: UINavigationController?) {
        // Change with your viewcontroller use
        let content = StoryboardScene.TemplateContent.templateContentListVC
            .instantiate()
        // Example using push view controller from content view controller. Pass the active navigation controller is one of many ways that can use for pushing view controller, because content of tab doesn't have navigation controller.
        content.navController = navController
        content.title = "Template Content"
        let history = StoryboardScene.TemplateContent.templateContentListVC
            .instantiate()
        // Example using push view controller from content view controller. Pass the active navigation controller is one of many ways that can use for pushing view controller, because content of tab doesn't have navigation controller.
        history.navController = navController
        history.title = "Template History"
        viewControllers.append(content)
        viewControllers.append(history)
    }
    
    /// Number of content in tab strip
    var numberOfTabs: Int {
        return viewControllers.count
    }
    
    /// View that use in content if tab
    ///
    /// - Parameter index: Position of tab strip to identity view used
    /// - Returns: View of index
    func viewOfTab(at index: Int) -> UIView {
        let viewController = viewControllers[index]
        return viewController.view
    }
    
    /// Title for every tab strip
    ///
    /// - Parameter index: Position of tab strip to identity title used
    /// - Returns: Title of tab
    func titleOfTab(at index: Int) -> String {
        let viewController = viewControllers[index]
        return viewController.title ?? ""
    }
}
