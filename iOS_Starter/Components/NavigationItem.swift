//
//  NavigationItem.swift
//  iOS_Starter
//
//  Created by Crocodic Studio on 30/08/19.
//  Copyright © 2019 Crocodic Studio. All rights reserved.
//

import UIKit

class NavigationItem: UINavigationItem {
    
    override var title: String? {
        didSet {
            updateTitle()
        }
    }
    
    var titleFont: UIFont? = NavAppearance.shared.titleFont {
        didSet {
            updateTitle()
        }
    }
    
    var titleColor: UIColor? = NavAppearance.shared.titleColor {
        didSet {
            updateTitle()
        }
    }
    
    var subtitle: String? {
        didSet {
            updateTitle()
        }
    }
    
    var subtitleFont: UIFont? = NavAppearance.shared.subtitleFont {
        didSet {
            updateTitle()
        }
    }
    
    var subtitleColor: UIColor? = NavAppearance.shared.subtitleColor {
        didSet {
            updateTitle()
        }
    }
    
    var image: UIImage? {
        didSet {
            updateTitle()
        }
    }
    
    var textAlignment: NSTextAlignment = NavAppearance.shared.textAlignment {
        didSet {
            updateTitle()
        }
    }
    
    override var leftBarButtonItem: UIBarButtonItem? {
        didSet {
            updateTitle()
        }
    }
    
    override var leftBarButtonItems: [UIBarButtonItem]? {
        didSet {
            updateTitle()
        }
    }
    
    override var rightBarButtonItem: UIBarButtonItem? {
        didSet {
            updateTitle()
        }
    }
    
    override var rightBarButtonItems: [UIBarButtonItem]? {
        didSet {
            updateTitle()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        updateTitle()
    }
    
    private func updateTitle() {
        var leftItems  = self.leftBarButtonItems ?? []
        var rightItems = self.rightBarButtonItems ?? []
        
        func clearTitle() {
            titleView = nil
            if let index = leftItems.firstIndex(where: { $0.customView?.tag == 1209 }) {
                leftItems.remove(at: index)
            }
            if let index = rightItems.firstIndex(where: { $0.customView?.tag == 1209 }) {
                rightItems.remove(at: index)
            }
        }
        
        let hStackView     = UIStackView()
        hStackView.tag     = 1209
        hStackView.axis    = .horizontal
        hStackView.spacing = 4
        
        let imageView         = UIImageView(image: image)
        imageView.isHidden    = image == nil
        imageView.contentMode = .scaleAspectFit
        
        let vStackView     = UIStackView()
        vStackView.axis    = .vertical
        vStackView.spacing = 0
        
        let titleLabel           = UILabel()
        titleLabel.isHidden      = title == nil || title == ""
        titleLabel.text          = title
        titleLabel.font          = titleFont
        titleLabel.textColor     = titleColor
        titleLabel.textAlignment = textAlignment
        
        let subtitleLabel           = UILabel()
        subtitleLabel.isHidden      = subtitle == nil || subtitle == ""
        subtitleLabel.text          = subtitle
        subtitleLabel.font          = subtitleFont ?? titleLabel.font.withSize(titleLabel.font.pointSize * 4 / 5)
        subtitleLabel.textColor     = subtitleColor
        subtitleLabel.textAlignment = textAlignment
        
        vStackView.addArrangedSubview(titleLabel)
        vStackView.addArrangedSubview(subtitleLabel)
        
        hStackView.addArrangedSubview(imageView)
        hStackView.addArrangedSubview(vStackView)
        
        clearTitle()
        let barButtonTitle = UIBarButtonItem(customView: hStackView)
        switch textAlignment {
        case .left:
            titleView = UIView()
            leftItems.append(barButtonTitle)
        case .right:
            titleView = UIView()
            rightItems.append(barButtonTitle)
        default:
            titleView = hStackView
        }
        
        self.setLeftBarButtonItems(leftItems, animated: false)
        self.setRightBarButtonItems(rightItems, animated: false)
    }
}

extension UIViewController {
    var navItem: NavigationItem? {
        return self.navigationItem as? NavigationItem
    }
}
