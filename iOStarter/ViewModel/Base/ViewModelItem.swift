//
//  ViewModelItem.swift
//  iOStarter
//
//  Created by Crocodic-MBP5 on 09/03/21.
//  Copyright © 2021 WahyuAdyP. All rights reserved.
//

import Foundation

class ViewModelItem<T: NSObject> {
    var data: T
    
    required init(data: T) {
        self.data = data
    }
}
