//
//  GridRow.swift
//  iOStarter
//
//  Created by Macintosh on 30/06/22.
//  Copyright © 2022 dypme. All rights reserved.
//

import SwiftUI
import Kingfisher

struct GridRow: View {
    var viewModel: ItemVM
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4.0) {
            KFImage(viewModel.imageUrl)
                .fitToAspectRatio(16/9)
            Text(viewModel.name)
                .foregroundColor(.black)
                .font(.system(size: 20, weight: .bold))
                .lineLimit(1)
            Text(viewModel.detail)
                .foregroundColor(.black)
                .font(.system(size: 16))
                .lineLimit(2)
        }
    }
}

struct GridRow_Previews: PreviewProvider {
    static var previews: some View {
        let item = Item(fromJson: "")
        item.id = 1
        item.name = "Tempsoft"
        item.image = "http://dummyimage.com/249x100.png/dddddd/000000"
        item.detail = "id nisl venenatis lacinia aenean sit amet justo morbi ut odio cras mi pede malesuada in imperdiet et"
        return GridRow(viewModel: ItemVM(data: item))
            .previewLayout(.fixed(width: 200, height: 200))
    }
}
