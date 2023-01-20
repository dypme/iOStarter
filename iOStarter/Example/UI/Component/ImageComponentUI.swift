//
//  ImageComponentUI.swift
//  iOStarter
//
//  Created by MBP2022_1 on 20/01/23.
//  Copyright © 2023 dypme. All rights reserved.
//

import SwiftUI
import Kingfisher

struct ImageComponentUI: View {
    var body: some View {
        List {
            Section {
                Image(asset: Asset.Images.blankImage)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 200)
            } header: {
                Text("Image")
            }
            
            Section {
                KFImage(URL(string: "https://dummyimage.com/600x400/000/fff"))
                    .resizable()
                    .scaledToFit()
            } header: {
                Text("Networking")
            }
            
            Section {
                Image(systemName: "apple.logo")
                Image(systemName: "camera.macro")
                    .foregroundColor(Color.red)
                    .font(.system(size: 60))
                if #available(iOS 15.0, *) {
                    Image(systemName: "person.3.sequence.fill")
                        .symbolRenderingMode(.palette)
                        .foregroundStyle(.red, .green, .blue)
                        .font(.title)
                }
                
            } header: {
                Text("System Image")
            } footer: {
                Text("Can be search in SF Symbol")
            }
            
            Section {
                Label("Sun", systemImage: "sun.max")
                Label("Moon", systemImage: "moon.fill")
            } header: {
                Text("Label")
            }
        }
        .navigationTitle(Text("Images"))
    }
}

struct ImageComponentUI_Previews: PreviewProvider {
    static var previews: some View {
        ImageComponentUI()
    }
}
