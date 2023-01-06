//
//  ComponentUI.swift
//  iOStarter
//
//  Created by MBP2022_1 on 04/01/23.
//  Copyright © 2023 dypme. All rights reserved.
//

import SwiftUI

struct ComponentUI: View {
    @State private var slider = 0.0
    @State private var picker = "One"
    @State private var toggle = false
    @State private var date = Date()
    @State private var progress = 0.0
    @State private var text = ""
    
    private var pickers = ["One", "Two", "Three"]
    
    var body: some View {
        List {
            buildSlider()
            buildPicker()
            buildToggle()
            buildDatePicker()
            buildProgressIndicator()
            buildTextEditor()
            NavigationLink(destination: MapUI()) {
                Text("Open maps...")
                    .foregroundColor(.blue)
            }
            NavigationLink(destination: WebContentUI()) {
                Text("Open webview...")
                    .foregroundColor(.blue)
            }
        }
    }
    
    @ViewBuilder
    func buildSlider() -> some View {
        VStack {
            Text("Slider value: \(Int(slider))")
                .font(.system(size: 12))
            Slider(value: $slider, in: 0...100, step: 5) {
                Text("Value")
            } minimumValueLabel: {
                Text("0")
            } maximumValueLabel: {
                Text("100")
            }
        }
    }
    
    @ViewBuilder
    func buildPicker() -> some View {
        VStack(alignment: .leading) {
            Text("Picker - change style if needed")
                .font(.system(size: 12))
            Picker("Some Segmented", selection: $picker) {
                ForEach(pickers, id: \.self) {
                    Text($0)
                }
            }
            .pickerStyle(.segmented)
        }
    }
    
    @ViewBuilder
    func buildToggle() -> some View {
        Toggle("\(String(describing: toggle).capitalized)", isOn: $toggle)
    }
    
    @ViewBuilder
    func buildDatePicker() -> some View {
        DatePicker(selection: $date, displayedComponents: [.date]) {
            Text("Select Date")
        }.datePickerStyle(.compact)
    }
    
    @ViewBuilder
    func buildProgressIndicator() -> some View {
        VStack {
            Text("Progress indicator")
            ProgressView(value: progress, total: 100)
            Stepper("Progress (\(Int(progress)))") {
                progress = min((progress + 5), 100)
            } onDecrement: {
                progress = max((progress - 5), 0)
            }

        }
    }
    
    @ViewBuilder
    func buildTextEditor() -> some View {
        ZStack(alignment: .leading) {
            if text.isEmpty {
                VStack {
                    Text("Write something...")
                        .padding(.top, 10)
                        .padding(.leading, 6)
                        .opacity(0.6)
                    Spacer()
                }
            }
            TextEditor(text: $text)
        }
    }
}

struct ComponentUI_Previews: PreviewProvider {
    static var previews: some View {
        ComponentUI()
    }
}
