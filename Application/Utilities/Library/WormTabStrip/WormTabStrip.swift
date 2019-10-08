//
//  Test.swift
//  EYViewPager
//
//  Created by Ezimet Yusuf on 7/4/16.
//  Copyright © 2016 Ezimet Yusup. All rights reserved.
//

import Foundation
import UIKit

/// The delegate to setting infromation of Tab Strip
@objc public protocol WormTabStripDelegate: class {
    /// Return the Number SubViews in the ViewPager
    func wtsNumberOfTabs() -> Int
    /// Return the View for sepecific position
    func wtsViewOfTab(index: Int) -> UIView
    /// Return the title for each view
    func wtsTitleForTab(index: Int) -> String
    /// The delegate that ViewPager has got End with Left Direction
    @objc optional func wtsReachedLeftEdge(panParam: UIPanGestureRecognizer)
    /// The delegate that ViewPager has got End with Right Direction
    @objc optional func wtsReachedRightEdge(panParam: UIPanGestureRecognizer)
    /// The delegate that ViewPager end scrolling position
    @objc optional func wtsEndScrolling(index: Int)
}

/// Option worm style
///
/// - bubble: The option that make tab item strip contains oval view
/// - line: THe option that make tab item strip contains line view
public enum WormStyle {
    case bubble
    case line
}

/// Property style of tab strip
public struct WormTabStripStyleProperties {
    
    /// Tab strip worm style
    var wormStyle: WormStyle = .bubble
    
    // Heights
    
    /// Height of selected line indicator in tab
    var kHeightOfWorm: CGFloat = 3
    
    /// Height of selected bubble indicator in tab
    var kHeightOfWormForBubble: CGFloat = 45
    
    /// Height of divider between tab and content
    var kHeightOfDivider: CGFloat = 2
    
    /// Height of tab container
    var kHeightOfTopScrollView: CGFloat = 50
    
    /// Height of minimum size of worm comparing with container
    var kMinimumWormHeightRatio: CGFloat = 4/5
    
    // paddings
    
    /// Padding of tabs text to each side
    var kPaddingOfIndicator: CGFloat = 30
    
    /// initial value for the tabs margin
    var kWidthOfButtonMargin: CGFloat = 0
    
    /// Pass true to hide your tab
    var isHideTopScrollView = false
    
    /// Make space between tab
    var spacingBetweenTabs: CGFloat = 15
    
    /// Pass true to show selected indicator
    var isWormEnable = true
    
    // fonts
    
    /// Tab item font
    var tabItemDefaultFont: UIFont = UIFont(name: "arial", size: 14)!
    /// Selected tab item font
    var tabItemSelectedFont: UIFont = UIFont(name: "arial", size: 16)!
    
    // colors
    
    /// Tab item font color
    var tabItemDefaultColor: UIColor = .white
    
    /// Selected tab item font color
    var tabItemSelectedColor: UIColor = .red
    
    /// color for worm selected tab indicator
    var wormColor: UIColor = UIColor(netHex: 0x1EAAF1)
    
    /// Background color of tab
    var topScrollViewBackgroundColor: UIColor = UIColor(netHex: 0x364756)
    
    /// Background color of content
    var contentScrollViewBackgroundColor: UIColor = UIColor.gray
    
    /// Divider color between tab and content
    var dividerBackgroundColor: UIColor = UIColor.red
    
    /// Pass true if you want tab fit in screen width
    var isDistributeEqually = true
}

/// Worm Tab Strip View
public class WormTabStrip: UIView, UIScrollViewDelegate {
    
    /// Top view for make store tab bat
    private let topScrollView: UIScrollView = UIScrollView()
    
    /// Container to store content
    private let contentScrollView: UIScrollView = UIScrollView()
    
    /// Make selected tab in center of top view
    public var shouldCenterSelectedWorm = true
    
    /// Width of view
    public var width: CGFloat!
    
    /// Height of view
    public var height: CGFloat!
    
    /// Tab item titles in top view
    private var titles: [String]! = []
    
    /// Content views for tab strip content
    private var contentViews: [UIView]! = []
    
    /// Tab button strip
    private var tabs: [WormTabStripButton]! = []
    
    /// View for make gap between top view and content view
    private let divider: UIView = UIView()
    
    /// View for selected line
    private let worm: UIView = UIView()
    
    /// Customize style of tab strip
    public var eyStyle: WormTabStripStyleProperties = WormTabStripStyleProperties()
    
    /// Delegate tab strip
    weak var delegate: WormTabStripDelegate?
    
    /// Justify flag
    private var isJustified = false
    
    /// Tapping flag
    private var isUserTappingTab = false
    
    /// Width total of top view
    private var dynamicWidthOfTopScrollView: CGFloat = 0
    
    /// Margin in every tab item
    private let plusOneforMarginOfLastTabToScreenEdge = 1
    
    //MARK: init
    override init(frame: CGRect) {
        super.init(frame: frame)
        width = self.frame.width
        height = self.frame.height
    }
    
    convenience required public init(key: String) {
        self.init(frame:CGRect.zero)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        autoresizingMask = [.flexibleWidth, .flexibleHeight]
        width = self.frame.width
        height = self.frame.height
        
    }
    
    public override func layoutIfNeeded() {
        super.layoutIfNeeded()
        
        width = self.frame.width
        height = self.frame.height
    }
    
    /// Starting build WTSTabStrip
    func buildUI() {
        layoutIfNeeded()
        
        validate()
        addTopScrollView()
        addWorm()
        addDivider()
        addContentScrollView()
        buildContent()
        checkAndJustify()
        selectTab(at: currentTabIndex)
        setTabStyle()
    }
    
    func rebuildTopUI() {
        topScrollView.subviews.filter({ $0 is WormTabStripButton }).forEach { (aView) in
            aView.removeFromSuperview()
        }
        
        layoutIfNeeded()
        buildTopScrollViewsContent()
        checkAndJustify()
        selectTab(at: currentTabIndex)
        setTabStyle()
    }
    
    /// Checking tab strip data is there
    private func validate(){
        if delegate == nil {
            assert(false, "WormTabStripDelegate is null, please set the WormTabStripDelegate")
        }
    }
    
    /// Add top scroll view to the view stack which will contain the all the tabs
    private func addTopScrollView() {
        topScrollView.frame = CGRect(x: 0, y: 0, width: width, height: eyStyle.kHeightOfTopScrollView)
        topScrollView.backgroundColor = eyStyle.topScrollViewBackgroundColor
        topScrollView.showsHorizontalScrollIndicator = false
        self.addSubview(topScrollView)
    }
    
    /// Add divider between the top scroll view and content scroll view
    private func addDivider() {
        divider.frame = CGRect(x: 0, y: eyStyle.kHeightOfTopScrollView, width: width, height: eyStyle.kHeightOfDivider)
        divider.backgroundColor = eyStyle.dividerBackgroundColor
        self.addSubview(divider)
    }
    
    /// Add content scroll view to the view stack which will hold mian  views such like table view ...
    private func addContentScrollView() {
        if eyStyle.isHideTopScrollView {
            contentScrollView.frame = CGRect(x: 0, y: 0, width: width, height: height)
        } else {
            contentScrollView.frame = CGRect(x: 0, y: eyStyle.kHeightOfTopScrollView + eyStyle.kHeightOfDivider, width: width, height: height - eyStyle.kHeightOfTopScrollView - eyStyle.kHeightOfDivider)
        }
        contentScrollView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        contentScrollView.backgroundColor = eyStyle.contentScrollViewBackgroundColor
        contentScrollView.isPagingEnabled = true
        contentScrollView.delegate = self
        contentScrollView.showsHorizontalScrollIndicator = false
        contentScrollView.showsVerticalScrollIndicator = false
        contentScrollView.bounces = false
        contentScrollView.panGestureRecognizer.addTarget(self, action: #selector(scrollHandleUIPanGestureRecognizer))
        self.addSubview(contentScrollView)
    }
    
    /// Add line selected indicator
    private func addWorm() {
        worm.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        topScrollView.addSubview(worm)
        
        resetHeightOfWorm()
        worm.frame.size.width = 100
        worm.backgroundColor = eyStyle.wormColor
        
    }
    
    /// Add top content and main content
    private func buildContent() {
        buildTopScrollViewsContent()
        buildContentScrollViewsContent()
    }
    
    /// Build top view tab strip
    private func buildTopScrollViewsContent() {
        dynamicWidthOfTopScrollView = 0
        var XOffset:CGFloat = eyStyle.spacingBetweenTabs
        
        var minContentWidth: CGFloat = eyStyle.spacingBetweenTabs
        for i in 0 ..< delegate!.wtsNumberOfTabs() {
            let string = delegate!.wtsTitleForTab(index: i)
            let constraintRect = CGSize(width: CGFloat.greatestFiniteMagnitude, height: eyStyle.kHeightOfTopScrollView)
            let boundingBox = string.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: eyStyle.tabItemDefaultFont], context: nil)
            
            minContentWidth += (6 + boundingBox.width) + eyStyle.spacingBetweenTabs + (eyStyle.kPaddingOfIndicator * 2)
        }
        
        if eyStyle.isDistributeEqually && minContentWidth >= width {
            eyStyle.isDistributeEqually = false
        }
        
        tabs.removeAll()
        for i in 0 ..< delegate!.wtsNumberOfTabs() {
            let tab: WormTabStripButton = WormTabStripButton()
            tab.index = i
            formatButton(tab: tab, xOffset: XOffset)
            XOffset += eyStyle.spacingBetweenTabs + tab.frame.width
            dynamicWidthOfTopScrollView += eyStyle.spacingBetweenTabs + tab.frame.width
            topScrollView.addSubview(tab)
            tabs.append(tab)
            topScrollView.contentSize.width = dynamicWidthOfTopScrollView
        }
    }
    
    /**************************
     format tab style, tap event
     ***************************************/
    /// Formatting top button view tab strip
    ///
    /// - Parameters:
    ///   - tab: Button in top view
    ///   - xOffset: Spacing between tab
    private func formatButton(tab: WormTabStripButton, xOffset: CGFloat) {
        tab.frame.size.height = eyStyle.kHeightOfTopScrollView
        tab.paddingToEachSide = eyStyle.kPaddingOfIndicator
        tab.tabText = delegate!.wtsTitleForTab(index: tab.index!) as NSString?
        if eyStyle.isDistributeEqually {
            tab.frame.size.width = (self.bounds.width - (eyStyle.spacingBetweenTabs * CGFloat(delegate!.wtsNumberOfTabs() + 1))) / CGFloat(delegate!.wtsNumberOfTabs())
        }
        tab.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        tab.textColor = eyStyle.tabItemDefaultColor
        tab.frame.origin.x = xOffset
        tab.frame.origin.y = 0
        tab.textAlignment = .center
        tab.isUserInteractionEnabled = true
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.tabPress(sender:)))
        tap.numberOfTapsRequired = 1
        tap.numberOfTouchesRequired = 1
        tab.addGestureRecognizer(tap)
    }
    
    /// Add all content views to content scroll view and tabs to top scroll view
    private func buildContentScrollViewsContent() {
        let count = delegate!.wtsNumberOfTabs()
        contentScrollView.contentSize.width = CGFloat(count) * self.frame.width
        for i in 0 ..< count{
            // Position each content view
            let view = delegate!.wtsViewOfTab(index: i)
            view.frame.origin.x = CGFloat(i) * width
            view.frame.origin.y = 0
            view.frame.size.height = contentScrollView.frame.size.height
            contentScrollView.addSubview(view)
        }
    }
    
    /** If the content width of the topScrollView smaller than screen width
     do justification to the tabs  by increasing spcases between the tabs
     and rebuild all top and content views
     */
    private func checkAndJustify() {
        if dynamicWidthOfTopScrollView < width && !isJustified {
            isJustified = true
            // Calculate the available space
            let gap:CGFloat = width - dynamicWidthOfTopScrollView
            // Increase the space by dividing available space to # of tab plus one
            // Plus one bc we always want to have margin from last tab to to right edge of screen
            eyStyle.spacingBetweenTabs += gap / CGFloat(delegate!.wtsNumberOfTabs() + plusOneforMarginOfLastTabToScreenEdge)
            dynamicWidthOfTopScrollView = 0
            var XOffset:CGFloat = eyStyle.spacingBetweenTabs
            for tab in tabs {
                tab.frame.origin.x = XOffset
                XOffset += eyStyle.spacingBetweenTabs + tab.frame.width
                dynamicWidthOfTopScrollView += eyStyle.spacingBetweenTabs + tab.frame.width
                topScrollView.contentSize.width = dynamicWidthOfTopScrollView
            }
        }
    }
    
    /*******
     tabs selector
     ********/
    /// Tab button top view tab strip
    ///
    /// - Parameter sender: Button tab strip
    @objc func tabPress(sender: AnyObject) {
        isUserTappingTab = true
        
        let tap: UIGestureRecognizer = sender as! UIGestureRecognizer
        let tab: WormTabStripButton = tap.view as! WormTabStripButton
        selectTab(tab: tab)
    }
    
    /// Select a specific tab
    ///
    /// - Parameter index: Index position of tab will be selected
    func selectTab(at index: Int) {
        if index >= tabs.count { return }
        let tab = tabs[index]
        selectTab(tab: tab)
    }
    
    /// Select tab with position of button item
    ///
    /// - Parameter tab: WormTabStripButton in top view
    private func selectTab(tab: WormTabStripButton) {
        prevTabIndex = currentTabIndex
        currentTabIndex = tab.index!
        setTabStyle()
        
        delegate?.wtsEndScrolling?(index: currentTabIndex)
        
        natruallySlideWormToPosition(tab: tab)
        natruallySlideContentScrollViewToPosition(index: tab.index!)
        adjustTopScrollViewsContentOffsetX(tab: tab)
        centerCurrentlySelectedWorm(tab: tab)
    }
    
    /**
     Move worm to the correct position with slinding animation when the tabs are clicked
     */
    private func natruallySlideWormToPosition(tab: WormTabStripButton) {
        UIView.animate(withDuration: 0.3) {
            self.slideWormToTabPosition(tab: tab)
        }
    }
    
    /// POsitioning line worm in actual position of top view
    ///
    /// - Parameter tab: WormTabStripButton
    private func slideWormToTabPosition(tab: WormTabStripButton) {
        self.worm.frame.origin.x = tab.frame.origin.x
        self.worm.frame.size.width = tab.frame.width
        
    }
    /**
     If the tab was at position of only half of it was showing up,
     we need to adjust it by setting content OffSet X of Top ScrollView
     when the tab was clicked
     */
    private func adjustTopScrollViewsContentOffsetX(tab: WormTabStripButton) {
        let widhtOfTab:CGFloat = tab.bounds.size.width
        let XofTab:CGFloat = tab.frame.origin.x
        let spacingBetweenTabs = eyStyle.spacingBetweenTabs
        //if tab at right edge of screen
        if XofTab - topScrollView.contentOffset.x > width - (spacingBetweenTabs + widhtOfTab) {
            topScrollView.setContentOffset(CGPoint(x:XofTab - (width - (spacingBetweenTabs + widhtOfTab)), y: 0), animated: true)
        }
        //if tab at left edge of screen
        if XofTab - topScrollView.contentOffset.x < spacingBetweenTabs {
            topScrollView.setContentOffset(CGPoint(x: XofTab - spacingBetweenTabs, y: 0), animated: true)
        }
    }
    
    /// Positioning selected worm in center of top view
    ///
    /// - Parameter tab: WormTabStripButton
    func centerCurrentlySelectedWorm(tab: WormTabStripButton) {
        // Check the settings
        if shouldCenterSelectedWorm == false {return}
        // If worm tab was right/left side of screen and if there are enough space to scroll to center
        let XofTab:CGFloat = tab.frame.origin.x
        let toLeftOfScreen = (width - tab.frame.width) / 2
        // Return if there is no enough space at right
        if XofTab + tab.frame.width + toLeftOfScreen > topScrollView.contentSize.width {
            return
        }
        // Return if there is no enough space at left
        if XofTab - toLeftOfScreen < 0 {
            return
        }
        // Center it
        if topScrollView.contentSize.width - XofTab + tab.frame.width > toLeftOfScreen {
            // XofTab = x + (screenWidth-tab.frame.width)/2
            let offsetX = XofTab - toLeftOfScreen
            topScrollView.setContentOffset(CGPoint.init(x: offsetX, y: 0), animated: true)
        }
        
    }
    
    /**
     Move content scroll view to the correct position with animation when the tabs are clicked
     */
    private func natruallySlideContentScrollViewToPosition(index: Int) {
        let point = CGPoint(x: CGFloat(index) * width, y: 0)
        UIView.animate(withDuration: 0.3, animations: {
            self.contentScrollView.setContentOffset(point, animated: false)
        }) { (finish) in
            self.isUserTappingTab = false
        }
        
    }
    
    /*************************************************
     //MARK: UIScrollView Delegate start
     ******************************************/
    /// Previous index tab
    var prevTabIndex = 0
    /// Current index position tab
    var currentTabIndex = 0
    /// Current worm horizontal position
    var currentWormX: CGFloat = 0
    /// Current worm width
    var currentWormWidth: CGFloat = 0
    /// Content horizontal position
    var contentScrollContentOffsetX: CGFloat = 0
    
    public func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        currentTabIndex = Int(scrollView.contentOffset.x / width)
        
        setTabStyle()
        prevTabIndex = currentTabIndex
        let tab = tabs[currentTabIndex]
        //need to call setTabStyle twice because, when user swipe their finger really fast, scrollViewWillBeginDragging method will be called agian without scrollViewDidEndDecelerating get call
        setTabStyle()
        currentWormX = tab.frame.origin.x
        currentWormWidth = tab.frame.width
        contentScrollContentOffsetX = scrollView.contentOffset.x
    }
    
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        //if user was tapping tab no need to do worm animation
        if isUserTappingTab == true { return }
        
        if eyStyle.isWormEnable == false { return }
        
        let currentX = scrollView.contentOffset.x
        var gap:CGFloat = 0
        
        
        //if user dragging to right, which means scrolling finger from right to left
        //which means scroll view is scrolling to right, worm also should worm to right
        if currentX > contentScrollContentOffsetX {
            gap = currentX - contentScrollContentOffsetX
            
            if gap > width {
                contentScrollContentOffsetX = currentX
                currentTabIndex = Int(currentX / width)
                let tab = tabs[currentTabIndex]
                natruallySlideWormToPosition(tab: tab)
                return
            }
            
            //if currentTab is not last one do worm to next tab position
            if currentTabIndex + 1 <= tabs.count {
                let nextDistance:CGFloat = calculateNextMoveDistance(gap: gap, nextTotal: getNextTotalWormingDistance(index: currentTabIndex+1))
                // println(nextDistance)
                setWidthAndHeightOfWormForDistance(distance: nextDistance)
                
                //                wormToNextLeft(distance: -nextDistance)
            }
            
            
        } else {
            //else  user dragging to left, which means scrolling finger from  left to right
            //which means scroll view is scrolling to left, worm also should worm to left
            gap = contentScrollContentOffsetX - currentX
            //if current is not first tab at left do worm to left
            if currentTabIndex >= 1 {
                let nextDistance:CGFloat = calculateNextMoveDistance(gap: gap, nextTotal: getNextTotalWormingDistance(index: currentTabIndex-1))
                //                print(nextDistance)
                wormToNextLeft(distance: nextDistance)
            }
            
            
        }
        
    }
    
    public func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let currentX = scrollView.contentOffset.x
        currentTabIndex = Int(currentX / width)
        let tab = tabs[currentTabIndex]
        setTabStyle()
        
        delegate?.wtsEndScrolling?(index: currentTabIndex)
        
        adjustTopScrollViewsContentOffsetX(tab: tab)
        UIView.animate(withDuration: 0.23) {
            self.slideWormToTabPosition(tab: tab)
            self.resetHeightOfWorm()
            self.centerCurrentlySelectedWorm(tab: tab)
        }
        
    }
    
    /*************************************************
     //MARK:  UIScrollView Delegate end
     ******************************************/
    
    
    /*************************************************
     //MARK:  UIScrollView Delegate Calculations  start
     ******************************************/
    private  func getNextTotalWormingDistance(index: Int) -> CGFloat {
        let tab = tabs[index]
        let nextTotal: CGFloat = eyStyle.spacingBetweenTabs + tab.frame.width
        return nextTotal
    }
    
    private func calculateNextMoveDistance(gap: CGFloat, nextTotal: CGFloat) -> CGFloat{
        let nextMove: CGFloat = (gap * nextTotal) / width
        return nextMove
        
    }
    
    private func setWidthAndHeightOfWormForDistance(distance: CGFloat) {
        if distance < 1 {
            resetHeightOfWorm()
        } else {
            let height: CGFloat = self.calculatePrespectiveHeightOfIndicatorLine(distance: distance)
            worm.frame.size.height = height
            
            worm.frame.size.width = currentWormWidth + distance
        }
        if eyStyle.wormStyle == .line {
            worm.frame.origin.y = eyStyle.kHeightOfTopScrollView - eyStyle.kHeightOfWorm
        } else {
            worm.frame.origin.y = (eyStyle.kHeightOfTopScrollView - worm.frame.size.height)/2
        }
        
        worm.layer.cornerRadius = worm.frame.size.height / 2
    }
    
    private func wormToNextLeft(distance: CGFloat) {
        setWidthAndHeightOfWormForDistance(distance: distance)
        worm.frame.origin.x = currentWormX - distance
    }
    
    private func resetHeightOfWorm() {
        // if the style is line it should be placed under the tab
        if eyStyle.wormStyle == .line {
            worm.frame.origin.y = eyStyle.kHeightOfTopScrollView - eyStyle.kHeightOfWorm
            worm.frame.size.height = eyStyle.kHeightOfWorm
            
        } else {
            worm.frame.origin.y = (eyStyle.kHeightOfTopScrollView - eyStyle.kHeightOfWormForBubble) / 2
            worm.frame.size.height = eyStyle.kHeightOfWormForBubble
        }
        worm.layer.cornerRadius = worm.frame.size.height / 2
    }
    
    private func calculatePrespectiveHeightOfIndicatorLine(distance: CGFloat) -> CGFloat {
        var height:CGFloat = 0
        var originalHeight:CGFloat = 0
        if eyStyle.wormStyle == .line {
            height =  eyStyle.kHeightOfWorm * (self.currentWormWidth / (distance+currentWormWidth))
            originalHeight = eyStyle.kHeightOfWorm
        } else {
            height =  eyStyle.kHeightOfWormForBubble * (self.currentWormWidth / (distance+currentWormWidth))
            originalHeight = eyStyle.kHeightOfWormForBubble
        }
        
        //if the height of worm becoming too small just make it half of it
        if height < (originalHeight*eyStyle.kMinimumWormHeightRatio) {
            height = originalHeight*eyStyle.kMinimumWormHeightRatio
        }
        
        //        return worm.frame.height
        return height
    }
    
    private func setTabStyle() {
        makePrevTabDefaultStyle()
        makeCurrentTabSelectedStyle()
    }
    
    private func makePrevTabDefaultStyle() {
        //        let tab = tabs[prevTabIndex]
        //        tab.textColor = eyStyle.tabItemDefaultColor
        //        tab.font = eyStyle.tabItemDefaultFont
        for i in 0 ..< tabs.count {
            tabs[i].textColor = eyStyle.tabItemDefaultColor
            tabs[i].font = eyStyle.tabItemDefaultFont
        }
    }
    
    private func makeCurrentTabSelectedStyle() {
        let tab = tabs[currentTabIndex]
        tab.textColor = eyStyle.tabItemSelectedColor
        tab.font = eyStyle.tabItemSelectedFont
    }
    /*************************************************
     //MARK:  Worm Calculations Ends
     ******************************************/
    
    @objc func scrollHandleUIPanGestureRecognizer(panParam: UIPanGestureRecognizer) {
        if contentScrollView.contentOffset.x <= 0 {
            self.delegate?.wtsReachedLeftEdge?(panParam: panParam)
        } else if contentScrollView.contentOffset.x >= contentScrollView.contentSize.width - contentScrollView.bounds.size.width {
            self.delegate?.wtsReachedRightEdge?(panParam: panParam)
        }
    }
}


extension UIColor {
    convenience init(red: Int, green: Int, blue: Int) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")
        
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }
    
    convenience init(netHex: Int) {
        self.init(red:(netHex >> 16) & 0xff, green:(netHex >> 8) & 0xff, blue:netHex & 0xff)
    }
}
