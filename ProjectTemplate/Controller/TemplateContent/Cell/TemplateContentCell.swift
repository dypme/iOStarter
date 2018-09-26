//
//  TemplateContentCell.swift
//  ProjectTemplate
//
//  Created by Crocodic MBP-2 on 27/07/18.
//  Copyright © 2018 Crocodic. All rights reserved.
//

import UIKit

class TemplateContentCell: UITableViewCell {
    
    @IBOutlet weak var photoView: UIImageView!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var detailLbl: UILabel!
    
    var viewModel: TemplateContentItemVM = TemplateContentItemVM() {
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
        viewModel.setPhoto(in: photoView)
        titleLbl.text = viewModel.name
        detailLbl.text = viewModel.detail
    }
}
