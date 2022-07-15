//
//  HomeView.swift
//  iOStarter
//
//  Created by Macintosh on 01/07/22.
//  Copyright © 2022 dypme. All rights reserved.
//

import SwiftUI

struct HomeView: View {
    var body: some View {
        NavigationView {
            Text(L10n.halloWorld)
                .font(.system(size: 30, weight: .bold))
                .navigationBarTitle(Text(L10n.halloWorld), displayMode: .inline)
                
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
