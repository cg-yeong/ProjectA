//
//  Socket.swift
//  ProjectA
//
//  Created by inforex on 2021/08/11.
//

import Foundation
import SocketIO
import SwiftyJSON
import RxSwift
import RxCocoa

class SocketManage: NSObject {
    
    let manager = SocketManager(socketURL: URL(string: "https://devsol6.club5678.com:5555")!,
                                config: [.reconnects(false)])
    
    var socket: SocketIOClient!
    
    override init() {
        super.init()
        socket = manager.socket(forNamespace: "/")
        
        print("소켓 초기화")
    }
    
    func conn() {
        
        socket.connect()
        print("소켓 연결 시도함")
        
    }
    
    func disconn() {
        
        socket.disconnect()
        print("소켓 연결 종료")
        
    }
    func reqRoomEnter() {
        
        let user: [String : Any] = ["cmd" : "reqRoomEnter",
                                    "mem_id" : SocialEmail.shared.email!,
                                    "chat_name" : SocialEmail.shared.name!,
                                    "mem_photo" : SocialEmail.shared.profile ?? "https://pida83.gabia.io/storage/QrrC86m3Nl3htEQruFbeSb5UpTNQyp8o8Op72pRY.png"]
        
            
        self.socket.emitWithAck("message", user).timingOut(after: 0) { dataArr in
            let jsonData = JSON(dataArr.first!)
            print(jsonData)
            let issuc = jsonData["success"].rawString()
            print(issuc)
            guard issuc == "y" else {
                return
            }
        }
            
            
           
    }
    
    func reqRoomOut() {
        let req = ["cmd" : "reqRoomOut"]
        socket.emitWithAck("message", req).timingOut(after: 0) { dataArray in
            print("reqOut", dataArray)
        }
    }
    
    func sendChat(text: String) {
        let want = ["cmd" : "sendChatMsg", "msg" : text]
        socket.emit("message", want)
    }
    
    func sendLike() {
        socket.emit("message", ["cmd" : "sendLike"])
    }    
    
    func rcv() {
        
        socket.on("message") { (dataArr, ack) in
            print("-- 리시브 메시지 --, 타입 : \(type(of: dataArr))") // 1
            let datadic = JSON(dataArr.first!)
            let cmds = datadic["cmd"].rawString()
            print(datadic)
            print("---")
            
            switch cmds {
            case "rcvChatMsg", "rcvSystemMsg":
                var pchat = Chat()
                pchat.cmd = cmds!
                pchat.msg = datadic["msg"].rawString()!
                pchat.from = datadic["from"].rawValue as? [String : Any]
                
                guard let bvc = App.visibleViewController() as? Broadcast else {
                    return
                }
                bvc.liveChat.insert(pchat, at: 0)
                bvc.msgCollectionView.reloadData()
                
            case "rcvRoomOut":
                guard let vc = App.visibleViewController() else {
                    return
                }
                self.disconn()
                vc.dismiss(animated: true) {
                    Toast.show("방장에 의해 강퇴되셨습니다.")
                }
                
            case "rcvAlertMsg":
                // Alert로 바꾸기
                guard let vc = App.visibleViewController() else { return }
                
                let alert = UIAlertController(title: "알림", message: datadic["msg"].rawString()!, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                vc.present(alert, animated: true, completion: nil)
                
            case "rcvToastMsg":
                Toast.show("\(datadic["msg"].rawString()!)")
                
            case "rcvPlayLikeAni":
                LottieAnime().heartAnimation()
                
            default:
                return
            }
        }
    
        
    }
    
}
