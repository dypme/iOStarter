//
//  GridCell.swift
//  iOStarter
//
//  Created by MBP2022_1 on 15/02/23.
//  Copyright © 2023 dypme. All rights reserved.
//

import UIKit
import Reusable

class GridCell: UICollectionViewCell, NibReusable {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var detailLbl: UILabel!
    
    var viewModel: ItemVM! {
        didSet {
            imageView.kf.setImage(with: viewModel.imageUrl)
            nameLbl.text = viewModel.name
            detailLbl.text = viewModel.detail
        }
    }

}
