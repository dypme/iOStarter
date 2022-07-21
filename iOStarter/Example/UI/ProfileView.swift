//
//  ProfileView.swift
//  iOStarter
//
//  Created by Macintosh on 18/07/22.
//  Copyright © 2022 dypme. All rights reserved.
//

import SwiftUI
import Kingfisher

struct ProfileView: View {
    @StateObject private var viewModel = ProfileVM()
    
    var body: some View {
        NavigationView {
            VStack(alignment: .leading, spacing: 24) {
                KFImage(viewModel.imageUrl)
                    .frame(maxWidth: .infinity)
                    .frame(height: 100.0)
                ProfileDataView(placeholder: L10n.firstName, data: viewModel.firstName)
                ProfileDataView(placeholder: L10n.lastName, data: viewModel.lastName)
                ProfileDataView(placeholder: "Email", data: viewModel.email)
                ProfileDataView(placeholder: L10n.gender, data: viewModel.gender)
                Button(L10n.logout) {
                    viewModel.setLogout()
                }
                .buttonStyle(RedButton())
            }
            .padding()
            .navigationBarTitle(L10n.Title.profile)
        }
    }
}

struct ProfileDataView: View {
    let placeholder: String
    let data: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(placeholder)
            Text(data)
        }
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
    }
}
