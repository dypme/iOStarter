//
//  IndicatorComponentUI.swift
//  iOStarter
//
//  Created by MBP2022_1 on 20/01/23.
//  Copyright © 2023 dypme. All rights reserved.
//

import SwiftUI

struct IndicatorComponentUI: View {
    @State private var progress = 0.0
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    var body: some View {
        List {
            Section {
                ProgressView()
                VStack {
                    Text("Loading...")
                    ProgressView(value: progress)
                        .onReceive(timer) { _ in
                            if progress + 0.1 > 1 {
                                progress = 0
                            } else {
                                progress += 0.1
                            }
                        }
                }
            } header: {
                Text("Progress View")
            }
        }
        .navigationTitle(Text("Indicators"))
    }
}

struct IndicatorComponentUI_Previews: PreviewProvider {
    static var previews: some View {
        IndicatorComponentUI()
    }
}
