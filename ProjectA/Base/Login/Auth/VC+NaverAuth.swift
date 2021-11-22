//
//  ViewController+Login.swift
//  ProjectA
//
//  Created by inforex on 2021/07/22.
//

import Foundation
import UIKit
import WebKit
import XHQWebViewJavascriptBridge

import Alamofire
import SwiftyJSON
import NaverThirdPartyLogin


extension ViewController: NaverThirdPartyLoginConnectionDelegate {
    
    // MARK: 네이버 관련
    // 토큰 유효성 검사
    func naverLogin() {
        
        naverLoginIns?.delegate = self
        naverLoginIns?.resetToken()
        naverLoginIns?.requestThirdPartyLogin()
        
//        if naverLoginIns?.accessToken == nil {
//            
//        } else {
//            getNaverInfo()
//        }
        
        
    }
    // 로그인 성공 호출
    func oauth20ConnectionDidFinishRequestACTokenWithAuthCode() {
        print("네이버로그인 성공")
        getNaverInfo()
    }
    // 토큰 새로고침
    func oauth20ConnectionDidFinishRequestACTokenWithRefreshToken() {
        if let naverLoginIns = naverLoginIns {
            if !naverLoginIns.isValidAccessTokenExpireTimeNow() {
                naverLoginIns.requestAccessTokenWithRefreshToken() 
            }
        }
    }
    // 연동해제 로그아웃
    func oauth20ConnectionDidFinishDeleteToken() {
        naverLoginIns?.requestDeleteToken()
        naverLoginIns?.resetToken()
        print("네이버 로그아웃")
    }
    // error
    func oauth20Connection(_ oauthConnection: NaverThirdPartyLoginConnection!, didFailWithError error: Error!) {
        print("너 왜 다시해\(error.localizedDescription)")
        if naverLoginIns?.accessToken != nil {
            print("토큰이 이미 있어!")
        }
    }
    
    func oauth20Connection(_ oauthConnection: NaverThirdPartyLoginConnection!, didFailAuthorizationWithRecieveType receiveType: THIRDPARTYLOGIN_RECEIVE_TYPE) {
        
    }
    
    func getNaverInfo() {
        guard let isValidAccessToken = naverLoginIns?.isValidAccessTokenExpireTimeNow() else { return }
        if !isValidAccessToken { return }
        
        guard let tokenType = naverLoginIns?.tokenType else { return }
        guard let accessToken = naverLoginIns?.accessToken else { return }
        let urlString = "https://openapi.naver.com/v1/nid/me"
        let url = URL(string: urlString)!
        
        let authorization = "\(tokenType) \(accessToken)"
        AF.request(url, method: .get, parameters: nil, encoding: JSONEncoding.prettyPrinted, headers: ["Authorization": authorization]).responseJSON { response in
            print(response)
            switch response.result {
            case .success(let data):
                let decoder = JSONDecoder()
                do {
                    let data = try JSONSerialization.data(withJSONObject: data, options: .prettyPrinted)
                    let naverResponse = try decoder.decode(naver.self, from: data)
                    let naverEmail = naverResponse.response.email
                    SocialEmail.shared.email = naverEmail+"1"
                    
                    print(naverEmail)
                    // 이메일로 회원 체크
//                    self.reqMember(email: naverEmail)
                    self.rest.memberREST(email: SocialEmail.shared.email!) { meminfo in
                        if let mi = meminfo {
                            if mi.is_member {
                                print(mi.msg)
                                guard let url = URL(string: WebpageData.basePage + mi.redirect_url + "/\(SocialEmail.shared.email!)") else {
                                    return
                                }
                                var req = URLRequest(url: url)
                                req.timeoutInterval = 2.0
                                self.wkWebView.load(req)
                                self.createChatButton()
                                if let mems = mi.mem_info {
                                    SocialEmail.shared.email = mems.email
                                    SocialEmail.shared.gender = mems.gender
                                    SocialEmail.shared.name = mems.name
                                    SocialEmail.shared.profile = mems.profile_image
                                }
                            }
                            
                        } else {
                            print(meminfo?.msg as Any)
                            let joinView = JoinForm()
                            joinView.frame = UIScreen.main.bounds
                            self.view.addSubview(joinView)
                        }
                    }
                    
                } catch {
                    
                }
            case .failure(let error):
                print(error.localizedDescription)
            
            }
            
        }
    }
    
}
