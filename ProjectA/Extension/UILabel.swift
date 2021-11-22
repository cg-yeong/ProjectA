//
//  Gradient.swift
//  ProjectA
//
//  Created by inforex on 2021/07/27.
//

import Foundation
import UIKit

extension UILabel {
    func countLabelLines() -> Int {
        guard let myText = self.text as NSString? else {
            return 0
        }
        
        self.layoutIfNeeded()
        let rect = CGSize(width: self.bounds.width, height: CGFloat.greatestFiniteMagnitude)
        let labelSize = myText.boundingRect(with: rect, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: self.font as Any], context: nil)
        return Int(ceil(CGFloat(labelSize.height) / self.font.lineHeight))
    }
}
