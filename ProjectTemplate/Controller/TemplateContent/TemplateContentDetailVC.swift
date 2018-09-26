//
//  TemplateContentDetailVC.swift
//  ProjectTemplate
//
//  Created by Crocodic MBP-2 on 27/07/18.
//  Copyright © 2018 Crocodic. All rights reserved.
//

import UIKit

class TemplateContentDetailVC: UIViewController {

    @IBOutlet weak var photoView: UIImageView!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var detailLbl: UILabel!
    
    var viewModel = TemplateContentItemVM()
    
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
        
    }
    
    func setupView() {
        navigationItem.title = viewModel.name
        
        viewModel.setPhoto(in: photoView)
        
        titleLbl.text = viewModel.name
        detailLbl.text = viewModel.detail
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
