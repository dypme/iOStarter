//
//  GridView.swift
//  iOStarter
//
//  Created by Macintosh on 30/06/22.
//  Copyright © 2022 dypme. All rights reserved.
//

import SwiftUI
import WaterfallGrid

struct GridView: View {
    @StateObject private var viewModel = ListVM()
    
    var body: some View {
        NavigationView {
            if viewModel.isLoading {
                ActivityIndicatorView(isAnimating: true)
                    .navigationBarTitle("Grid")
            } else {
                ScrollView {
                    WaterfallGrid(viewModel.viewModelOfItems) { modelItem in
                            NavigationLink {
                                DetailView(viewModel: modelItem)
                            } label: {
                                GridRow(viewModel: modelItem)
                            }
                    }
                    .gridStyle(spacing: 12)
                    .padding()
                    if viewModel.isAllowLoadMore {
                        ActivityIndicatorView(isAnimating: true)
                        .frame(maxWidth: .infinity)
                    }
                }
                .navigationBarTitle("Grid")
            }
        }
        .onAppear {
            viewModel.fetch(isLoadMore: false, viewDidUpdate: nil, fetchDidFinish: nil)
        }
    }
}

struct GridView_Previews: PreviewProvider {
    static var previews: some View {
        GridView()
    }
}
