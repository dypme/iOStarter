//
//  ComponentUI.swift
//  iOStarter
//
//  Created by MBP2022_1 on 04/01/23.
//  Copyright © 2023 dypme. All rights reserved.
//

import SwiftUI

struct ComponentUI: View {
    var body: some View {
        List {
            NavigationLink(destination: ButtonComponentUI()) {
                Label("Buttons", systemImage: "capsule")
            }
            NavigationLink(destination: ControlComponentUI()) {
                Label("Controls", systemImage: "slider.horizontal.3")
            }
            NavigationLink(destination: TextComponentUI()) {
                Label("Text", systemImage: "text.aligncenter")
            }
            NavigationLink(destination: IndicatorComponentUI()) {
                Label("Indicators", systemImage: "speedometer")
            }
            NavigationLink(destination: ImageComponentUI()) {
                Label("Images", systemImage: "photo")
            }
            NavigationLink(destination: ShapeComponentUI()) {
                Label("Shapes", systemImage: "square.on.circle")
            }
            NavigationLink(destination: OtherComponentUI()) {
                Label("Others", systemImage: "ellipsis")
            }
        }
    }
}

struct ComponentUI_Previews: PreviewProvider {
    static var previews: some View {
        ComponentUI()
    }
}
