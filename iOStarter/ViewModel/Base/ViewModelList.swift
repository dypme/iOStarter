//
//  ViewModelList.swift
//  iOStarter
//
//  Created by Crocodic-MBP5 on 08/03/21.
//  Copyright © 2021 WahyuAdyP. All rights reserved.
//

import Foundation
import UIKit

class ViewModelList<T: NSObject, V: ViewModelItem<T>> {
    var datas = [T]()
    
    var limit = 10
    var offset = 0
    var isLoading = false
    var canLoadMore = false
    
    var backgroundView: UIView? {
        if datas.isEmpty {
            if isLoading {
                let loadingView = LoadIndicatorView()
                loadingView.startAnimating()
                return loadingView
            } else {
                return ErrorView(message: "Data not found")
            }
        }
        return nil
    }
    
    var footerView: UIView? {
        if canLoadMore && !datas.isEmpty {
            let view = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 50))
            view.backgroundColor = .clear
            
            // Indicator view here, you can edit your loading indicator style for loading in bottom for infinite scroll
            let indicator = UIActivityIndicatorView()
            indicator.translatesAutoresizingMaskIntoConstraints = false
            indicator.startAnimating()
            view.addSubview(indicator)
            
            indicator.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
            indicator.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
            
            return view
        }
        return nil
    }
    
    var numberOfItems: Int {
        return datas.count
    }
    
    func viewModelOfItem(at indexPath: IndexPath) -> V {
        let data = datas[indexPath.row]
        return V(data: data)
    }
    
    func fetch(isLoadMore: Bool, onFinish: ((Bool, String) -> Void)?) {
        
    }
}
