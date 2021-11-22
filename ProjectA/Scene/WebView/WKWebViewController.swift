//
//  WKWebViewController.swift
//  ProjectA
//
//  Created by inforex on 2021/07/23.
//

import UIKit
import Alamofire
import WebKit
import XHQWebViewJavascriptBridge

class WKWebViewController: UINavigationController, WKNavigationDelegate{
    
    var bridge:WKWebViewJavascriptBridge?
    var webView: WKWebView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configUI()
    }
    
    func configUI() {
        webView = WKWebView(frame: self.view.bounds)
        self.view.addSubview(webView!)
        WebViewJavascriptBridge.enableLogging()
        bridge = WKWebViewJavascriptBridge.bridge(forWebView: webView!)
        bridge?.webViewDelegate = self
        loadWeb(webView!)
        configBridge()
    }
    func loadWeb(_ webView:WKWebView) {
        guard let url = URL(string: "https://pida83.gabia.io/login") else {
            return
        }
        let request = URLRequest(url: url)
        webView.load(request)
    }
    func configBridge() {
        bridge?.registerHandler(handlerName: "$.callFromWeb", handler: { (data, responseCallback) in
            print(data)
            responseCallback(data)
        })
        bridge?.callHandler(handlerName: "callFromWeb", data: ["cmd" : "loginKakao"])
    }
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        decisionHandler(.allow)
    }
    
}
