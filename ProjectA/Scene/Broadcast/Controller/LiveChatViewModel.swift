//
//  LiveChatViewModel.swift
//  ProjectA
//
//  Created by inforex on 2021/08/20.
//

import Foundation
import RxCocoa
import RxSwift

class LiveChatViewModel: NSObject {
    let socket = SocketManage()
    var liveChat = [Chat]()
    
    var chatContents: Observable<String> = Observable.just("")
    
    
    override init() {
        super.init()
//        socketRcv()
    }
    func socketRcv() {
        _ = socket.rcv()
            .subscribe(onNext: { eventChat in
                self.liveChat.insert(eventChat!, at: 0)
//                if self.msgCollectionView.contentOffset.y <= 0 {
//                    self.msgCollectionView.reloadData()
//                }
            }, onError: { err in
                print("에러 발생: ", err)
            }) // socket.rcv() End
    }
    
}
