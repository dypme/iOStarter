//
//  ViewModelList.swift
//  iOStarter
//
//  Created by Crocodic-MBP5 on 08/03/21.
//  Copyright © 2021 WahyuAdyP. All rights reserved.
//

import Foundation
import UIKit

typealias ViewModelRequestCallback = ((_ isSuccess: Bool, _ message: String) -> Void)?
typealias ViewUpdateCallback = ((_ backgroundView: UIView?, _ footerView: UIView?) -> Void)?

class ViewModelList<T: ModelData, V: ViewModelItem<T>> {
    var datas = [T]()
    
    var limit = 10
    var offset = 0
    var isLoading = false
    var isAllowLoadMore = false
    
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
        if isAllowLoadMore && !datas.isEmpty {
            let view = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 50))
            view.backgroundColor = .clear
            
            // TODO: Indicator view here, you can edit your loading indicator style for loading in bottom for infinite scroll
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
    
    func fetch(isLoadMore: Bool, path: ApiHelper.Path, viewDidUpdate: ViewUpdateCallback, fetchDidFinish: ViewModelRequestCallback) {
        if isLoading {
            return
        }
        if isLoadMore {
            offset = 0
        }
        isLoading = true
        viewDidUpdate?(backgroundView, footerView)
        _ = ApiHelper.shared.request(to: path, callback: { json, isSuccess, message in
            if isSuccess {
                // TODO: Update general parsing array used in Your app
                let newDatas = json["data"].arrayValue.map({ T(fromJson: $0) })
                if isLoadMore {
                    self.datas.append(contentsOf: newDatas)
                } else {
                    self.datas = newDatas
                }
                self.offset += 1
                self.isAllowLoadMore = newDatas.count >= self.limit
            }
            
            self.isLoading = false
            viewDidUpdate?(self.backgroundView, self.footerView)
            fetchDidFinish?(isSuccess, message)
        })
    }
}
