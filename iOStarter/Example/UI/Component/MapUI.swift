//
//  MapUI.swift
//  iOStarter
//
//  Created by MBP2022_1 on 06/01/23.
//  Copyright © 2023 dypme. All rights reserved.
//

import SwiftUI
import MapKit

struct MapUI: View {
    @State private var locationManager = LocationHelper().start()
    
    var body: some View {
        Map(coordinateRegion: $locationManager.region)
            .navigationTitle("Maps")
    }
}

struct MapUI_Previews: PreviewProvider {
    static var previews: some View {
        MapUI()
    }
}
