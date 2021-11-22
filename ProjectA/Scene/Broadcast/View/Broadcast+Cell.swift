//
//  Broadcast+Chat.swift
//  ProjectA
//
//  Created by inforex on 2021/08/10.
//

import Foundation
import UIKit

class CustomFlowLayout: UICollectionViewFlowLayout {
    
}

extension Broadcast: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func setCollectionView() {
        msgCollectionView.delegate = self
        msgCollectionView.dataSource = self
        msgCollectionView.register(UINib(nibName: "ChatCell", bundle: nil), forCellWithReuseIdentifier: "userchat")
        msgCollectionView.register(UINib(nibName: "SystemCell", bundle: nil), forCellWithReuseIdentifier: "system")
//        msgCollectionView.register(UINib(nibName: "Message", bundle: nil), forCellWithReuseIdentifier: "msg")
//        msgCollectionView.register(UINib(nibName: "SystemMessage", bundle: nil), forCellWithReuseIdentifier: "sysMsg")
        
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.minimumLineSpacing = 4.0
        flowLayout.estimatedItemSize = CGSize(width: msgCollectionView.frame.width, height: 70)
        msgCollectionView.collectionViewLayout = flowLayout
        msgCollectionView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 10, right: 0)
        
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.frame.size.width
        switch liveChat[indexPath.row].cmd {
        case "rcvChatMsg":
            return CGSize(width: width, height: 70)
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
        let broadChat = liveChat[indexPath.row]
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "userchat", for: indexPath) as? ChatCell, broadChat.cmd == "rcvChatMsg" {
            cell.frame.size.width = msgCollectionView.bounds.width
            cell.name.text = broadChat.from?["chat_name"] as? String
            cell.chat.text = broadChat.msg!
            
            cell.contentView.transform = CGAffineTransform(scaleX: 1, y: -1)
            return cell
        }
        if let sysCell = collectionView.dequeueReusableCell(withReuseIdentifier: "system", for: indexPath) as? SystemCell, broadChat.cmd == "rcvSystemMsg" {
            
            sysCell.message.text = broadChat.msg
            
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

