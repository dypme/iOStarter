//
//  ImagePagerView.swift
//  iOS-Starter
//
//  Created by Crocodic MBP-2 on 09/08/18.
//  Copyright © 2018 Crocodic. All rights reserved.
//

import UIKit
import FSPagerView
import Kingfisher

/// View to provide FSPagerView and FSPageControl in 1 view and make simple use, just initialize this view or change view to this class, and you get slider banner view
class ImagePagerView: UIView {

    private var pagerView: FSPagerView?
    var pageControl: FSPageControl?
    
    /// Data of view pager
    private var images: [Any] = [Any]()
    
    /// The transformer of the pager view.
    open var transformer: FSPagerViewTransformer? {
        didSet {
            self.pagerView?.transformer = transformer
        }
    }
    
    /// Customize tranform animation size
    open var transfomerType: FSPagerViewTransformerType? {
        didSet {
            guard let transfomerType = self.transfomerType else {
                itemSize = .zero
                return
            }
            transformer = FSPagerViewTransformer(type: transfomerType)
            switch transfomerType {
            case .crossFading, .zoomOut, .depth:
                itemSize = .zero // 'Zero' means fill the size of parent
            case .linear, .overlap:
                let transform = CGAffineTransform(scaleX: 0.6, y: 0.75)
                itemSize = self.frame.size.applying(transform)
            case .ferrisWheel, .invertedFerrisWheel:
                itemSize = CGSize(width: 180, height: 140)
            case .coverFlow:
                itemSize = CGSize(width: 220, height: 170)
            case .cubic:
                let transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
                itemSize = self.frame.size.applying(transform)
            }
        }
    }
    
    /// The time interval of automatic sliding. 0 means disabling automatic sliding. Default is 0.
    @IBInspectable
    open var automaticSlidingInterval: CGFloat = 0.0 {
        didSet {
            self.pagerView?.automaticSlidingInterval = self.automaticSlidingInterval
        }
    }
    
    /// The spacing to use between items in the pager view. Default is 0.
    @IBInspectable
    open var interitemSpacing: CGFloat = 0 {
        didSet {
            self.pagerView?.interitemSpacing = self.interitemSpacing
        }
    }
    
    /// The item size of the pager view. .zero means always fill the bounds of the pager view. Default is .zero.
    @IBInspectable
    open var itemSize: CGSize = .zero {
        didSet {
            self.pagerView?.itemSize = self.itemSize
        }
    }
    
    /// A Boolean value indicates that whether the pager view has infinite items. Default is false.
    @IBInspectable
    open var isInfinite: Bool = false {
        didSet {
            self.pagerView?.isInfinite = self.isInfinite
        }
    }
    
    /// A Boolean value that determines whether bouncing always occurs when horizontal scrolling reaches the end of the content view.
    @IBInspectable
    open var alwaysBounceHorizontal: Bool = false {
        didSet {
            self.pagerView?.alwaysBounceHorizontal = self.alwaysBounceHorizontal;
        }
    }
    
    /// A Boolean value that determines whether bouncing always occurs when vertical scrolling reaches the end of the content view.
    @IBInspectable
    open var alwaysBounceVertical: Bool = false {
        didSet {
            self.pagerView?.alwaysBounceVertical = self.alwaysBounceVertical;
        }
    }
    
    /// Selects the item at the specified index and optionally scrolls it into view.
    ///
    /// - Parameters:
    ///   - index: The index path of the item to select.
    ///   - animated: Specify true to animate the change in the selection or false to make the change without animating it.
    @objc(selectItemAtIndex:animated:)
    open func selectItem(at index: Int, animated: Bool) {
        pagerView?.selectItem(at: index, animated: animated)
    }
    
    private var didSelectItemAction: ((Int) -> Void)?
    func didSelectItem(action: ((Int) -> Void)?) {
        didSelectItemAction = action
    }
    
    /// Initializes and returns a newly allocated view object
    init() {
        super.init(frame: .zero)
        
        setupPager(frame: .zero)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupPager(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        setupPager(frame: .zero)
    }
    
    override func layoutSubviews() {
        pagerView?.frame = CGRect(origin: .zero, size: frame.size)
        
        pageControl?.frame = CGRect(x: 0, y: self.frame.maxY - 30, width: self.frame.width, height: 30)
    }
    
    /// Setup FSPagerView used in view
    ///
    /// - Parameter frame: The frame rectangle for the view, measured in points. The origin of the frame is relative to the superview in which you plan to add it. This method uses the frame rectangle to set the center and bounds properties accordingly.
    private func setupPager(frame: CGRect) {
        pagerView = FSPagerView(frame: CGRect(origin: .zero, size: frame.size))
        pagerView?.dataSource = self
        pagerView?.delegate = self
        pagerView?.register(FSPagerViewCell.self, forCellWithReuseIdentifier: "cell")
        
        pageControl = FSPageControl(frame: CGRect(x: 0, y: self.frame.maxY - 30, width: self.frame.width, height: 30))
        pageControl?.numberOfPages = images.count
        pageControl?.contentHorizontalAlignment = .center
        
        
        self.addSubview(pagerView!)
        self.addSubview(pageControl!)
    }
    
    /// Add data image in view pager. Type data use is URL
    ///
    /// - Parameter url: Url of image for view pager
    func setImage(url: [URL]) {
        self.images.removeAll()
        self.images = url
        
        pageControl?.numberOfPages = images.count
        
        pagerView?.reloadData()
    }
    
    /// Add data image in view pager. Type data use is String
    ///
    /// - Parameter urlString: string url of image for view pager
    func setImage(urlString: [String]) {
        self.images.removeAll()
        let url = urlString.compactMap({ URL(string: $0) })
        self.images = url
        
        pageControl?.numberOfPages = images.count
        
        pagerView?.reloadData()
    }
    
    /// Add data image in view pager. Type data use is UIImage
    ///
    /// - Parameter url: Image for view pager
    func setImage(_ images: [UIImage]) {
        self.images.removeAll()
        self.images = images
        
        pageControl?.numberOfPages = images.count
        
        pagerView?.reloadData()
    }
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}

extension ImagePagerView: FSPagerViewDataSource {
    func numberOfItems(in pagerView: FSPagerView) -> Int {
        return images.count
    }
    
    func pagerView(_ pagerView: FSPagerView, cellForItemAt index: Int) -> FSPagerViewCell {
        let cell = pagerView.dequeueReusableCell(withReuseIdentifier: "cell", at: index)
        cell.imageView?.contentMode = self.contentMode
        cell.imageView?.clipsToBounds = true
        if let imagesUrl = images as? [URL] {
            let imageUrl = imagesUrl[index]
            cell.imageView?.kf.indicatorType = .activity
            cell.imageView?.kf.setImage(with: imageUrl, placeholder: #imageLiteral(resourceName: "blank_image"))
        }
        if let images = images as? [UIImage] {
            let image = images[index]
            cell.imageView?.image = image
        }
        return cell
    }
}

extension ImagePagerView: FSPagerViewDelegate {
    func pagerView(_ pagerView: FSPagerView, didSelectItemAt index: Int) {
        pagerView.deselectItem(at: index, animated: true)
        pagerView.scrollToItem(at: index, animated: true)
        
        didSelectItemAction?(index)
            
        pageControl?.currentPage = index
    }
    
    func pagerViewDidScroll(_ pagerView: FSPagerView) {
        guard pageControl?.currentPage != pagerView.currentIndex else {
            return
        }
        pageControl?.currentPage = pagerView.currentIndex
    }
}
