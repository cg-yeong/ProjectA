//
//  BC+Model.swift
//  ProjectA
//
//  Created by inforex on 2021/12/01.
//

import Foundation
import RxSwift
import RxCocoa

class BroadCastModel {
    
    var chats = BehaviorRelay<[Chat]>(value: [])
    
    var scrollDown = PublishSubject<Void>()
    var text = BehaviorRelay<String>(value: "")
    var textCount = BehaviorRelay<Int>(value: 0)
    var editing = BehaviorRelay<Bool>(value: false)
    var keyboardDown = PublishSubject<Void>()
    var removeFromSuperview = PublishSubject<Void>()
    
    let weight = BehaviorRelay<Int>(value: 20)
    let maxTextCount = BehaviorRelay<Int>(value: 100)
    let minTextCount = BehaviorRelay<Int>(value: 1)
    let maxLineCount = BehaviorRelay<Int>(value: 5)
}
