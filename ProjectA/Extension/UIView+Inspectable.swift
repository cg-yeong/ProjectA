//
//  Extension.swift
//  ProjectA
//
//  Created by inforex on 2021/07/21.
//

import Foundation
import UIKit

// MARK: UIView
extension UIView {
    
    @IBInspectable var borderWidth: CGFloat {
        set {
            layer.borderWidth = newValue
        }
        get {
            return layer.cornerRadius
        }
    }
    
    @IBInspectable var cornerRadius: CGFloat {
        set {
            layer.cornerRadius = newValue
        }
        get {
            return layer.cornerRadius
        }
    }
    
    @IBInspectable var borderColor: UIColor? {
        set {
            guard let uiColor = newValue else {
                return
            }
            layer.borderColor = uiColor.cgColor
        }
        
        get {
            guard let color = layer.borderColor else {
                return nil
            }
            return UIColor(cgColor: color)
        }
    }
}

extension UIView{
    
    func animateUp(_ duration: TimeInterval = 0.5, delay: Double = 0, completion: ((Bool)->Void)? = nil){
        self.frame.origin.y = self.bounds.height
        UIView.animate(withDuration: duration, delay: delay, options: [.curveEaseIn],
                       animations: {
                        self.frame.origin.y = 0
        }, completion: completion)
        self.isHidden = false
    }
  
    func animateDown(_ duration: TimeInterval = 0.5, delay: Double = 0, completion: ((Bool)->Void)? = nil){
        UIView.animate(withDuration: duration, delay: delay, options: [.curveLinear],
                       animations: {
                        self.center.y = self.bounds.height
        },  completion: completion)
        
        UIView.animate(withDuration: duration,  delay: delay, options: [.curveLinear], animations: {
            self.frame.origin.y = self.bounds.height
        }, completion: completion)
    }
    
}
