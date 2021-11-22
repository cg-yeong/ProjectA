//
//  ChatCell.swift
//  ProjectA
//
//  Created by inforex on 2021/11/19.
//

import UIKit

class ChatCell: UICollectionViewCell {
    
    @IBOutlet weak var profile: UIImageView!
    
    @IBOutlet weak var name: UILabel!
    
    @IBOutlet weak var chat: UILabel!
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.chat.sizeToFit()
        self.layoutIfNeeded()
    }
    
    
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
    
}
