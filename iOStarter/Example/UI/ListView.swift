//
//  ListView.swift
//  iOStarter
//
//  Created by Macintosh on 28/06/22.
//  Copyright © 2022 dypme. All rights reserved.
//

import SwiftUI

struct ListView: View {
    @StateObject private var viewModel = ListVM()
    
    var body: some View {
        NavigationView {
            if viewModel.isLoading {
                ActivityIndicatorView(isAnimating: true)
                    .navigationBarTitle("Table")
            } else {
                List {
                    ForEach(viewModel.viewModelOfItems) { modelItem in
                        NavigationLink {
                            DetailView(viewModel: modelItem)
                        } label: {
                            ListRow(text: modelItem.name)
                        }
                    }
                    if viewModel.isAllowLoadMore {
                        ActivityIndicatorView(isAnimating: true)
                        .frame(maxWidth: .infinity)
                    }
                }
                .navigationBarTitle("Table")
            }
        }
        .onAppear {
            viewModel.fetch(isLoadMore: false, viewDidUpdate: nil, fetchDidFinish: nil)
        }
    }
}

struct TableView_Previews: PreviewProvider {
    static var previews: some View {
        ListView()
    }
}
