//
//  ChatCell.swift
//  ProjectA
//
//  Created by inforex on 2021/11/19.
//

import UIKit
import Kingfisher
import RxCocoa
import RxSwift

class ChatCell: UICollectionViewCell {
    
    @IBOutlet weak var profile: UIImageView!
    
    @IBOutlet weak var name: UILabel!
    
    @IBOutlet weak var chat: UILabel!
    
    let tapImage = UITapGestureRecognizer()
    var conts: Chat?
    var bag = DisposeBag()
    override func layoutSubviews() {
        super.layoutSubviews()
        profile.layer.cornerRadius = 18
        self.chat.sizeToFit()
        self.layoutIfNeeded()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        profile.image = nil
        bag = DisposeBag()
    }
    
    override func preferredLayoutAttributesFitting(_ layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
        let targetSize = CGSize(width: layoutAttributes.frame.width, height: 0)
        layoutAttributes.frame.size = contentView.systemLayoutSizeFitting(targetSize, withHorizontalFittingPriority: .required, verticalFittingPriority: .fittingSizeLevel)
        return layoutAttributes
    }
    
    func configCell() {
        guard let model = self.conts else { return }
        guard let from = model.from else { return }
        
        chat.text = model.msg
        name.text = from["chat_name"]?.stringValue
        profile.kf.setImage(with: URL(string: from["mem_photo"]?.stringValue ?? "https://pida83.gabia.io/storage/QrrC86m3Nl3htEQruFbeSb5UpTNQyp8o8Op72pRY.png"))
        
        profile.addGestureRecognizer(tapImage)
        tapImage.rx.event
            .bind { _ in
                RESTManager().memberREST(email: from["mem_id"]!.stringValue) { member in
                    let memInfo = member?.mem_info
                    guard let vc = App.visibleViewController() as? Broadcast else { return }
                    vc.viewModel.model.keyboardDown.onNext(())
                    let profileView = ProfileView()
                    profileView.frame = vc.view.bounds
                    profileView.memInfo = memInfo
                    vc.view.addSubview(profileView)
                }
            }.disposed(by: bag)
    }
    
}
