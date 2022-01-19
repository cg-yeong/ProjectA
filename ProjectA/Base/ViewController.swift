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



class ViewController: UIViewController, WKNavigationDelegate {
    
    @IBOutlet weak var manprofileButton: UIButton!
    @IBOutlet weak var womanprofileButton: UIButton!
    @IBOutlet weak var webContainerView: UIView!
    
    var photoURLs = [String]()
    var setInfo: MemberAndPhoto?
    var rest = RESTManager()
    
    var wkWebView: WKWebView!
    lazy var bridge = WKWebViewJavascriptBridge.bridge(forWebView: wkWebView!)
    
    let naverLoginIns = NaverThirdPartyLoginConnection.getSharedInstance()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        wkWebView = WKWebView()
        wkWebView?.frame = UIScreen.main.bounds
        self.webContainerView.addSubview(wkWebView!)
        
        wkWebView.navigationDelegate = self
        
        
        let url = URL(string: "http://babyhoney.kr/login")
        let request = URLRequest(url: url!)//.timeoutInterval = 2.0
        
        wkWebView.load(request)
        
        registerBridge()
        starShotBtn()
    }
    
    
    override func didReceiveMemoryWarning() {
        bridge.removeHandler(handlerName: "$.callFromWeb")
        super.didReceiveMemoryWarning()
    }
    deinit {
        
        print("VC deinit")
    }
    
    func starShotBtn() {
        let mChatBtn = UIButton()
        mChatBtn.setTitle("스타샷", for: .normal)
        mChatBtn.backgroundColor = .black
        mChatBtn.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(mChatBtn)
        let safeArea = view.safeAreaLayoutGuide
        
        mChatBtn.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -20).isActive = true
        mChatBtn.centerYAnchor.constraint(equalTo: safeArea.centerYAnchor).isActive = true
        mChatBtn.heightAnchor.constraint(equalToConstant: 100).isActive = true
        mChatBtn.widthAnchor.constraint(equalToConstant: 100).isActive = true
        
        mChatBtn.addTarget(self, action: #selector(openStarShot), for: .touchUpInside)
    }
    @objc func openStarShot() {
        print("슷탓샷 버튼")
        guard let vc = App.visibleViewController() else { return }
        let starShot = StarShot()
        starShot.frame = vc.view.bounds
        
        self.view.addSubview(starShot)
    }
    
    func createChatButton() {
        let chatBtn = UIButton()
        chatBtn.setTitle("채팅방 입장", for: .normal)
        chatBtn.backgroundColor = .black
        chatBtn.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(chatBtn)
        let safeArea = view.safeAreaLayoutGuide
        
        chatBtn.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 20).isActive = true
        chatBtn.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor, constant: -20).isActive = true
        chatBtn.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -20).isActive = true
        
        chatBtn.addTarget(self, action: #selector(openChat), for: .touchUpInside)
        
    }
    
    @objc func openChat() {
        print("채팅방 입장 버튼")
        guard let chatVC = UIStoryboard(name: "Broadcast", bundle: Bundle(for: Broadcast.self)).instantiateViewController(withIdentifier: "Broadcast") as? Broadcast else {
            return
        }
        
        chatVC.modalPresentationStyle = .fullScreen
        chatVC.modalTransitionStyle = .crossDissolve
        
//        chatVC.socket.conn()
//        chatVC.viewModel.socket.conn()
//        chatVC.socket.socket.on(clientEvent: .connect) { (dataArr, ack) in
//            chatVC.socket.reqRoomEnter()
//        }
        
        self.present(chatVC, animated: true, completion: nil)
        
    }
    
    func registerBridge() {
        bridge.registerHandler(handlerName: "$.callFromWeb", handler: { (data, responseCallback) in
            
            let decoder = JSONDecoder()
            
            do {
                let cmdName = try JSONSerialization.data(withJSONObject: data!, options: .prettyPrinted)
                let loginWhat = try decoder.decode(Social.self, from: cmdName)
                let socials = loginWhat.cmd
                let user = loginWhat.userInfo
                print("디코딩:", socials)
                
                if socials == "loginKakao" {
                    self.loginWithKakaoTalk()
                    
                } else if socials == "loginNaver" {
                    self.naverLogin()
                    
                } else if socials == "open_profile" {
                    print("유저:",user!)
                    self.wkWebView.isUserInteractionEnabled = false
                    self.rest.memberREST(email: user!) { member in
                        let memInfo = member?.mem_info
                        
                        let miniProfileSB = UIStoryboard(name: "MiniProfile", bundle: nil)
                        guard let miniProfileVC = miniProfileSB.instantiateViewController(withIdentifier: "ProfileViewController") as? ProfileViewController else { return }

                        miniProfileVC.MemInfoWithList = memInfo
                        miniProfileVC.modalPresentationStyle = .overFullScreen
                        self.present(miniProfileVC, animated: true, completion: nil)
                        
//                        guard let vc = App.visibleViewController() else { return }
//                        let profileView = ProfileView()
//                        profileView.frame = vc.view.bounds
//                        profileView.memInfo = memInfo
//                        self.view.addSubview(profileView)
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        self.wkWebView.isUserInteractionEnabled = true
                    }
                }
            } catch {
                print("디코딩 에러",error.localizedDescription)
            }
        })
    }
}
