//
//  MainMenuVC.swift
//  iOStarter
//
//  Created by Crocodic MBP-2 on 25/07/18.
//  Copyright © 2018 WahyuAdyP. All rights reserved.
//

import UIKit

class GridMenuVC: CollectionViewController {

    // MARK: - Property
    @IBOutlet var imageSlideshow: ImagePagerView!
    @IBOutlet var slideShowActivityId: UIActivityIndicatorView!
    @IBOutlet var errorSlideshowView: UIView!
    @IBOutlet var errorSlideshowLbl: UILabel!
    
    fileprivate let cellIdentifier = "GridMenuCell"
    
    // MARK: - Data
    var viewModel = MenuVM()
    
    // MARK: - Starting
    override func viewDidLoad() {
        super.viewDidLoad()

        setupImageSlider()
    }
    
    /// Setup data for image slider
    func setupImageSlider() {
        imageSlideshow.contentMode = .scaleAspectFill
        imageSlideshow.isInfinite = true
        imageSlideshow.automaticSlidingInterval = 3.5
        imageSlideshow.transfomerType = .linear
        
        slideShowActivityId.startAnimating()
        viewModel.fetchImageSlider(onFailed: { [weak self] (text) in
            self?.slideShowActivityId.stopAnimating()
            
            self?.errorSlideshowLbl.text = text
            self?.errorSlideshowView.isHidden = false
        }) { [weak self] (sources) in
            self?.slideShowActivityId.stopAnimating()
            
            self?.errorSlideshowView.isHidden = true
            self?.imageSlideshow.setImage(urlString: sources)
        }
    }

}

// MARK: - Collection Data Source
extension GridMenuVC {
    override var numberOfItems: Int {
        return viewModel.numberOfMenus
    }
    
    override func cellOfItem(_ collectionView: UICollectionView, at indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as! GridMenuCell
        cell.viewModel = viewModel.viewModelOfMenu(at: indexPath)
        return cell
    }
    
    override func didSelect(_ collectionView: UICollectionView, at indexPath: IndexPath) {
        let type = viewModel.typeOfMenu(at: indexPath.row)
        switch type {
        case .logout:
            self.presentAlert(title: nil, message: "Apakah Anda yakin ingin keluar?", action: { [weak self] in
                UserSession.shared.setLoggedOut()
                if let root = AppDelegate.shared.window?.rootViewController, root is LoginVC {
                    AppDelegate.shared.mainVC?.dismiss(animated: true, completion: nil)
                } else {
                    let vc = StoryboardScene.Auth.loginVC.instantiate()
                    vc.modalPresentationStyle = .fullScreen
                    self?.present(vc, animated: true, completion: nil)
                }
            })
        default:
            guard let vc = viewModel.viewController(at: indexPath) else { return }
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "headerView", for: indexPath)
        let slider = imageSlideshow.superview!
        slider.frame = CGRect(x: 0, y: 0, width: headerView.frame.width, height: 232)
        headerView.addSubview(slider)
        return headerView
    }
}

// MARK: - Collection Data Source
extension GridMenuVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return viewModel.sizeOfCell(in: collectionView)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return viewModel.cellSpacing
    }
}
