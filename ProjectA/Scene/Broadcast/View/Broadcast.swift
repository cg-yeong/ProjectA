//
//  ChatVC.swift
//  ProjectA
//
//  Created by inforex on 2021/08/03.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa

class Broadcast: UIViewController {
    
    @IBOutlet weak var liveHeader: UIView!
    @IBOutlet weak var chatView: UIView!
    @IBOutlet weak var liveView: UIView!
    @IBOutlet weak var keyboardConstraint: NSLayoutConstraint!
    @IBOutlet weak var msgView: UIView!
    @IBOutlet weak var msgPlaceholder: UILabel!
    @IBOutlet weak var msgTextView: UITextView!
    @IBOutlet weak var msgCollectionView: UICollectionView!
    
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var scrollButton: UIButton!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var sendButton: UIButton!
    
    let socket = SocketManage()
    var liveChat = [Chat]()
    let bag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.layoutIfNeeded()
        setView()
        setCollectionView()
        setTextView()
        bind()
        socket.rcv()
    }
    
    // set
    func setView() {
        msgView.cornerRadius = 18
        msgView.clipsToBounds = true
        setBlur()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    
    private func setBlur() {
        if let containerView = msgCollectionView.superview {
            let grad = CAGradientLayer(layer: containerView.layer)
            //            grad.frame = containerView.bounds
            grad.frame = CGRect(origin: .zero, size: CGSize(width: containerView.bounds.width, height: view.bounds.height))
            
            grad.colors = [ UIColor.clear.cgColor, UIColor.black.cgColor ]
            grad.startPoint = CGPoint(x: 0, y: 0)
            grad.endPoint = CGPoint(x: 0, y: 1)
            grad.locations = [0, 0.1]
            containerView.layer.mask = grad
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
        socket.reqRoomOut()
        socket.disconn()
        print("Live 방송VC deinit")
        view.removeFromSuperview()
    }
    
}

