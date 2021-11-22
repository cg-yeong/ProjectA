//
//  KakaoToken.swift
//  ProjectA
//
//  Created by inforex on 2021/07/25.
//

import Foundation
import KakaoSDKUser
import KakaoSDKCommon
import KakaoSDKAuth

import Alamofire
import SwiftyJSON

extension ViewController {
    func hasKakaoToken() {
        if (AuthApi.hasToken()) {
            UserApi.shared.accessTokenInfo { (_, error) in
                if let error = error {
                    if let sdkError = error as? SdkError, sdkError.isInvalidTokenError() == true {
                        // 로그인 필요
                        self.loginWithKakaoTalk()
                    } else {
                        // 기타에러
                    }
                } else {
                    // 토큰 유효성 체크 성공(필요 시 토큰 갱신)
                    print("카카오 토큰 있어.")
                    self.getKakaoInfo()
                }
            }
            
        } else {
            self.loginWithKakaoTalk()
        }
    }
    
    func loginWithKakaoTalk() {
        // 카톡 설치 여부 확인
        if (UserApi.isKakaoTalkLoginAvailable()) {
            UserApi.shared.loginWithKakaoTalk { (oauthToken, error) in
                if let error = error {
                    print("카톡 로그인 오류",error)
                } else {
                    print("loginWithKakaoTalk() success.")
                    
                    // 로직
                    _ = oauthToken
                    // access Token?
                    _ = oauthToken?.accessToken
                    self.getKakaoInfo()
                }
            }
        } else {
            // 카톡 앱 x 웹 브라우저 통해 로그인
            UserApi.shared.loginWithKakaoAccount(prompts:[.Login]) { (oauthToken, error) in
                if let error = error {
                    print(error)
                } else {
                    print("loginWithKakaoAccount() success.")
                    _ = oauthToken
                    self.getKakaoInfo()
                }
            }
        }
        
        
    } // end


    func getKakaoInfo() {
        
        UserApi.shared.me { (user, error) in
            if let error = error {
                print(error.localizedDescription)
            } else {
                print("me() success.")

                // do something
                if let email = user?.kakaoAccount?.email {
                    print("email: \(email)")
                    SocialEmail.shared.email = email
                    self.rest.memberREST(email: SocialEmail.shared.email!) { meminfo in
                        if let mi = meminfo {
                            if mi.is_member {
                                print(mi.msg) // 회원입니다
                                SocialEmail.shared.email = mi.mem_info?.email
                                SocialEmail.shared.name = mi.mem_info?.name
                                SocialEmail.shared.profile = mi.mem_info?.profile_image
                                SocialEmail.shared.gender = mi.mem_info?.gender
                                guard let url = URL(string: WebpageData.basePage + mi.redirect_url + "/\(SocialEmail.shared.email!)") else {
                                    return
                                }
                                
                                var req = URLRequest(url: url)
                                req.timeoutInterval = 2.0
                                self.wkWebView.load(req)
                                self.createChatButton()
                                
                            } else {
                                print(meminfo?.msg as Any)
                                let joinView = JoinForm()
                                joinView.frame = UIScreen.main.bounds
                                self.view.addSubview(joinView)
                            }
                        }

                    }
                }
            }
        }
        
    }// end
}
