//
//  ExampleListVM.swift
//  iOStarter
//
//  Created by Crocodic Studio on 07/12/19.
//  Copyright © 2019 WahyuAdyP. All rights reserved.
//

import Foundation
import UIKit

class ExampleListVM: ViewModelList<ExampleModel, ExampleItemVM> {
    override func fetch(isLoadMore: Bool, onFinish: ((Bool, String) -> Void)?) {
        for i in 0 ... 10 {
            let exampleData = ExampleModel(id: i, name: "Example data-\(i)", detail: "Detail data example-\(i)", image: "https://images.pexels.com/photos/414612/pexels-photo-414612.jpeg?auto=compress&cs=tinysrgb&dpr=1&w=500")
            datas.append(exampleData)
        }
        
        onFinish?(true, "Success")
    }
}
