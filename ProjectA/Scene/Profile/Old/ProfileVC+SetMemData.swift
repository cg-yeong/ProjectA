//
//  ProfileVC+SetMemData.swift
//  ProjectA
//
//  Created by inforex on 2021/07/21.
//

import Foundation
import UIKit
import Kingfisher

extension ProfileViewController {
    // MARK: 사용자 정보 세팅
    func setUserMember() {
        if let setMemberInfo = setMemberInfos?.member {
            if setMemberInfo.distance == 0 {
                distanceImage.isHidden = true
                locLabel.text = setMemberInfo.loc
                bulletArrowImage.isHidden = false
                l_codeLabel.text = setMemberInfo.l_code
            } else {
                distanceImage.isHidden = false
                locLabel.text = "I"
                bulletArrowImage.isHidden = true
                l_codeLabel.text = setMemberInfo.l_code
            }
            
            if setMemberInfo.mem_sex == "m" {
                mem_sexImage.image = UIImage(named: "icoSexM")
                mem_sexProfileLine.image = UIImage(named: "imgProfileLineM")
                sexAgeView.borderColor = UIColor(red: 200/255, green: 211/255, blue: 249/255, alpha: 1)
                mem_ageLabel.textColor = UIColor(red: 93/255, green: 126/255, blue: 232/255, alpha: 1)
                
                toStoryListButton.isHidden = false
                toSendStoryButton.isHidden = true
            } else if setMemberInfo.mem_sex == "f" {
                mem_sexImage.image = UIImage(named: "icoSexFm")
                mem_sexProfileLine.image = UIImage(named: "imgProfileLineFm")
                sexAgeView.borderColor = UIColor(red: 251/255, green: 194/255, blue: 206/255, alpha: 1)
                mem_ageLabel.textColor = UIColor(red: 255/255, green: 84/255, blue: 119/255, alpha: 1)
                
                toStoryListButton.isHidden = true
                toSendStoryButton.isHidden = false
            }
            
            chat_nameLabel.text = setMemberInfo.chat_name
            chat_contsLabel.text = setMemberInfo.chat_conts
            mem_ageLabel.text = setMemberInfo.mem_age
            totLikeCntLabel.text = setMemberInfo.totLikeCnt
            
            
        }
        if let setPhotoInfo = setMemberInfos?.photo {
            if let defPhotoUrl = URL(string: setPhotoInfo.defPhoto) {
                
                DispatchQueue.main.async {
                    self.miniProfileImage.kf.setImage(with: defPhotoUrl)
                }
                
            }
        }
        
        if chat_contsLabel.countLabelLines() > 2 {
            print("몇줄? \(chat_contsLabel.countLabelLines())")
            let chatContsLongPress = UILongPressGestureRecognizer(target: self, action: #selector(chatContsDidLongPress))
            chatContsView.addGestureRecognizer(chatContsLongPress)
        } else {
            print("아직 2줄 이하")
        }
        
    }
    
    func setMemInfoWithList() {
        locLabel.isHidden = true
        
        chat_nameLabel.text = MemInfoWithList?.name
        chat_contsLabel.text = MemInfoWithList?.contents
        mem_ageLabel.text = MemInfoWithList?.age
        if MemInfoWithList?.gender == "m" || MemInfoWithList?.gender == "M" {
            mem_sexImage.image = UIImage(named: "icoSexM")
            mem_sexProfileLine.image = UIImage(named: "imgProfileLineM")
            sexAgeView.borderColor = UIColor(red: 200/255, green: 211/255, blue: 249/255, alpha: 1)
            mem_ageLabel.textColor = UIColor(red: 93/255, green: 126/255, blue: 232/255, alpha: 1)
        } else if MemInfoWithList?.gender == "f" || MemInfoWithList?.gender == "F" {
            mem_sexImage.image = UIImage(named: "icoSexFm")
            mem_sexProfileLine.image = UIImage(named: "imgProfileLineFm")
            sexAgeView.borderColor = UIColor(red: 251/255, green: 194/255, blue: 206/255, alpha: 1)
            mem_ageLabel.textColor = UIColor(red: 255/255, green: 84/255, blue: 119/255, alpha: 1)
        }
        if SocialEmail.shared.email == MemInfoWithList?.email {
            toStoryListButton.isHidden = false
            toSendStoryButton.isHidden = true
        } else {
            toStoryListButton.isHidden = true
            toSendStoryButton.isHidden = false
        }
        DispatchQueue.main.async {
            if let setPhotoInfo = self.MemInfoWithList?.profile_image {
                if let defPhotoURL = URL(string: setPhotoInfo) {
                    self.miniProfileImage.kf.setImage(with: defPhotoURL)
                }
            }
        }
    }
}
