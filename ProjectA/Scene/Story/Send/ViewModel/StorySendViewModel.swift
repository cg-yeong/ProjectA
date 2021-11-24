//
//  StorySendViewModel.swift
//  ProjectA
//
//  Created by inforex on 2021/11/23.
//

import UIKit
import SwiftyJSON
import RxCocoa
import RxSwift

class StorySendViewModel {
    
    struct Input {
        var text: Observable<String>
        var send: Observable<Void>
        var close_tap: Observable<Void>
        var another_tap: Observable<Void>
    }
//    struct Output {
    var text: Driver<String>
    var textCount: Driver<Int>
    var keyboardDown: Driver<Void>
    var removeFromSuperView: Driver<Void>
//    }
    
    var model = StorySendModel()
    let bag = DisposeBag()

    init(_ input: Input) {
        // 1. ouput (모델에서 가져오는데 이건 나중에 init(input)으로 설정?
        
        text = model.text
            .distinctUntilChanged()
            .map { $0 }
            .asDriver(onErrorRecover: { _ in .empty() })

        textCount = model.textCount
            .distinctUntilChanged()
            .map { $0 }
            .asDriver(onErrorRecover: { _ in .empty() })

        keyboardDown = model.keyboardDown
            .map { $0 }
            .asDriver(onErrorRecover: { _ in .empty() })

        removeFromSuperView = model.removeFromSuperview
            .map { $0 }
            .asDriver(onErrorRecover: { _ in .empty() })
        // 2. input 들어온 input으로 가공 해서 model 에 저장
        
        input.text
            .bind(to: model.text)
            .disposed(by: bag)

        model.text
            .map { text in
                let trimCount = text.components(separatedBy: "\n").count - 1
                return text.count + (trimCount * 20) - trimCount
            }.bind(to: model.textCount)
            .disposed(by: bag)

        input.send
            .throttle(.seconds(1), latest: false, scheduler: MainScheduler.instance)
            .withLatestFrom(model.textCount) // 보내기 버튼의 void와 글자수 체크 위해 두개 합치기
            .withLatestFrom(model.maxTextCount) { ($0, $1) } // (textCount, maxTextcount)
            .withLatestFrom(model.minTextCount) { ($0.0, $0.1 , $1) } // (textCount, maxTextcount, minTextcount)
            .map { textcount, max, min in
                if textcount > max {
                    Toast.show("300자 이내로 작성 요망")
                    return false
                } else if textcount < min {
                    Toast.show("10자 이상 작성 바람")
                    return false
                } else {
                    return true
                }
            }.filter { $0 } // -> Bool : 글자 수 통과한것 - true만 아래로 내려감
            .withLatestFrom(model.text)
            .filter { text in
                if text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty { // 앞뒤 공백 제외하고 비어있는 지 검사
                    Toast.show("사연 입력해")
                    return false
                } else {
                    return true
                }
            }
            // From -> To
            .withLatestFrom(model.fromUser) { ($0, $1) }
            .withLatestFrom(model.toUser) { ($0.0, $0.1, $1) }
            .bind { [weak self] (text, from, to) in
                guard let self = self else { return }
                self.model.keyboardDown.onNext(())
                self.model.removeFromSuperview.onNext(())
                self.send(from, to: to, text: text) { res in
                    if res {
                        Toast.show("사연 전송 성공")
                    } else {
                        Toast.show("사연 전송 실패")
                    }
                }
            }.disposed(by: bag)

        input.close_tap
            .throttle(.seconds(1), latest: false, scheduler: MainScheduler.instance) // 1초동안 중복방지
            .map({ _ in () }) // Void -> ()
            .bind(to: model.removeFromSuperview)
            .disposed(by: bag)

        input.another_tap
            .throttle(.seconds(1), latest: false, scheduler: MainScheduler.instance)
            .withLatestFrom(model.editing)
            .bind { [weak self] editting in
                guard let self = self else { return }
                if editting {
                    self.model.keyboardDown.onNext(())
                } else {
                    self.model.removeFromSuperview.onNext(())
                }
            }
            .disposed(by: bag)
        
        
        
        
    }
}


