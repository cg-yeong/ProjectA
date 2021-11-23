//
//  BroadCast+bind.swift
//  ProjectA
//
//  Created by inforex on 2021/11/17.
//

import UIKit
import RxSwift
import RxCocoa
import Lottie

extension Broadcast {
    
    func bind() {
        let screenTap = UITapGestureRecognizer()
        view.addGestureRecognizer(screenTap)
        
        screenTap.rx.event
            .bind { (_) in
                if !self.sendButton.isHidden {
                    self.sendButton.isHidden = true
                }
                self.view.endEditing(true)
            }.disposed(by: bag)
        
        
        closeButton.rx.tap
            .bind { (_) in
                self.socket.disconn()
                self.dismiss(animated: true, completion: nil)
            }.disposed(by: bag)
        
        sendButton.rx.tap
            .bind { (_) in
                self.sendChatMessage()
            }.disposed(by: bag)
        
        likeButton.rx.tap
            .bind { (_) in
                self.likeEvent()
            }.disposed(by: bag)
        
        scrollButton.rx.tap
            .bind { (_) in
                self.scrollToBottom()
            }.disposed(by: bag)
        
        msgTextView.rx.text.orEmpty
            .distinctUntilChanged()
            .map({ $0.isEmpty })
            .map({ !$0 })
            .bind(to: msgPlaceholder.rx.isHidden)
            .disposed(by: bag)
        
        msgCollectionView.rx.contentOffset
            .map({ $0.y > 0 })
            .map({ !$0 })
            .bind(to: scrollButton.rx.isHidden)
            .disposed(by: bag)
    }
    
    
    @objc func sendChatMessage() {
        let chatText = msgTextView.text.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !chatText.isEmpty else {
            Toast.show("채팅을 입력해주세요.")
            return
        }
        socket.sendChat(text: chatText)
        msgTextView.text = ""
    }

    func likeEvent() {
        socket.sendLike()
        
        likeButton.isEnabled = false
        likeBtnAnimation(false)
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
            self.likeButton.isEnabled = true
            self.likeBtnAnimation(true)
        }
    }
    
    
    /* 좋아요 로티 처음 세팅 */
    func setLikeLottie() {
        likeBtnLottie = AnimationView(name: "ani_live_like_full")
        
        likeBtnLottie.frame = likeButton.bounds
        likeBtnLottie.contentMode = .scaleAspectFit
        likeBtnLottie.isUserInteractionEnabled = false
        likeBtnLottie.loopMode = .playOnce
        likeBtnLottie.tag = 300
        self.likeButton.addSubview(likeBtnLottie)
        
    }
    
    @objc func likeBtnAnimation(_ on: Bool) {
        guard on else {
            likeBtnLottie.stop()
            return
        }
        likeBtnLottie.play()
    }
}
