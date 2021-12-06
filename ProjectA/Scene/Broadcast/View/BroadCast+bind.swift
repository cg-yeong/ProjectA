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
        
        let input = BroadCastViewModel.Inputs(text: msgTextView.rx.text.orEmpty.map { $0 },
                                              send: sendButton.rx.tap.map { _ in },
                                              scrollDown: scrollButton.rx.tap.map { _ in },
                                              close_tap: closeButton.rx.tap.map { _ in },
                                              screen_tap: screenTap.rx.event.map { _ in })
        viewModel = BroadCastViewModel(input)
        
        viewModel.text
            .distinctUntilChanged()
            .drive { [weak self] in
                guard let self = self else { return }
                self.msgTextView.text = $0
            }.disposed(by: bag)
        
        viewModel.text
            .map { !$0.isEmpty }
            .drive { [weak self] in
                guard let self = self else { return }
                self.msgPlaceholder.isHidden = $0
            }.disposed(by: bag)
        
        viewModel.keyboardDown
            .drive { [weak self] _ in
                guard let self = self else { return }
                self.view.endEditing(true)
                self.sendButton.isHidden = true
            }.disposed(by: bag)
        
        viewModel.removeFromSuperview
            .drive { [weak self] _ in
                guard let self = self else { return }
                self.dismiss(animated: true, completion: nil)
            }.disposed(by: bag)
        
        likeButton.rx.tap
            .throttle(.seconds(1), latest: false, scheduler: MainScheduler.instance)
            .bind { [weak self] _ in
                guard let self = self else { return }
                self.viewModel.sendLikeEvent {
                    self.likeButton.isEnabled = false
                    self.likeBtnAnimation(false)
                    DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
                        self.likeButton.isEnabled = true
                        self.likeBtnAnimation(true)
                    }
                }
            }
            .disposed(by: bag)
        
        msgCollectionView.rx.contentOffset
            .distinctUntilChanged()
            .map({ _ in
                self.msgCollectionView.contentOffset.y <= 0
            })
            .bind(to: scrollButton.rx.isHidden)
            .disposed(by: bag)
        
        viewModel.scrollDown
            .drive(onNext: { [weak self] _ in
                guard let self = self else { return }
                self.scrollToBottom()
            })
            .disposed(by: bag)
        
//        scrollButton.rx.tap
//            .bind { (_) in
//                self.scrollToBottom()
//            }.disposed(by: bag)
        
    }
    
    
    
}
