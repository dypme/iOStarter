//
//  ControlComponentUI.swift
//  iOStarter
//
//  Created by MBP2022_1 on 19/01/23.
//  Copyright © 2023 dypme. All rights reserved.
//

import SwiftUI

struct ControlComponentUI: View {
    @State private var slider = 0.0
    @State private var toggle = false
    @State private var date = Date()
    @State private var step = 0.0
    @State private var picker = "One"
    
    private var pickers = ["One", "Two", "Three"]
    
    var body: some View {
        List {
            Section {
                buildToggle()
            } header: {
                Text("Toggle")
            }
            
            Section {
                buildPicker()
            } header: {
                Text("Picker")
            }

            Section {
                buildDatePicker()
            } header: {
                Text("Date Picker")
            }
            
            Section {
                buildProgressIndicator()
            } header: {
                Text("Stepper")
            }

            Section {
                buildSlider()
            } header: {
                Text("Slider")
            }

        }.navigationTitle(Text("Controls"))
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
        Picker("Segmented", selection: $picker) {
            ForEach(pickers, id: \.self) {
                Text($0)
            }
        }
        .pickerStyle(.segmented)
        
        Picker("Context Menu", selection: $picker) {
            ForEach(pickers, id: \.self) {
                Text($0)
            }
        }
        
        if #available(iOS 16.0, *) {
            Picker("Navigation Link (iOS 16+)", selection: $picker) {
                ForEach(pickers, id: \.self) {
                    Text($0)
                }
            }
            .pickerStyle(.navigationLink)
        }
        
        Picker("Wheel", selection: $picker) {
            ForEach(pickers, id: \.self) {
                Text($0)
            }
        }
        .pickerStyle(.wheel)
    }
    
    @ViewBuilder
    func buildToggle() -> some View {
        Toggle("\(String(describing: toggle).capitalized)", isOn: $toggle)
    }
    
    @ViewBuilder
    func buildDatePicker() -> some View {
        DatePicker(selection: $date, displayedComponents: [.date]) {
            Text("Date")
        }.datePickerStyle(.compact)
        
        DatePicker(selection: $date, displayedComponents: [.hourAndMinute]) {
            Text("Date")
        }.datePickerStyle(.compact)
    }
    
    @ViewBuilder
    func buildProgressIndicator() -> some View {
        VStack {
            Stepper("Step (\(Int(step)))") {
                step = min((step + 5), 100)
            } onDecrement: {
                step = max((step - 5), 0)
            }
        }
    }
}

struct ControlComponentUI_Previews: PreviewProvider {
    static var previews: some View {
        ControlComponentUI()
    }
}
