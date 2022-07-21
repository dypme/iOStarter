//
//  RedButton.swift
//  iOStarter
//
//  Created by Macintosh on 18/07/22.
//  Copyright © 2022 dypme. All rights reserved.
//

import SwiftUI
import SwiftUI

struct RedButton: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding()
            .frame(maxWidth: .infinity)
            .foregroundColor(.white)
            .background(Color.pink)
            .clipShape(RoundedRectangle(cornerRadius: 20))
    }
}
