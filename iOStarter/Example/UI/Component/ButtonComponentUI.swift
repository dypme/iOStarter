//
//  ButtonComponentUI.swift
//  iOStarter
//
//  Created by MBP2022_1 on 19/01/23.
//  Copyright © 2023 dypme. All rights reserved.
//

import SwiftUI

struct ButtonComponentUI: View {
    @State private var isAlertPresented = false
    @State private var isSheetPresented = false
    @State private var isActionSheetPresented = false
    
    var body: some View {
        List(content: {
            buildStandardButton()
            buildLinkButton()
            buildMenuButton()
        })
        .navigationTitle(Text("Buttons"))
    }
    
    @ViewBuilder
    func buildStandardButton() -> some View {
        Section(content: {
            Button {
                isAlertPresented = true
            } label: {
                Text("Show Alert")
            }
            .alert(isPresented: $isAlertPresented) {
                Alert(title: Text("Title"), message: Text("Alert Message"), primaryButton: .default(Text("Ok")), secondaryButton: .cancel())
            }
            
            Button {
                isSheetPresented = true
            } label: {
                Text("Show Sheet")
            }
            .sheet(isPresented: $isSheetPresented) {
                HomeUI()
            }
            
            Button {
                isActionSheetPresented = true
            } label: {
                Text("Show action sheet")
            }
            .actionSheet(isPresented: $isActionSheetPresented) {
                ActionSheet(title: Text("Title"), message: Text("Message"), buttons: [
                    .default(Text("First")),
                    .destructive(Text("Second")),
                    .cancel()
                ])
            }
            
        }, header: {
            Text("Button")
        })
    }
    
    @ViewBuilder
    func buildLinkButton() -> some View {
        Section {
            Button {
                UIApplication.shared.open(URL(string: "https://google.com")!)
            } label: {
                Text("Browser")
            }
            NavigationLink("WebView", destination: WebView(url: URL(string: "https://google.com")!))

        } header: {
            Text("Link")
        } footer: {
            Text("Open link https://google.com")
        }
    }
    
    @ViewBuilder
    func buildMenuButton() -> some View {
        Section {
            Menu {
                Button {
                    // Tap button here
                } label: {
                    Text("Button 1")
                }
                Menu("Sub Menu") {
                    Button {
                        // Tap sub button 1
                    } label: {
                        Text("Sub Button 1")
                    }
                    Button {
                        // Tap sub button 2
                    } label: {
                        Text("Sub Button 2")
                    }
                }
            } label: {
                Text("Show Menu")
            }

            HStack {
                Text("Context Menu")
                Spacer()
                Text("Press & Hold")
                    .font(.body.italic())
                    .foregroundColor(.gray)
            }
            .contextMenu {
                ForEach(1 ... 3, id: \.self) { index in
                    Button {
                        // Tap context menu 1
                    } label: {
                        Text("Button \(index)")
                    }

                }
            }
        } header: {
            Text("Menu")
        }
    }
}

struct ButtonComponentUI_Previews: PreviewProvider {
    static var previews: some View {
        ButtonComponentUI()
    }
}
