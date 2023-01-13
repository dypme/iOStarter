//
//  WebView.swift
//  iOStarter
//
//  Created by MBP2022_1 on 05/01/23.
//  Copyright © 2023 dypme. All rights reserved.
//

import Foundation
import SwiftUI
import WebKit

struct WebView: UIViewRepresentable {
    typealias UIViewType = WKWebView
    
    private let webView: WKWebView
    private let didStartLoad: (() -> ())?
    private let didFinishLoad: (() -> ())?
    private let decidePolicyFor: ((_ navigationAction: WKNavigationAction, _ decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) -> ())?
    
    init(url: URL, didStartLoad: (() -> ())? = nil, didFinishLoad: (() -> ())? = nil, decidePolicyFor: ((_ navigationAction: WKNavigationAction, _ decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) -> ())? = nil) {
        self.init(request: URLRequest(url: url), didStartLoad: didStartLoad, didFinishLoad: didFinishLoad)
    }
    
    init(request: URLRequest, didStartLoad: (() -> ())? = nil, didFinishLoad: (() -> ())? = nil, decidePolicyFor: ((_ navigationAction: WKNavigationAction, _ decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) -> ())? = nil) {
        webView = WKWebView()
        webView.load(request)
        self.didStartLoad = didStartLoad
        self.didFinishLoad = didFinishLoad
        self.decidePolicyFor = decidePolicyFor
    }
    
    init(string: String, baseURL: URL?, didStartLoad: (() -> ())? = nil, didFinishLoad: (() -> ())? = nil, decidePolicyFor: ((_ navigationAction: WKNavigationAction, _ decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) -> ())? = nil) {
        webView = WKWebView()
        webView.loadHTMLString(string, baseURL: baseURL)
        self.didStartLoad = didStartLoad
        self.didFinishLoad = didFinishLoad
        self.decidePolicyFor = decidePolicyFor
    }
    
    func makeUIView(context: Context) -> WKWebView {
        webView.navigationDelegate = context.coordinator
        return webView
    }
    
    func updateUIView(_ uiView: WKWebView, context: Context) {
        
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, WKNavigationDelegate {
        let parent: WebView
        
        init(_ parent: WebView) {
            self.parent = parent
        }
        
        func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
            parent.didStartLoad?()
        }
        
        func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
            parent.didFinishLoad?()
        }
        
        func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
            if let decidePolicy = parent.decidePolicyFor {
                decidePolicy(navigationAction, decisionHandler)
                return
            }
            decisionHandler(.allow)
        }
    }
}
