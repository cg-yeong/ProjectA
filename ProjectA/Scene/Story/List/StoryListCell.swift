//
//  StoryListCell.swift
//  ProjectA
//
//  Created by inforex on 2021/11/25.
//

import UIKit
import RxSwift
import RxCocoa
import Kingfisher

class StoryListCell: UITableViewCell {
    
    @IBOutlet weak var thumbnail_imageView: UIImageView!
    @IBOutlet weak var gender: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var clock: UIImageView!
    @IBOutlet weak var sentDate: UILabel!
    @IBOutlet weak var conts_view: UIView!
    @IBOutlet weak var conts_label: UILabel!
    @IBOutlet weak var more_button: UIButton!
    
    var moreAction: ()?
    
    var story: List!
    var bag = DisposeBag()
    
    override func prepareForReuse() {
        super.prepareForReuse()
        conts_label.text = nil
        clock.isHidden = true
        sentDate.text = nil
        name.text = nil
        gender.image = nil
        
        bag = DisposeBag()
    }
    
    func configCell() {
        guard let story = self.story else { return }
        
        let thumbnail_url = URL(string: story.sendMemPhoto ?? "")
        thumbnail_imageView.kf.setImage(with: thumbnail_url, placeholder: UIImage(named: "imgDefaultS"))
        thumbnail_imageView.layer.cornerRadius = thumbnail_imageView.frame.width / 2
        
        name.text = story.sendChatName
        conts_label.text = story.storyConts
        
        if story.readYn == "y" {
            conts_view.backgroundColor = UIColor(red: 238/255, green: 238/255, blue: 238/255, alpha: 1)
        } else {
            conts_view.backgroundColor = UIColor(red: 241/255, green: 238/255, blue: 255/255, alpha: 1)
        }
        
        if let sec = story.insDate.DDay {
            clock.isHidden = false
            let hours = sec / 3600
            let minutes = (sec % 3600) / 60
            if hours >= 24 {
                sentDate.text = "오래 전"
            } else if hours < 24, hours > 0{
                sentDate.text = String(format: "%2d시간 전", arguments: [hours])
            } else if hours <= 0, minutes < 1{
                sentDate.text = "방금"
            } else if hours <= 0 {
                sentDate.text = String(format: "%2d분 전", arguments: [minutes])
            }
        }
        
        gender.image = story.sendMemGender == "m" ? UIImage(named: "icoSexFm") : UIImage(named: "icoSexM")
        
        more_button.rx.tap
            .bind { _ in
                guard let moreAction = self.moreAction else {
                    return
                }
                moreAction
            }.disposed(by: bag)
    }
    
}
