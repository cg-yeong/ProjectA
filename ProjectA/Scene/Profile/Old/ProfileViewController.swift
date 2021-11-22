//
//  ProfileViewController.swift
//  ProjectA
//
//  Created by inforex on 2021/07/01.
//

import Foundation
import UIKit
import SwiftyJSON
import Alamofire

class ProfileViewController: UIViewController, UICollectionViewDelegate {
    // MARK: - Properties
    // MARK: @IBOutlet Properties
    // API로 결정될 데이터들
    @IBOutlet var profileView: XibView!
    @IBOutlet weak var miniProfileImage: UIImageView!       // 프로필 사진
    @IBOutlet weak var chat_nameLabel: UILabel!             // 채팅 이름
    @IBOutlet weak var countPicturesLabel: UILabel!         // 총 N개
    @IBOutlet weak var mem_ageLabel: UILabel!               // 나이
    @IBOutlet weak var mem_sexImage: UIImageView!           // 성별 기호 이미지
    @IBOutlet weak var mem_sexProfileLine: UIImageView!     // 성별에 따른 이미지 테두리 결정
    @IBOutlet weak var sexAgeView: UIView!
    @IBOutlet weak var totLikeCntLabel: UILabel!            // 총 좋아요 수
    @IBOutlet weak var chatContsView: UIView!
    @IBOutlet weak var chat_contsLabel: UILabel!            // 소개글
    
    @IBOutlet weak var l_codeLabel: UILabel!                // 위치
    @IBOutlet weak var locLabel: UILabel!                   // 지역 I or 서울
    @IBOutlet weak var bulletArrowImage: UIImageView!       // >
    @IBOutlet weak var distanceImage: UIImageView!          // 나와의 거리 이미지
    
    // hidden이나 화면레이아웃, 탭 기능에 쓸 변수들
    @IBOutlet weak var introduceView: UIView!
    @IBOutlet weak var modalView: UIView!
    
    @IBOutlet weak var pictureView: UIView!
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var pictureCollectionView: UICollectionView!
    
    @IBOutlet weak var toSendStoryButton: UIButton!
    @IBOutlet weak var toStoryListButton: UIButton!
    
    var album: [Data] = []
    // API 정보
    var userDataaaa: JSON = []
    var profilePhotoURLs = [String]()
    var setMemberInfos: MemberAndPhoto?
    var MemInfoWithList: MemInfo?
    
    // MARK: - View Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setView()
        setUserMember()
        setMemInfoWithList()
        if profilePhotoURLs.isEmpty {
            pictureView.isHidden = true
        }
        let backViewTap = UITapGestureRecognizer(target: self, action: #selector(screenDidTap))
        backView.addGestureRecognizer(backViewTap)
    }
    
    // MARK: - View, View Data Method
    
    func setView() {
        pictureCollectionView.delegate = self
        pictureCollectionView.dataSource = self
        
        modalView.clipsToBounds = true
        modalView.layer.cornerRadius = 30
        modalView.layer.maskedCorners = CACornerMask(arrayLiteral: .layerMinXMinYCorner, .layerMaxXMinYCorner)
        introduceView.layer.cornerRadius = 30
        introduceView.layer.maskedCorners = CACornerMask(arrayLiteral: .layerMinXMinYCorner, .layerMaxXMinYCorner)
        
        miniProfileImage.layer.cornerRadius = miniProfileImage.frame.size.height / 2
        miniProfileImage.clipsToBounds = true
        
    }
    
    
    
    @IBAction func showAllPictures(_ sender: Any) {
        guard let detailPictureVC = storyboard?.instantiateViewController(withIdentifier: "DetailPictureViewController") as? DetailPictureViewController else {
            return
        }
        detailPictureVC.imgURLStringArray = profilePhotoURLs
        detailPictureVC.modalTransitionStyle = .crossDissolve
        detailPictureVC.modalPresentationStyle = .overFullScreen
        self.present(detailPictureVC, animated: true, completion: nil)
    }
    
    @IBAction func toSendStoryButton(_ sender: Any) {
        self.view.isUserInteractionEnabled = false
        let sb = UIStoryboard(name: "Story", bundle: nil)
        guard let storySendVC = sb.instantiateViewController(withIdentifier: "StorySendViewController") as? StorySendViewController else {
            return
        }
        storySendVC.modalPresentationStyle = .overFullScreen
        storySendVC.bj_id = (MemInfoWithList?.email)!
        self.present(storySendVC, animated: true, completion: nil)
        self.view.isUserInteractionEnabled = true
    }
    
    @IBAction func toStoryListButton(_ sender: Any) {
        
        self.view.isUserInteractionEnabled = false
        let sb = UIStoryboard(name: "Story", bundle: nil)
        guard let storyListVC = sb.instantiateViewController(withIdentifier: "StoryListViewController") as? StoryListViewController else {
            return
        }
        storyListVC.paging()
        storyListVC.modalPresentationStyle = .overFullScreen
        self.present(storyListVC, animated: true, completion: nil)
        self.view.isUserInteractionEnabled = true
    }
    
    // MARK: - Gestures
    @objc func screenDidTap() {
        UIView.animate(withDuration: 0.5, delay: 0.1, options: .transitionCrossDissolve, animations: {
            self.backView.backgroundColor = UIColor.black.withAlphaComponent(0.64)
        }, completion: nil)
        dismiss(animated: true, completion: nil)
        
    }
    
    @objc func chatContsDidLongPress() {
        let alert = UIAlertController(title: "소개글", message: chat_contsLabel.text, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    deinit {
        print("profileVC deinit")
    }
    
}

// MARK: - Picture CollectionView Data Source
extension ProfileViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        countPicturesLabel.text = "\(profilePhotoURLs.count)"
        return profilePhotoURLs.count
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if let pictureCell = collectionView.dequeueReusableCell(withReuseIdentifier: "pictures", for: indexPath) as? PictureCell {
            pictureCell.layer.cornerRadius = 20
            if let imageURL = URL(string: profilePhotoURLs[indexPath.row]) {
                pictureCell.picture.kf.setImage(with: imageURL)
            }
            return pictureCell
        }
        
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("Cell \(indexPath.row) clicked")
        
        guard let detailCollectionVC = storyboard?.instantiateViewController(withIdentifier: "DetailCollectionViewController") as? DetailCollectionViewController else {
            return
        }
        detailCollectionVC.imgURLStringArray = profilePhotoURLs
        detailCollectionVC.previewSelectedRow = indexPath.row
        detailCollectionVC.modalTransitionStyle = .crossDissolve
        detailCollectionVC.modalPresentationStyle = .overFullScreen
        
        self.present(detailCollectionVC, animated: true, completion: nil)
        
    }
    
}
