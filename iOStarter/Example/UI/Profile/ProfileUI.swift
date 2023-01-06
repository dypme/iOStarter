//
//  ProfileUI.swift
//  iOStarter
//
//  Created by Macintosh on 18/07/22.
//  Copyright © 2022 dypme. All rights reserved.
//

import SwiftUI
import Kingfisher

struct ProfileUI: View {
    @StateObject private var viewModel = ProfileVM()
    
    var body: some View {
        VStack(alignment: .leading, spacing: 24) {
            KFImage(viewModel.imageUrl)
                .frame(maxWidth: .infinity)
                .frame(height: 100.0)
            profileDataView(placeholder: L10n.firstName, data: viewModel.firstName)
            profileDataView(placeholder: L10n.lastName, data: viewModel.lastName)
            profileDataView(placeholder: "Email", data: viewModel.email)
            profileDataView(placeholder: L10n.gender, data: viewModel.gender)
            Button(L10n.logout) {
                viewModel.setLogout()
            }
        }
        .padding()
    }
    
    @ViewBuilder
    func profileDataView(placeholder: String, data: String) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(placeholder)
            Text(data)
        }
    }
}

struct ProfileUI_Previews: PreviewProvider {
    static var previews: some View {
        ProfileUI()
    }
}
