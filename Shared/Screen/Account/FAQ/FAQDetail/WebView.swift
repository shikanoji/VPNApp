//
//  WebView.swift
//  SysVPN (iOS)
//
//  Created by Da Phan Van on 12/06/2022.
//

import Foundation
import SwiftUI
import WebKit

struct WebView: UIViewRepresentable {
    class Coordinator: NSObject, WKNavigationDelegate {
        var parent: WebView

        init(_ parent: WebView) {
            self.parent = parent
        }

        func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
            if (webView.isLoading) {
                return
            }
            parent.finishedLoading = true
        }
    }
    
    var url: URL
    @Binding var finishedLoading: Bool
    
    func makeUIView(context: Context) -> WKWebView {
        let webView = WKWebView()
        webView.navigationDelegate = context.coordinator
        return WKWebView()
    }

    func updateUIView(_ webView: WKWebView, context: Context) {
        let request = URLRequest(url: url)
        webView.navigationDelegate = context.coordinator
        webView.load(request)
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    
}
