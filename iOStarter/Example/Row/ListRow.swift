//
//  ListRow.swift
//  iOStarter
//
//  Created by Macintosh on 28/06/22.
//  Copyright © 2022 dypme. All rights reserved.
//

import SwiftUI

struct ListRow: View {
    var text: String
    
    var body: some View {
        HStack {
            Text(text)
            Spacer()
        }
    }
}

struct ListRow_Previews: PreviewProvider {
    static var previews: some View {
        ListRow(text: "Hallo World")
            .previewLayout(.fixed(width: 300, height: 70))
    }
}
