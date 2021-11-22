//
//  Toast.swift
//  ProjectA
//
//  Created by inforex on 2021/07/27.
//

import UIKit

public class Toast: UIView {
    class func show(_ message: String) {
        guard let vc = App.visibleViewController() else {
            return
        }
        let toast = UILabel(frame: CGRect(x: vc.view.frame.size.width / 2 - 75, y: vc.view.frame.size.height / 2, width: 250, height: 30))
        
        toast.center.x = vc.view.center.x
        toast.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        toast.textColor = UIColor.white
        toast.font = UIFont.systemFont(ofSize: 14.0)
        toast.textAlignment = .center
        toast.text = message
        toast.alpha = 1.0
        toast.layer.cornerRadius = 10
        toast.clipsToBounds = true
        vc.view.addSubview(toast)
        UIView.animate(withDuration: 5.0, delay: 0.1, options: .curveEaseOut) {
            toast.alpha = 0.0
        } completion: { (isCompleted) in
            toast.removeFromSuperview()
        }
    }
}
