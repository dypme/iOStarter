//
//  BlueButton.swift
//  iOStarter
//
//  Created by Macintosh on 05/07/22.
//  Copyright © 2022 dypme. All rights reserved.
//

import Foundation
import SwiftUI

struct BlueButton: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding()
            .frame(maxWidth: .infinity)
            .foregroundColor(.white)
            .background(Color.blue)
            .clipShape(Capsule())
    }
}
