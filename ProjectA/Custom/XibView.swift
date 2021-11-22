//
//  XibView.swift
//  ProjectA
//
//  Created by inforex on 2021/07/26.
//

import Foundation
import UIKit
import SwiftyJSON

class XibView: UIView {
    
    var viewData: JSON = JSON()
    var initCheck = true
    
    
    required init(frame: CGRect, viewData : JSON) {
        super.init(frame: frame)
        self.viewData = viewData
        self.tag = 555
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.commonInit()
        self.tag = 555
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.commonInit()
        self.tag = 555
    }
    
    
    
    private func commonInit() {
        
        guard let xibName = NSStringFromClass(self.classForCoder).components(separatedBy: ".").last else { return }
        if let view = Bundle.main.loadNibNamed(xibName, owner: self, options: nil)?.first as? UIView{
            view.frame = self.bounds
            view.autoresizingMask = [.flexibleHeight,.flexibleWidth]
            self.addSubview(view)
        }
    }
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    override func removeFromSuperview() {
        super.removeFromSuperview()
    }
    
}
