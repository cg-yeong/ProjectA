//
//  Broadcast+Chat.swift
//  ProjectA
//
//  Created by inforex on 2021/08/10.
//

import Foundation
import UIKit
import Kingfisher

class CustomFlowLayout: UICollectionViewFlowLayout {
    
}

extension Broadcast: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func setCollectionView() {
        msgCollectionView.delegate = self
        msgCollectionView.dataSource = self
        msgCollectionView.register(UINib(nibName: "ChatCell", bundle: nil), forCellWithReuseIdentifier: "userchat")
        msgCollectionView.register(UINib(nibName: "SystemCell", bundle: nil), forCellWithReuseIdentifier: "system")
        
//        let flowLayout = UICollectionViewFlowLayout()
//        flowLayout.minimumLineSpacing = 4.0
//        flowLayout.estimatedItemSize = CGSize(width: msgCollectionView.frame.width, height: 70)
//        msgCollectionView.collectionViewLayout = flowLayout
//        msgCollectionView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 10, right: 0)
        
        let chatFlowLayout = ChatFlowLayout()
        chatFlowLayout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        chatFlowLayout.minimumLineSpacing = 4.0
        msgCollectionView.collectionViewLayout = chatFlowLayout
        msgCollectionView.contentInsetAdjustmentBehavior = .always
        
        
    }
    
    
    func reloadData() {
        DispatchQueue.main.async {
            self.msgCollectionView.reloadData()
            self.msgCollectionView.layoutIfNeeded()
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.frame.size.width
        switch liveChat[indexPath.row].cmd {
        case "rcvChatMsg":
            return CGSize(width: width, height: 60)
        case "rcvSystemMsg":
            return CGSize(width: width, height: 30)
        default:
            return CGSize(width: width, height: 0)
        }
    }
   
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return liveChat.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        // 컬렉션 뷰 뒤집기
        collectionView.transform = CGAffineTransform(scaleX: 1, y: -1)
        switch liveChat[indexPath.row].cmd {
        case "rcvSystemMsg":
            if let sysCell = collectionView.dequeueReusableCell(withReuseIdentifier: "system", for: indexPath) as? SystemCell {
                sysCell.message.text = liveChat[indexPath.row].msg
                sysCell.contentView.transform = CGAffineTransform(scaleX: 1, y: -1)
                return sysCell
            }
        case "rcvChatMsg":
            if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "userchat", for: indexPath) as? ChatCell {
                cell.name.text = liveChat[indexPath.row].from?["chat_name"] as? String ?? ""
                cell.chat.text = liveChat[indexPath.row].msg
                
                cell.profile.kf.setImage(with: URL(string: liveChat[indexPath.row].from?["mem_photo"] as? String ?? ""))
                cell.contentView.transform = CGAffineTransform(scaleX: 1, y: -1)
                return cell
            }
        default:
            break
        }
        
        return UICollectionViewCell()
    }
    
    
    
    func scrollToBottom() {
        let offset = CGPoint(x: 0,
                             y: msgCollectionView.contentSize.height - msgCollectionView.bounds.height + msgCollectionView.contentInset.bottom)
        if offset.y > 0 {
            msgCollectionView.setContentOffset(.zero, animated: true)
        }
    }
    
}

extension Broadcast: CustomCellEventDelegate {
    func moreEventButton(index: Int) {
        print("셀에 있는 프로필 사진 클릭")
        
        RESTManager().memberREST(email: liveChat[index].from?["mem_id"] as! String) { member in
            guard let member = member else { return }
            let memInfo = member.mem_info
            
            let miniProfileSB = UIStoryboard(name: "MiniProfile", bundle: nil)
            guard let miniProfileVC = miniProfileSB.instantiateViewController(withIdentifier: "ProfileViewController") as? ProfileViewController else { return }
            
            miniProfileVC.MemInfoWithList = memInfo
            miniProfileVC.modalTransitionStyle = .crossDissolve
            miniProfileVC.modalPresentationStyle = .overFullScreen
            self.present(miniProfileVC, animated: true, completion: nil)
        }
    }
}


