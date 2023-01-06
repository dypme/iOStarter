//
//  HomeUI.swift
//  iOStarter
//
//  Created by Macintosh on 01/07/22.
//  Copyright © 2022 dypme. All rights reserved.
//

import SwiftUI

struct HomeUI: View {
    var body: some View {
        Text(L10n.halloWorld)
            .font(.system(size: 30, weight: .bold))
    }
}

struct HomeUI_Previews: PreviewProvider {
    static var previews: some View {
        HomeUI()
    }
}
