//
//  JoinForm+bind.swift
//  ProjectA
//
//  Created by inforex on 2021/11/23.
//

import UIKit
import RxSwift
import RxCocoa

extension JoinForm {
    
    func bind() {

        quitButton.rx.tap
            .bind { (_) in
                self.exitAlert()
            }.disposed(by: bag)

    }



    func exitAlert() {
        guard let vc = App.visibleViewController() else { return }
        let quit = UIAlertController(title: "뒤로가기", message: "회원가입을 취소하시겠습니까?", preferredStyle: .alert)
        let yes = UIAlertAction(title: "예", style: .default) { action in
            super.removeFromSuperview()
        }
        let no = UIAlertAction(title: "아니오", style: .cancel, handler: nil)
        quit.addAction(yes)
        quit.addAction(no)
        vc.present(quit, animated: true, completion: nil)
    }
    
}
