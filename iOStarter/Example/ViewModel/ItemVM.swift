//
//  ItemVM.swift
//  iOStarter
//
//  Created by Macintosh on 05/04/22.
//  Copyright © 2022 WahyuAdyP. All rights reserved.
//

import Foundation

class ItemVM: ViewModelItem<Item> {
    var name: String {
        data.name
    }
    
    var detail: String {
        data.detail
    }
    
    var imageUrl: URL? {
        URL(string: data.image)
    }
}
