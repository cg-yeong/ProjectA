//
//  BroadCast+func.swift
//  ProjectA
//
//  Created by inforex on 2021/11/26.
//

import UIKit
import RxSwift
import RxCocoa
import Lottie
import SwiftyJSON
import SocketIO

extension Broadcast {
    
    func isEndofScroll() -> Bool {
        return msgCollectionView.contentOffset.y >= (msgCollectionView.contentSize.height - (msgCollectionView.frame.size.height + msgCollectionView.contentInset.bottom))
//        return msgCollectionView.contentOffset.y <= 0
    }
    
    func scrollToBottom() {
        let offset = CGPoint(x: 0,
                             y: msgCollectionView.contentSize.height - msgCollectionView.bounds.height + msgCollectionView.contentInset.bottom)
        if offset.y > 0 {
            msgCollectionView.setContentOffset(.zero, animated: true)
            
        }
    }
    
//    @objc func sendChatMessage() {
//        let chatText = msgTextView.text.trimmingCharacters(in: .whitespacesAndNewlines)
//        guard !chatText.isEmpty else {
//            Toast.show("채팅을 입력해주세요.")
//            return
//        }
//        socket.sendChat(text: chatText)
//        msgTextView.text = ""
//    }

    private func likeEvent() {
        
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
