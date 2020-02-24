//
//  DrawerMenuCell.swift
//  iOStarter
//
//  Created by Crocodic MBP-2 on 25/07/18.
//  Copyright © 2018 WahyuAdyP. All rights reserved.
//

import UIKit

class DrawerMenuCell: UITableViewCell {

    @IBOutlet weak var selectedIndicatorView: UIView!
    @IBOutlet weak var iconView: UIImageView!
    @IBOutlet weak var nameLbl: UILabel!
    
    var viewModel: MenuItemVM = MenuItemVM() {
        didSet {
            setupView()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    private func setupView() {
        iconView.image = viewModel.image
        nameLbl.text = viewModel.name
    }
}
