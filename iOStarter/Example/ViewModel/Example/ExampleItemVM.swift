//
//  ExampleItemVM.swift
//  iOStarter
//
//  Created by Crocodic Studio on 07/12/19.
//  Copyright © 2019 WahyuAdyP. All rights reserved.
//

import Foundation

class ExampleItemVM {
    private var data: ExampleModel
    
    init(data: ExampleModel) {
        self.data = data
    }
    
    var photo: URL? {
        return URL(string: data.image)
    }
    
    var name: String {
        return data.name
    }
    
    var detail: String {
        return data.detail
    }
}
