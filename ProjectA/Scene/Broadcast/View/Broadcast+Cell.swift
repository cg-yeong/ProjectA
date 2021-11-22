//
//  Broadcast+Chat.swift
//  ProjectA
//
//  Created by inforex on 2021/08/10.
//

import Foundation
import UIKit

extension Broadcast: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func setCollectionView() {
        msgCollectionView.delegate = self
        msgCollectionView.dataSource = self
        msgCollectionView.register(UINib(nibName: "Message", bundle: nil), forCellWithReuseIdentifier: "msg")
        msgCollectionView.register(UINib(nibName: "SystemMessage", bundle: nil), forCellWithReuseIdentifier: "sysMsg")

    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return liveChat.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        // 컬렉션 뷰 뒤집기
        collectionView.transform = CGAffineTransform(scaleX: 1, y: -1)
        let broadChat = liveChat[indexPath.row]
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "msg", for: indexPath) as? Message, broadChat.cmd == "rcvChatMsg" {
            
            cell.delegate = self
            cell.idx = indexPath.row
            cell.chatName.text = broadChat.from?["chat_name"] as? String
            cell.chatContents.text = broadChat.msg!
            cell.chatProfile.kf.setImage(with: URL(string: broadChat.from?["mem_photo"] as! String))
            
            cell.contentView.transform = CGAffineTransform(scaleX: 1, y: -1)
            return cell
        }
        if let sysCell = collectionView.dequeueReusableCell(withReuseIdentifier: "sysMsg", for: indexPath) as? SystemMessage, broadChat.cmd == "rcvSystemMsg" {
            sysCell.clipsToBounds = true
            sysCell.layer.cornerRadius = 4
            
            sysCell.sysMsg.text = broadChat.msg
            
            sysCell.contentView.transform = CGAffineTransform(scaleX: 1, y: -1)
            return sysCell
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

