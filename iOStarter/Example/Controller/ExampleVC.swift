//
//  ExampleVC.swift
//  iOStarter
//
//  Created by Macintosh on 01/04/22.
//  Copyright © 2022 WahyuAdyP. All rights reserved.
//

import UIKit

class ExampleVC: ViewController {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var detailLbl: UILabel!
    
    var viewModel: ItemVM!
    
    override func setupView() {
        super.setupView()
        
        imageView.kf.setImage(with: viewModel.imageUrl)
        nameLbl.text = viewModel.name
        detailLbl.text = viewModel.detail
    }

}
