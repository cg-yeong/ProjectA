//
//  StoryListModel.swift
//  ProjectA
//
//  Created by inforex on 2021/11/25.
//

import Foundation
import RxCocoa
import RxSwift

class StoryListModel {
    
    var removeFromSuperview = PublishSubject<Void>()
    
    var viewer = BehaviorRelay<MemInfo?>(value: nil)
    var stories = BehaviorRelay<[List]>(value: [])
    
    var page = 1
    var totalPage = 1
    var requestGuard = true
    
    
}
