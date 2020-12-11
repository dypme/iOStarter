//
//  ExampleListVM.swift
//  iOStarter
//
//  Created by Crocodic Studio on 07/12/19.
//  Copyright © 2019 WahyuAdyP. All rights reserved.
//

import Foundation

class ExampleListVM {
    private var datas = [ExampleModel]()
    
    private var limit = 10
    private var offset = 0
    private var isLoading = false
    private(set) var canLoadMore = false
    
    var backgroundView: UIView? {
        if datas.isEmpty {
            if isLoading {
                let loadingView = LoadIndicatorView()
                loadingView.view.isUserInteractionEnabled = false
                loadingView.view.backgroundColor = UIColor.clear
                return loadingView.view
            } else {
                let errorView = ErrorView()
                return errorView.view
            }
        }
        return nil
    }
    
    var footerView: UIView? {
        if canLoadMore && !datas.isEmpty {
            let view = UIView(frame: CGRect(x: 0, y: 0, width: 200, height: 50))
            view.backgroundColor = .clear
            
            // Indicator view here, you can edit your loading indicator style for loading in bottom for infinite scroll
            let indicator = UIActivityIndicatorView()
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
    
    func viewModelOfItem(at indexPath: IndexPath) -> ExampleItemVM {
        let data = datas[indexPath.row]
        return ExampleItemVM(data: data)
    }
    
    func fetch(isLoadMore: Bool, onFinish: ((Bool, String) -> Void)?) {
        for i in 0 ... 10 {
            let exampleData = ExampleModel(id: i, name: "Example data-\(i)", detail: "Detail data example-\(i)", image: "https://images.pexels.com/photos/414612/pexels-photo-414612.jpeg?auto=compress&cs=tinysrgb&dpr=1&w=500")
            datas.append(exampleData)
        }
        
        onFinish?(true, "Success")
    }
}
