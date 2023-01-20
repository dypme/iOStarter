//
//  ShapeComponentUI.swift
//  iOStarter
//
//  Created by MBP2022_1 on 20/01/23.
//  Copyright © 2023 dypme. All rights reserved.
//

import SwiftUI

struct ShapeComponentUI: View {
    var body: some View {
        List {
            buildRectangle()
            buildRoundedRectangle()
            buildCapsule()
            buildEllipse()
            buildCircle()
        }
        .navigationTitle(Text("Shapes"))
    }
    
    @ViewBuilder
    func buildRectangle() -> some View {
        Section {
            Rectangle()
                .fill(.blue)
        } header: {
            Text("Rectangle")
        }
    }
    
    @ViewBuilder
    func buildRoundedRectangle() -> some View {
        Section {
            RoundedRectangle(cornerRadius: 8, style: .continuous)
                .fill(.red)
        } header: {
            Text("Rounded Rectangle")
        }
    }
    
    @ViewBuilder
    func buildCapsule() -> some View {
        Section {
            Capsule()
                .fill(.green)
        } header: {
            Text("Capsule")
        }
    }
    
    @ViewBuilder
    func buildEllipse() -> some View {
        Section {
            Ellipse()
                .fill(.yellow)
        } header: {
            Text("Ellipse")
        }
    }
    
    @ViewBuilder
    func buildCircle() -> some View {
        Section {
            Circle()
                .fill(.purple)
                .frame(height: 50)
        } header: {
            Text("Circle")
        }
    }
}

struct ShapeComponentUI_Previews: PreviewProvider {
    static var previews: some View {
        ShapeComponentUI()
    }
}
