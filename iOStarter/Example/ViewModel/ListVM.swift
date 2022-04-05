//
//  ListVM.swift
//  iOStarter
//
//  Created by Macintosh on 05/04/22.
//  Copyright © 2022 WahyuAdyP. All rights reserved.
//

import Foundation
import UIKit

class ListVM: ViewModelList<Item, ItemVM> {
    func fetch(isLoadMore: Bool, viewDidUpdate: ViewUpdateCallback, fetchDidFinish: ViewModelRequestCallback) {
        if isLoading {
            return
        }
        if isLoadMore {
            offset = 0
        }
        isLoading = true
        viewDidUpdate?(backgroundView, footerView)
        ApiHelper.shared.localRequest(fileName: "items.json", callback: { json, isSuccess, message in
            if isSuccess {
                let newDatas = json.arrayValue.map({ Item(fromJson: $0) })
                if isLoadMore {
                    self.datas.append(contentsOf: newDatas)
                } else {
                    self.datas = newDatas
                }
            }
            
            self.isLoading = false
            fetchDidFinish?(isSuccess, message)
            viewDidUpdate?(self.backgroundView, self.footerView)
        })
    }
}
