//
//  ZoomSlider.swift
//  iOStarter
//
//  Created by Crocodic-MBP5 on 01/02/20.
//  Copyright © 2020 Crocodic Studio. All rights reserved.
//

import UIKit

class ZoomSlider: UISlider {

    private var zoomLabel: UILabel = {
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: 34, height: 34))
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 11)
        label.text = "1x"
        label.backgroundColor = .darkGray
        label.textColor = .white
        label.layer.borderColor = UIColor.white.cgColor
        label.layer.borderWidth = 1.5
        label.layer.cornerRadius = 17
        label.clipsToBounds = true
        return label
    }()
    
    private var minusView: UILabel {
        let label = UILabel()
        label.textAlignment = .center
        label.text = "-"
        label.textColor = .white
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.sizeToFit()
        let maxSize = max(label.frame.size.width, label.frame.size.height)
        label.frame.size = CGSize(width: maxSize, height: maxSize)
        return label
    }
    
    private var plusView: UILabel {
        let label = UILabel()
        label.textAlignment = .center
        label.text = "+"
        label.textColor = .white
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.sizeToFit()
        let maxSize = max(label.frame.size.width, label.frame.size.height)
        label.frame.size = CGSize(width: maxSize, height: maxSize)
        return label
    }
    
    override var value: Float {
        didSet {
            sliderValueChanged(self)
        }
    }

    init() {
        super.init(frame: .zero)
        
        setupMethod()
        setupView()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupMethod()
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        setupMethod()
        setupView()
    }
    
    private func setupView() {
        setThumbImage(zoomLabel.image, for: UIControl.State())
        minimumValueImage = minusView.image
        maximumValueImage = plusView.image
        minimumTrackTintColor = UIColor.lightGray.withAlphaComponent(0.5)
        maximumTrackTintColor = UIColor.lightGray.withAlphaComponent(0.5)
    }
    
    private func setupMethod()  {
        self.addTarget(self, action: #selector(sliderValueChanged(_:)), for: .valueChanged)
    }
    
    @objc private func sliderValueChanged(_ slider: ZoomSlider) {
        let text = String(format: "%.1fx", value).replacingOccurrences(of: ".0", with: "")
        zoomLabel.text = text
        setThumbImage(zoomLabel.image, for: UIControl.State())
        
        show()
    }
    
    private func show() {
        self.alpha = 1.0
        self.isHidden = false
        
        NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(hide), object: nil)
        self.layer.removeAllAnimations()
        
        if value > 1 {
            return
        }
        
        perform(#selector(hide), with: nil, afterDelay: 4)
    }
    
    @objc private func hide() {
        UIView.animate(withDuration: 0.5, delay: 0, options: .allowUserInteraction, animations: {
            self.alpha = 0.0
        }) { (isFinished) in
            if isFinished {
                self.isHidden = true
            }
        }
    }
}

private extension UILabel {
    var image: UIImage? {
        UIGraphicsBeginImageContextWithOptions(self.bounds.size, false, 0.0)
        self.layer.render(in: UIGraphicsGetCurrentContext()!)
        let img = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return img
    }
}
