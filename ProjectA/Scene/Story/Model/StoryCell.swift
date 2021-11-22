//
//  StoryCell.swift
//  ProjectA
//
//  Created by inforex on 2021/07/12.
//

import Foundation
import UIKit


class StoryCell: UITableViewCell {
    
    @IBOutlet weak var send_mem_photo: UIImageView!
    @IBOutlet weak var send_mem_genderImageView: UIImageView!
    @IBOutlet weak var send_chat_name: UILabel!
    @IBOutlet weak var ins_date: UILabel!
    
    @IBOutlet weak var storyContsView: UIView!
    @IBOutlet weak var story_contsLabel: UILabel!
    
    @IBOutlet weak var cellMoreButton: UIButton!
    var index: Int = 0
    var delegate: CustomCellEventDelegate?
    
    @IBAction func cellMoreButton(_ sender: Any) {
        self.delegate?.moreEventButton(index: index)
    }
}

