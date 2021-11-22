//
//  AppDelegate.swift
//  ProjectA
//
//  Created by inforex on 2021/07/01.
//

import UIKit
import KakaoSDKCommon
import KakaoSDKAuth
import NaverThirdPartyLogin

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        KakaoSDKCommon.initSDK(appKey: "d9430748c9e1358dd25f36a148e0a81f")
        
        let naver = NaverThirdPartyLoginConnection.getSharedInstance()
        // 네이버 앱으로 인증하는 방식을 활성화
        naver?.isNaverAppOauthEnable = true
        // SafariVC에서 인증방식을 활성화
        naver?.isInAppOauthEnable = true
        // 인증화면을 세로모드에서만 활성화
        naver?.isOnlyPortraitSupportedInIphone()
        
        // 네이버 아이디로 로그인하기 설정
        // 애플리케이션을 등록할 때 입력한 URL Scheme
        naver?.serviceUrlScheme = kServiceAppUrlScheme
        // 애플리케이션을 등록 후 발급받은 클라이언트 아이디
        naver?.consumerKey = kConsumerKey
        naver?.consumerSecret = kConsumerSecret
        naver?.appName = kServiceAppName
        return true
    }
    
    // MARK: iOS 13 이하 카카오톡을 통한 사용자 인증 필요함수 추가
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        if (AuthApi.isKakaoTalkLoginUrl(url)) {
            return AuthController.handleOpenUrl(url: url)
        } else {
            NaverThirdPartyLoginConnection.getSharedInstance().application(app, open: url, options: options)
            return true
        }
        
    }
    
    
    
    // MARK: UISceneSession Lifecycle

    @available(iOS 13.0, *)
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    @available(iOS 13.0, *)
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}

