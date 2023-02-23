//
//  GridUI.swift
//  iOStarter
//
//  Created by Macintosh on 30/06/22.
//  Copyright © 2022 dypme. All rights reserved.
//

import SwiftUI

struct GridUI: View {
    @StateObject private var viewModel = ListVM()
    
    let columns = [
        GridItem(.adaptive(minimum: 150)),
    ]
    
    var body: some View {
        VStack {
            if viewModel.isLoading {
                ProgressView()
            } else {
                ScrollView {
                    LazyVGrid(columns: columns) {
                        ForEach(viewModel.viewModelOfItems) { modelItem in
                            NavigationLink {
                                DetailUI(viewModel: modelItem)
                            } label: {
                                GridRow(viewModel: modelItem)
                            }
                        }
                    }
                    .padding()
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

struct GridUI_Previews: PreviewProvider {
    static var previews: some View {
        GridUI()
    }
}
