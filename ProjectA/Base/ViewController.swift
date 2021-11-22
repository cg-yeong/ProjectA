//
//  ViewController.swift
//  ProjectA
//
//  Created by inforex on 2021/07/01.
//

import UIKit
import Alamofire
import SwiftyJSON
import WebKit
import XHQWebViewJavascriptBridge
import KakaoSDKAuth
import KakaoSDKCommon
import KakaoSDKUser
import NaverThirdPartyLogin


struct Social: Decodable {
    let cmd: String
    let userInfo: String?
}

struct naver: Decodable {
    let message: String
    let response: response
}
struct response: Decodable {
    let email: String
}

class ViewController: UIViewController, WKNavigationDelegate {
    
    
    @IBOutlet weak var manprofileButton: UIButton!
    @IBOutlet weak var womanprofileButton: UIButton!
    
    @IBOutlet weak var wkWebView: WKWebView!
    var photoURLs = [String]()
    var setInfo: MemberAndPhoto?
    
    var bridge:WKWebViewJavascriptBridge?
    let naverLoginIns = NaverThirdPartyLoginConnection.getSharedInstance()
    /* func goURL(webview: WKWebView, urlString: String) {
     guard let url = URL(string: urlString) else {
     return
     }
     let request = URLRequest(url: url)
     webview.load(request)
     }*/
    var memberEmail: String = ""
    var home: String? {
        didSet {
            if home != nil {
                guard let url = URL(string: "\(home!)") else {
                    return
                }
                let req = URLRequest(url: url)
                wkWebView.load(req)
            }
            
        }
    }
    var handler: ((Result<[Member], Error>) -> Void)? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        wkWebView.navigationDelegate = self
        naverLoginIns?.delegate = self
        loadWebView()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    deinit {
        // MARK: - 테스트 위한 소셜 로그아웃
        kakaoLogout()
        naverLoginIns?.resetToken()
        print("VC deinit")
    }
    
    
    
}




