//
//  StarShot.swift
//  ProjectA
//
//  Created by inforex on 2021/12/06.
//

import UIKit
import RxSwift
import RxCocoa

class StarShot: XibView {
    
    @IBOutlet weak var users: UIButton!
    @IBOutlet weak var closeBtn: UIButton!
    
    let bag = DisposeBag()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        bind()
    }
    
    override func removeFromSuperview() {
        super.removeFromSuperview()
    }
    
    func bind() {
        users.rx.tap
            .bind { _ in
                guard let vc = App.visibleViewController() else { return }
                let users = UserList()
                users.frame = vc.view.bounds
                
                self.addSubview(users)
            }.disposed(by: bag)
        
        closeBtn.rx.tap
            .bind { _ in
                self.removeFromSuperview()
            }.disposed(by: bag)
    }
    
}
