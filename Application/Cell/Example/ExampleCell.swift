//
//  ExampleCell.swift
//  iOS_Starter
//
//  Created by Crocodic Studio on 07/12/19.
//  Copyright © 2019 Crocodic Studio. All rights reserved.
//

import UIKit

class ExampleCell: UITableViewCell {

    var viewModel: ExampleItemVM! {
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
    
    func setupView() {
        imageView?.kf.setImage(with: viewModel.photo)
        textLabel?.text = viewModel.name
    }

}
