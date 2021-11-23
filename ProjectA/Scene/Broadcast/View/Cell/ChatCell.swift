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
        profile.layer.cornerRadius = 18
        self.chat.sizeToFit()
        self.layoutIfNeeded()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        profile.image = nil
    }
    
    override func preferredLayoutAttributesFitting(_ layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
        let targetSize = CGSize(width: layoutAttributes.frame.width, height: 0)
        layoutAttributes.frame.size = contentView.systemLayoutSizeFitting(targetSize, withHorizontalFittingPriority: .required, verticalFittingPriority: .fittingSizeLevel)
        return layoutAttributes
    }
    
}
