//
//  NavigationItem.swift
//  iOStarter
//
//  Created by Crocodic Studio on 30/08/19.
//  Copyright © 2019 WahyuAdyP. All rights reserved.
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
    
    override func setRightBarButton(_ item: UIBarButtonItem?, animated: Bool) {
        super.setRightBarButton(item, animated: animated)
        
        updateTitle()
    }
    
    override func setLeftBarButton(_ item: UIBarButtonItem?, animated: Bool) {
        super.setLeftBarButton(item, animated: animated)
        
        updateTitle()
    }
    
    // Components
    private var hStackView: UIStackView = {
        let stackView     = UIStackView()
        stackView.tag     = 1209
        stackView.axis    = .horizontal
        stackView.spacing = 4
        return stackView
    }()
    
    private var vStackView: UIStackView = {
        let stackView     = UIStackView()
        stackView.tag     = 1219
        stackView.axis    = .vertical
        stackView.spacing = 0
        return stackView
    }()
    
    private var imageView: UIImageView = {
        let imageView         = UIImageView(frame: .zero)
//        imageView.backgroundColor = .red
        imageView.tag         = 1220
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private var titleLabel: UILabel = {
        let titleLabel = UILabel()
//        titleLabel.backgroundColor = .green
        titleLabel.tag = 1319
        return titleLabel
    }()
    
    private var subtitleLabel: UILabel = {
        let subtitleLabel = UILabel()
//        subtitleLabel.backgroundColor = .yellow
        subtitleLabel.tag = 1320
        return subtitleLabel
    }()
    
    override init(title: String) {
        super.init(title: title)
        
        initComponents()
        updateTitle()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        initComponents()
        updateTitle()
    }
    
    private func initComponents() {
        vStackView.addArrangedSubview(titleLabel)
        vStackView.addArrangedSubview(subtitleLabel)
        
        hStackView.addArrangedSubview(imageView)
        hStackView.addArrangedSubview(vStackView)
    }
    
    private func updateTitle() {
        var leftItems  = self.leftBarButtonItems?.filter({ $0.customView != hStackView }) ?? []
        var rightItems = self.rightBarButtonItems?.filter({ $0.customView != hStackView }) ?? []
        
        imageView.image    = image
        imageView.isHidden = image == nil
        imageView.sizeToFit()
        
        titleLabel.isHidden      = title == nil || title == ""
        titleLabel.text          = title
        titleLabel.font          = titleFont
        titleLabel.textColor     = titleColor
        titleLabel.textAlignment = textAlignment
        titleLabel.sizeToFit()
        
        subtitleLabel.isHidden      = subtitle == nil || subtitle == ""
        subtitleLabel.text          = subtitle
        subtitleLabel.font          = subtitleFont ?? titleLabel.font.withSize(titleLabel.font.pointSize * 4 / 5)
        subtitleLabel.textColor     = subtitleColor
        subtitleLabel.textAlignment = textAlignment
        subtitleLabel.sizeToFit()
        
        vStackView.frame = .zero
        vStackView.frame.size = CGSize(width: max(titleLabel.frame.width, subtitleLabel.frame.width), height: titleLabel.frame.height + subtitleLabel.frame.height)
        
        hStackView.frame = .zero
        hStackView.frame.size = CGSize(width: imageView.frame.width + 4 + vStackView.frame.width, height: max(vStackView.frame.height, imageView.frame.height))
        
        let barButtonTitle = UIBarButtonItem(customView: hStackView)
        switch textAlignment {
        case .left:
            titleView = UIView(frame: .zero)
            leftItems.append(barButtonTitle)
        case .right:
            titleView = UIView(frame: .zero)
            rightItems.append(barButtonTitle)
        default:
            titleView = hStackView
        }
        
        super.setLeftBarButtonItems(leftItems, animated: false)
        super.setRightBarButtonItems(rightItems, animated: false)
    }
}

extension UIViewController {
    var navItem: NavigationItem? {
        return self.navigationItem as? NavigationItem
    }
}
