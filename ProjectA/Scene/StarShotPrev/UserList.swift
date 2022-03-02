//
//  UserList.swift
//  ProjectA
//
//  Created by inforex on 2021/12/06.
//

import UIKit
import RxSwift
import RxCocoa

class UserList: XibView {
    
    @IBOutlet var mainView: UIView!
    @IBOutlet weak var listContainerView: UIView!
    
    @IBOutlet weak var userListTableView: UITableView!
    @IBOutlet weak var exitChat: UIButton!
    
    let bag = DisposeBag()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        bind()
    }
    
    override func removeFromSuperview() {
        UIView.animate(withDuration: 0.5, delay: 0, options: [.curveLinear]) {
            self.frame.origin.x = self.bounds.width
        } completion: { _ in
            super.removeFromSuperview()
        }
    }
    
    func bind() {
        exitChat.rx.tap
            .bind { _ in
                self.removeFromSuperview()
            }
            .disposed(by: bag)
    }
}
