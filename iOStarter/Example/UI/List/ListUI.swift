//
//  ListUI.swift
//  iOStarter
//
//  Created by Macintosh on 28/06/22.
//  Copyright © 2022 dypme. All rights reserved.
//

import SwiftUI

struct ListUI: View {
    @StateObject private var viewModel = ListVM()
    
    var body: some View {
        VStack {
            if viewModel.isLoading {
                ProgressView()
            } else {
                List {
                    ForEach(viewModel.viewModelOfItems) { modelItem in
                        NavigationLink {
                            DetailUI(viewModel: modelItem)
                        } label: {
                            ListRow(text: modelItem.name)
                        }
                    }
                    if viewModel.isAllowLoadMore {
                        ProgressView()
                    }
                }
            }
        }
        .onAppear {
            Task {
                await viewModel.fetch(isLoadMore: false)
            }
        }
    }
}

struct ListUI_Previews: PreviewProvider {
    static var previews: some View {
        ListUI()
    }
}
