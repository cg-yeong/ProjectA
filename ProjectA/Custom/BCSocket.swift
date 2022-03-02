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

protocol receivePacket {
    func rcvChatMsg(data: JSON)
    func rcvSystemMsg(data: JSON)
    func rcvRoomOut()
    func rcvAlertMsg(data: JSON)
    func rcvToastMsg(data: JSON)
    func rcvPlayLikeAni()
}

extension receivePacket {
    func rcvChatMsg(data: JSON) {}
    func rcvSystemMsg(data: JSON) {}
    func rcvRoomOut() {}
    func rcvAlertMsg(data: JSON) {}
    func rcvToastMsg(data: JSON) {}
    func rcvPlayLikeAni() {}
}

class BCSocket: NSObject {
    
    static let shared = BCSocket()
    
    let ioURL = "https://devsol6.club5678.com:5555"
    
    
    var sioManager: SocketManager?
    var cmd: receivePacket?
    
    override init() {
        super.init()
        configSocketClient()
        print("소켓 초기화")
    }
    
    func configSocketClient() {
        let onConnect: NormalCallback = { (data, ack) in
            print("test onConnect")
            self.reqRoomEnter(completion: nil)
        }
        
        let onDisconnect: NormalCallback = { (data, ack) in
            print("test onDisconnect")
        }
        
        let onError: NormalCallback = { (data, ack) in
            print("test onError")
        }
        
        let onReconnect: NormalCallback = { (data, ack) in
            print("test onReconnect")
        }
        
        let onReconnectAttemp: NormalCallback = { (data, ack) in
            print("test onReconnect 시도")
        }
        
        let onMessage: NormalCallback = { (data, ack) in
            // 연결 후 메시지 패킷
            guard let data = data.first else { return } // 가장 상위 객체 벗겨내고
            let nextData = JSON(data)                   // JSON 구조로 전달
            self.onMessageReceive(data: nextData)
        }
        
        guard let url = URL(string: ioURL) else { return }
        sioManager = SocketManager(socketURL: url,
                                   config: [.reconnects(false),
                                            .log(false),
                                            .forceNew(true)])
        
        guard let sioManager = sioManager else { return }
        
        sioManager.defaultSocket.on(clientEvent: .connect, callback: onConnect)
        sioManager.defaultSocket.on(clientEvent: .disconnect, callback: onDisconnect)
        sioManager.defaultSocket.on(clientEvent: .error, callback: onError)
        sioManager.defaultSocket.on(clientEvent: .reconnect, callback: onReconnect)
        sioManager.defaultSocket.on(clientEvent: .reconnectAttempt, callback: onReconnectAttemp)
        sioManager.defaultSocket.on("message", callback: onMessage)
        
        sioManager.defaultSocket.connect()
        print("소켓 연결 시도함")
        
    }
    
    func socketDisconnect() {
        if let manager = sioManager {
            manager.reconnects = false
            manager.defaultSocket.removeAllHandlers()
            manager.defaultSocket.disconnect()
            sioManager = nil
        }
        
        print("소켓 연결 종료")
        
    }
    
    
    func onMessageReceive(data: JSON) {
        switch data["cmd"].stringValue { // 서버 패킷 cmd 종류 분기처리
        case "rcvChatMsg"       : cmd?.rcvChatMsg(data: data)
        case "rcvSystemMsg"     : cmd?.rcvSystemMsg(data: data)
        case "rcvRoomOut"       : cmd?.rcvRoomOut()
        case "rcvAlertMsg"      : cmd?.rcvAlertMsg(data: data)
        case "rcvToastMsg"      : cmd?.rcvToastMsg(data: data)
        case "rcvPlayLikeAni"   : cmd?.rcvPlayLikeAni()
        default:
            print("이외 데이터 or 실패")
        }
    }
    
    func reqRoomEnter(completion: (() -> Void)? = nil) {
        let user: [String : Any] = ["cmd"       : "reqRoomEnter",
                                    "mem_id"    : SocialEmail.shared.email!,
                                    "chat_name" : SocialEmail.shared.name!,
                                    "mem_photo" : SocialEmail.shared.profile ?? "https://pida83.gabia.io/storage/QrrC86m3Nl3htEQruFbeSb5UpTNQyp8o8Op72pRY.png"]
        
        guard let sioManager = sioManager else { return }
        sioManager.defaultSocket.emitWithAck("message", user).timingOut(after: 0) { data in
            let jsonData = JSON(data.first!)
            let issuc = jsonData["success"].rawString()
            print(issuc ?? "")
            guard issuc == "y" else {
                return
            }
            
            if let completion = completion {
                completion()
            }
        }
    }
    
    func reqRoomOut() {
        let req = ["cmd" : "reqRoomOut"]
        guard let sioManager = sioManager else { return }

        sioManager.defaultSocket.emitWithAck("message", req).timingOut(after: 0) { dataArray in
            print("reqOut", dataArray)
        }
    }
    
    func sendChat(text: String) {
        guard let sioManager = sioManager else { return }

        sioManager.defaultSocket.emit("message", ["cmd" : "sendChatMsg",
                                "msg" : text])
    }
    
    func sendLike() {
        guard let sioManager = sioManager else { return }
        
        sioManager.defaultSocket.emit("message", ["cmd" : "sendLike"])
    }
    
//            case "rcvAlertMsg":
//                // Alert로 바꾸기
//                guard let vc = App.visibleViewController() else { return }
//
//                let alert = UIAlertController(title: "알림", message: datadic["msg"].rawString()!, preferredStyle: .alert)
//                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
//                vc.present(alert, animated: true, completion: nil)
//

    
}
