//
//  Message.swift
//  ProjectA
//
//  Created by inforex on 2021/08/09.
//

import Foundation
import UIKit

class Message: UICollectionViewCell {
    @IBOutlet weak var profile: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var chatContentsView: UIView!
    @IBOutlet weak var chat: UILabel!
    
    var idx: Int = 0
    var delegate: CustomCellEventDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        profile.layer.cornerRadius = 18
        profile.clipsToBounds = true
        chatContentsView.layer.cornerRadius = 4
        chatContentsView.clipsToBounds = true
        
        translatesAutoresizingMaskIntoConstraints = false
        contentView.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width).isActive = true
        
        profile.isUserInteractionEnabled = true
        let cellImgTap = UITapGestureRecognizer(target: self, action: #selector(cellProfileTap(_:)))
        profile.addGestureRecognizer(cellImgTap)
    }
    
    @objc func cellProfileTap(_ sender: Any) {
        delegate?.moreEventButton(index: idx)
    }

}

