//
//  StorySendView.swift
//  ProjectA
//
//  Created by inforex on 2021/11/23.
//

import UIKit
import RxSwift
import RxCocoa

class StorySendView: XibView {
    
    @IBOutlet weak var another_view: UIView!
    @IBOutlet weak var super_view: UIView!
    @IBOutlet weak var close_btn: UIButton!
    @IBOutlet weak var placeholder_label: UILabel!
    @IBOutlet weak var send_btn: UIButton!
    @IBOutlet weak var conts_count_label: UILabel!
    @IBOutlet weak var conts_textView: UITextView!
    
    @IBOutlet weak var keyboardConst: NSLayoutConstraint!
    
    var viewModel: StorySendViewModel!
    let bag = DisposeBag()
    
    let sendBtnGradient: CAGradientLayer = CAGradientLayer()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        if initCheck {
            initialize()
            initCheck = false
            animateUp()
        }
    }
    
    override func removeFromSuperview() {
        animateDown { _ in
            super.removeFromSuperview()
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
        print("사연 보내기 deinit")
    }
    
    func initialize() {
        setTextView()
        setLayout()
        bind()
        
    }
    
    func setLayout() {
        setSendBtn()
        setShadow()
    }
    
    func setSendBtn() {
        sendBtnGradient.frame = send_btn.bounds
        sendBtnGradient.colors = [
            UIColor(red: 133/255, green: 129/255, blue: 1, alpha: 1).cgColor,
            UIColor(red: 152/255, green: 107/255, blue: 1, alpha: 1).cgColor
        ]
        sendBtnGradient.startPoint = CGPoint(x: 0, y: 0.5)
        sendBtnGradient.endPoint = CGPoint(x: 1, y: 0.5)
        sendBtnGradient.locations = [0,1]
        send_btn.layer.cornerRadius = 19
        send_btn.layer.masksToBounds = true
        send_btn.layer.addSublayer(sendBtnGradient)
    }
    
    func setShadow() {
        super_view.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5).cgColor
        super_view.layer.shadowOpacity = 1
        super_view.layer.shadowOffset = CGSize(width: 0, height: -8)
        super_view.layer.shadowRadius = 16
        let bounds = super_view.bounds
        let shadowPath = UIBezierPath(rect: CGRect(x: bounds.origin.x, y: bounds.origin.y, width: bounds.width, height: 5)).cgPath
        super_view.layer.shadowPath = shadowPath
        super_view.layer.shouldRasterize = true
        super_view.layer.rasterizationScale = UIScreen.main.scale
    }
    
    
}






