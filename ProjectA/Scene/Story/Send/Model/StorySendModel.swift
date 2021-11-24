//
//  StorySendModel.swift
//  ProjectA
//
//  Created by inforex on 2021/11/24.
//

import Foundation
import RxSwift
import RxCocoa

class StorySendModel {
    
    var text = BehaviorRelay<String>(value: "")
    var textCount = BehaviorRelay<Int>(value: 0)
    var editing = BehaviorRelay<Bool>(value: false)
    var keyboardDown = PublishSubject<Void>()
    var removeFromSuperview = PublishSubject<Void>()
    
    var fromUser = PublishSubject<MemInfo>()
    var toUser = PublishSubject<MemInfo>()
    
    let weight = BehaviorRelay<Int>(value: 20)
    let maxTextCount = BehaviorRelay<Int>(value: 300)
    let minTextCount = BehaviorRelay<Int>(value: 10)
    
}
