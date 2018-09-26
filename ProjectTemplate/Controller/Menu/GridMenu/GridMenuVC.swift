//
//  MainMenuVC.swift
//  ProjectTemplate
//
//  Created by Crocodic MBP-2 on 25/07/18.
//  Copyright © 2018 Crocodic. All rights reserved.
//

import UIKit

class GridMenuVC: UIViewController {

    @IBOutlet var imageSlideshow: ImagePagerView!
    @IBOutlet var slideShowActivityId: UIActivityIndicatorView!
    @IBOutlet var errorSlideshowView: UIView!
    @IBOutlet var errorSlideshowLbl: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    
    fileprivate let cellIdentifier = "GridMenuCell"
    
    var viewModel = MenuVM()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupMethod()
        
        setupImageSlider()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /// Setup add function/ action in object (ex: add button action, add delegate, add gesture)
    func setupMethod() {
        collectionView.dataSource = self
        collectionView.delegate = self
    }
    
    /// Setup data for image slider
    func setupImageSlider() {
        imageSlideshow.contentMode = .scaleAspectFill
        imageSlideshow.isInfinite = true
        imageSlideshow.automaticSlidingInterval = 3.5
        imageSlideshow.transfomerType = .linear
        
        slideShowActivityId.startAnimating()
        viewModel.fetchImageSlider(error: { (text) in
            self.slideShowActivityId.stopAnimating()
            
            self.errorSlideshowLbl.text = text
            self.errorSlideshowView.isHidden = false
        }) { (sources) in
            self.slideShowActivityId.stopAnimating()
            
            self.errorSlideshowView.isHidden = true
            self.imageSlideshow.setImage(urlString: sources)
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

extension GridMenuVC: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.numberOfMenus
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as! GridMenuCell
        cell.viewModel = viewModel.viewModelOfMenu(at: indexPath)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "headerView", for: indexPath)
        let slider = imageSlideshow.superview!
        slider.frame = CGRect(x: 0, y: 0, width: headerView.frame.width, height: 232)
        headerView.addSubview(slider)
        return headerView
    }
}

extension GridMenuVC: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let type = viewModel.typeOfMenu(at: indexPath.row)
        switch type {
        case .logout:
            self.cAlertShow(title: nil, message: "Apakah Anda yakin ingin keluar?", isCancelable: true) {
                UserSession.shared.setLoggedOut()
                if let root = AppDelegate.shared.window?.rootViewController, root is LoginVC {
                    AppDelegate.shared.mainVC?.dismiss(animated: true, completion: nil)
                } else {
                    let vc = StoryboardScene.Auth.loginVC.instantiate()
                    self.present(vc, animated: true, completion: nil)
                }
            }
        default:
            guard let vc = viewModel.viewController(at: indexPath) else { return }
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}

extension GridMenuVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return viewModel.sizeOfCell(in: collectionView)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return viewModel.cellSpacing
    }
}
