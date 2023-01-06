//
//  DetailUI.swift
//  iOStarter
//
//  Created by Macintosh on 28/06/22.
//  Copyright © 2022 dypme. All rights reserved.
//

import SwiftUI
import Kingfisher

struct DetailUI: View {
    var viewModel: ItemVM
    
    var body: some View {
        VStack(alignment: .leading) {
            KFImage(viewModel.imageUrl)
                .fitToAspectRatio(16/9)
            Text(viewModel.name)
                .font(.system(size: 20, weight: .bold))
            Text(viewModel.detail)
                .font(.system(size: 16))
                .foregroundColor(Color.accentColor)
            Spacer()
        }
        .padding(.horizontal, 12)
        .navigationBarTitle(Text(L10n.Title.example), displayMode: .inline)
    }
}

struct DetailUI_Previews: PreviewProvider {
    static var previews: some View {
        let item = Item(fromJson: "")
        item.id = 1
        item.name = "Tempsoft"
        item.image = "http://dummyimage.com/249x100.png/dddddd/000000"
        item.detail = "id nisl venenatis lacinia aenean sit amet justo morbi ut odio cras mi pede malesuada in imperdiet et"
        return DetailUI(viewModel: ItemVM(data: item))
    }
}
