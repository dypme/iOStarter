//
//  TabStripPagerVC.swift
//  iOS-Starter
//
//  Created by Crocodic MBP-2 on 01/08/18.
//  Copyright © 2018 Crocodic. All rights reserved.
//

import UIKit

class TabStripPagerVC: UIViewController {

    @IBOutlet weak var viewPager: WormTabStrip!
    
    let viewModel = TabStripVM()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupMethod()
        setupView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /// Setup add function/ action in object (ex: add button action, add delegate, add gesture)
    func setupMethod() {
        viewPager.delegate = self
    }
    
    /// Setup layout view
    func setupView() {
        viewModel.setContent(pushWith: self.navigationController)
        
        viewPager.buildUI()
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

extension TabStripPagerVC: WormTabStripDelegate {
    func wtsNumberOfTabs() -> Int {
        return viewModel.numberOfTabs
    }
    
    func wtsViewOfTab(index: Int) -> UIView {
        return viewModel.viewOfTab(at: index)
    }
    
    func wtsTitleForTab(index: Int) -> String {
        return viewModel.titleOfTab(at: index)
    }
    
    func wtsReachedLeftEdge(panParam: UIPanGestureRecognizer) {
        
    }
    
    func wtsReachedRightEdge(panParam: UIPanGestureRecognizer) {
        
    }
}
