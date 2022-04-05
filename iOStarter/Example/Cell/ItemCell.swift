//
//  ItemCell.swift
//  iOStarter
//
//  Created by Macintosh on 05/04/22.
//  Copyright © 2022 WahyuAdyP. All rights reserved.
//

import UIKit

class ItemCell: UICollectionViewCell {
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
