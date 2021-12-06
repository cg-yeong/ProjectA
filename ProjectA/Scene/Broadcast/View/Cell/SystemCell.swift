//
//  SystemCell.swift
//  ProjectA
//
//  Created by inforex on 2021/11/19.
//

import UIKit

class SystemCell: UICollectionViewCell {
    
    @IBOutlet weak var message: UILabel!
    
    var conts: Chat?
    
    override func prepareForReuse() {
        super.prepareForReuse()
        message.text = nil
    }
    
    func configCell() {
        guard let model = self.conts else { return }
        message.text = model.msg
    }
}
