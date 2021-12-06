//
//  BroadCastViewModel.swift
//  ProjectA
//
//  Created by inforex on 2021/11/25.
//

import Foundation
import RxSwift
import RxCocoa
import SwiftyJSON
import SocketIO

class BroadCastViewModel {
    
    let model = BroadCastModel()
    let bag = DisposeBag()
    
    struct Inputs {
        var text: Observable<String>
        var send: Observable<Void>
        var scrollDown: Observable<Void>
        
        var close_tap: Observable<Void>
        var screen_tap: Observable<Void>
    }
    
    var chats: BehaviorRelay<[Chat]>
    var text: Driver<String>
    var removeFromSuperview: Driver<Void>
    var keyboardDown: Driver<Void>
    var scrollDown: Driver<Void>
    
    init(_ inputs: Inputs) {
        BCSocket.shared.configSocketClient()
        
        chats = model.chats
        
        text = model.text
            .distinctUntilChanged()
            .map { $0 }
            .asDriver(onErrorRecover: { _ in .empty() })
        
        
        scrollDown = model.scrollDown
            .map { $0 }
            .asDriver(onErrorRecover: { _ in .empty() })
        
        removeFromSuperview = model.removeFromSuperview
            .map { $0 }
            .asDriver(onErrorRecover: { _ in .empty() })
        
        keyboardDown = model.keyboardDown
            .map { $0 }
            .asDriver(onErrorRecover: { _ in .empty() })
        
        inputs.text
            .bind(to: model.text)
            .disposed(by: bag)
        
        model.text
            .map { text in
                let trimCount = text.components(separatedBy: "\n").count - 1
                return text.count + (trimCount * 20) - trimCount
            }.bind(to: model.textCount)
            .disposed(by: bag)
        
        inputs.send // 앞뒤 공백 검사, 100자 미만 작성, 5줄 이내작성
            .throttle(.seconds(1), latest: false, scheduler: MainScheduler.instance)
            .withLatestFrom(model.text)
            .filter { text in
                if text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                    Toast.show("채팅을 입력해주세요.")
                    return false
                } else {
                    return true
                }
            }
            .withLatestFrom(model.textCount)
            .withLatestFrom(model.maxTextCount) { ($0, $1) }
            .withLatestFrom(model.maxLineCount) { ($0.0, $0.1, $1) }
            .withLatestFrom(model.text) { ($0.0, $0.1, $0.2, $1) }
            .map { textcount, max, line, text in
                let lineCount = text.components(separatedBy: "\n").count
                
                if textcount >= max {
                    Toast.show("100자 이내로 작성해주세요.")
                    return false
                } else if lineCount >= line {
                    Toast.show("5줄 이내로 작성해주세요.")
                    return false
                } else {
                    return true
                }
            }.filter { $0 }
            .withLatestFrom(model.text)
            .bind { [weak self] chat in
                guard let self = self else { return }
//                self.model.keyboardDown.onNext(())
                self.sendChat(text: chat, completion: {
                    self.model.text.accept("")
                })
            }.disposed(by: bag)
        
        
        inputs.scrollDown
            .throttle(.seconds(1), latest: false, scheduler: MainScheduler.instance)
            .map { _ in () }
            .bind(to: model.scrollDown)
            .disposed(by: bag)
        
        inputs.close_tap
            .throttle(.seconds(1), latest: false, scheduler: MainScheduler.instance)
            .bind { [weak self] _ in
                guard let self = self else { return }
                BCSocket.shared.socketDisconnect()
                self.model.removeFromSuperview.onNext(())
            }
            .disposed(by: bag)
        
        inputs.screen_tap
            .throttle(.seconds(1), latest: false, scheduler: MainScheduler.instance)
            .withLatestFrom(model.editing)
            .filter { $0 }
            .map { _ in () }
            .bind(to: model.keyboardDown)
            .disposed(by: bag)
        
        
        
        BCSocket.shared.cmd = self
    }
    
}

extension BroadCastViewModel {
    
    
    func setUp(_ initData: JSON) {
        
    }
    
    func editing(_ begin: Bool) {
        self.model.editing.accept(begin)
    }
    
    func sendChat(text: String, completion: (() -> Void)? = nil) {
        BCSocket.shared.sendChat(text: text)
        if let completion = completion {
            completion()
        }
    }
    
    func sendLikeEvent(completion: (() -> Void)? = nil) {
        BCSocket.shared.sendLike()
        
        if let completion = completion {
            completion()
        }
    }
}

extension BroadCastViewModel: receivePacket {
    
    func rcvChatMsg(data: JSON) {
        print(data)
        var userchat = model.chats.value
        userchat.insert(Chat(cmd: "ChatCell",
                              msg: data["msg"].stringValue,
                              from: data["from"].dictionaryValue),
                         at: 0)
//        userchat.append(Chat(cmd: "ChatCell",
//                             msg: data["msg"].stringValue,
//                             from: data["from"].dictionaryValue))
        model.chats.accept(userchat)
    }
    
    func rcvSystemMsg(data: JSON) {
        print(data)
        var syschat = model.chats.value
        syschat.insert(Chat(cmd: "SystemCell",
                              msg: data["msg"].stringValue),
                         at: 0)
//        syschat.append(Chat(cmd: "SystemCell",
//                             msg: data["msg"].stringValue))
        model.chats.accept(syschat)
    }
    
    func rcvPlayLikeAni() {
        LottieAnime.heartAnimation()
    }
    
    func rcvAlertMsg(data: JSON) {
        
        guard let vc = App.visibleViewController() else { return }
        let alert = UIAlertController(title: "알림", message: data["msg"].stringValue, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        
        vc.present(alert, animated: true, completion: nil)
    }
    
    func rcvToastMsg(data: JSON) {
        Toast.show("\(data["msg"].stringValue)")
    }
}
