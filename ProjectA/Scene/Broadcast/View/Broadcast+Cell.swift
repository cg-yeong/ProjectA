//
//  Broadcast+Chat.swift
//  ProjectA
//
//  Created by inforex on 2021/08/10.
//

import Foundation
import UIKit
import Kingfisher
import RxSwift
import RxCocoa

class CustomFlowLayout: UICollectionViewFlowLayout {
    
}

extension Broadcast: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout { //, UICollectionViewDataSource
    
    var ChatCell: String { return "ChatCell" }
    var SystemCell: String { return "SystemCell" }
    
    
    func setCollectionView() {
        msgCollectionView.delegate = self
//        msgCollectionView.dataSource = self
        msgCollectionView.register(UINib(nibName: ChatCell, bundle: nil), forCellWithReuseIdentifier: ChatCell)
        msgCollectionView.register(UINib(nibName: SystemCell, bundle: nil), forCellWithReuseIdentifier: SystemCell)
        
        
        let chatFlowLayout = ChatFlowLayout()
        chatFlowLayout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        chatFlowLayout.minimumLineSpacing = 4.0
        msgCollectionView.collectionViewLayout = chatFlowLayout
        msgCollectionView.contentInsetAdjustmentBehavior = .always
        
        setDatasource()
    }
    
    
    func reloadData() {
        DispatchQueue.main.async {
            self.msgCollectionView.reloadData()
            self.msgCollectionView.layoutIfNeeded()
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.frame.size.width
        switch viewModel.chats.value[indexPath.row].cmd {
        case ChatCell:
            return CGSize(width: width, height: 60)
        case SystemCell:
            return CGSize(width: width, height: 30)
        default:
            return CGSize(width: width, height: 0)
        }
    }
   
    func setDatasource() {
        
        viewModel.chats
            .bind(to: msgCollectionView.rx.items) { [weak self] (colletionView, index, item) -> UICollectionViewCell  in
                guard let self = self else { return UICollectionViewCell() }
                let indexRow = IndexPath.init(row: index, section: 0)
                colletionView.transform = CGAffineTransform(scaleX: 1, y: -1)
                
                switch item.cmd {
                case self.ChatCell:
                    guard let cell = colletionView.dequeueReusableCell(withReuseIdentifier: self.ChatCell, for: indexRow) as? ChatCell else { return UICollectionViewCell() }
                    cell.conts = item
                    cell.configCell()
                    
                    cell.contentView.transform = CGAffineTransform(scaleX: 1, y: -1)
                    return cell
                case self.SystemCell:
                    guard let sysCell = colletionView.dequeueReusableCell(withReuseIdentifier: self.SystemCell, for: indexRow) as? SystemCell else { return UICollectionViewCell() }
                    sysCell.conts = item
                    sysCell.configCell()
                    
                    sysCell.contentView.transform = CGAffineTransform(scaleX: 1, y: -1)
                    return sysCell
                default:
                    return UICollectionViewCell()
                }
                
            }
            .disposed(by: bag)
        scrollToBottom()
    }
    
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return viewModel.chats.value.count //liveChat.count
//    }
    
    
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        // 컬렉션 뷰 뒤집기
//        collectionView.transform = CGAffineTransform(scaleX: 1, y: -1)
//
//        switch viewModel.chats.value[indexPath.row].cmd {
//        case SystemCell:
//            if let sysCell = collectionView.dequeueReusableCell(withReuseIdentifier: "SystemCell", for: indexPath) as? SystemCell {
//                sysCell.message.text = viewModel.chats.value[indexPath.row].msg
//                sysCell.contentView.transform = CGAffineTransform(scaleX: 1, y: -1)
//                return sysCell
//            }
//        case ChatCell:
//            if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ChatCell", for: indexPath) as? ChatCell {
//                cell.name.text = viewModel.chats.value[indexPath.row].from?["chat_name"] as? String ?? ""
//                cell.chat.text = viewModel.chats.value[indexPath.row].msg
//
//                cell.profile.kf.setImage(with: URL(string: viewModel.chats.value[indexPath.row].from?["mem_photo"] as? String ?? ""))
//                cell.contentView.transform = CGAffineTransform(scaleX: 1, y: -1)
//                return cell
//            }
//        default:
//            break
//        }
//
//        return UICollectionViewCell()
//    }
    
    
    
}

