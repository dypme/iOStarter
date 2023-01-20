//
//  OtherComponentUI.swift
//  iOStarter
//
//  Created by MBP2022_1 on 13/01/23.
//  Copyright © 2023 dypme. All rights reserved.
//

import SwiftUI

struct OtherComponentUI: View {
    @State private var isCameraPresented = false
    @State private var isAlertPresented = false
    @State private var isSheetPresented = false
    @State private var image: UIImage? = nil
    
    var body: some View {
        List {
            NavigationLink(destination: MapUI()) {
                Label("Map", systemImage: "map")
            }

            Button(action: {
                isCameraPresented = true
            }, label: {
                Label("Camera", systemImage: "camera")
            })
            .fullScreenCover(isPresented: $isCameraPresented) {
                CameraView(position: .back, isSquare: true) { image in
                    self.image = image
                    self.isCameraPresented = false
                }
            }
        }
        .navigationTitle(Text("Others"))
    }
}

struct OtherComponentUI_Previews: PreviewProvider {
    static var previews: some View {
        OtherComponentUI()
    }
}
