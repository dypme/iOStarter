//
//  DetailVC.swift
//  iOStarter
//
//  Created by MBP2022_1 on 15/02/23.
//  Copyright © 2023 dypme. All rights reserved.
//

import UIKit

class DetailVC: ViewController {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var detailLbl: UILabel!
    
    let viewModel: ItemVM
    
    init(viewModel: ItemVM) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setupView() {
        super.setupView()
        
        navigationItem.title = L10n.Title.example
        imageView.kf.setImage(with: viewModel.imageUrl)
        nameLbl.text = viewModel.name
        detailLbl.text = viewModel.detail
    }
    
}
