//
//  ProfileView.swift
//  ProjectA
//
//  Created by inforex on 2021/11/18.
//

import UIKit
import SwiftyJSON
import RxSwift
import RxCocoa
import Kingfisher

class ProfileView: XibView {
    
    @IBOutlet weak var another_view: UIView!
    
    @IBOutlet weak var like_view: UIView!
    @IBOutlet weak var distance_view: UIView!
    @IBOutlet weak var distanceBar_view: UIView!
    @IBOutlet weak var distance_imageView: UIImageView!
    
    @IBOutlet weak var sex_view: UIView!
    @IBOutlet weak var profile_view: UIView!
    @IBOutlet weak var profileFrame_imageView: UIImageView!
    @IBOutlet weak var profile_imageView: UIImageView!
    
    
    @IBOutlet weak var nickName_label: UILabel!
    @IBOutlet weak var sex_imageView: UIImageView!
    @IBOutlet weak var age_label: UILabel!
    @IBOutlet weak var like_label: UILabel!
    @IBOutlet weak var distance_label: UILabel!
    @IBOutlet weak var introduction_label: UILabel!
    
    @IBOutlet weak var total_label: UILabel!
    @IBOutlet weak var totalImage_view: UIView!
    
    @IBOutlet weak var list_button: UIButton!
    @IBOutlet weak var send_button: UIButton!
    
    @IBOutlet weak var photo_view: UIView!
    @IBOutlet weak var collectionView: UICollectionView!
    
    var apiData: JSON!
    var memInfo: MemInfo?
    var photoURLs = [String]()
    
    
    let bag = DisposeBag()
    
//    var isfavor = false
    
    override func layoutSubviews() {
        super.layoutSubviews()
        if initCheck {
            initialize()
            animateUp()
            initCheck = false
        }
    }
    
    override func removeFromSuperview() {
        UIView.animate(withDuration: 0.5) {
            self.frame.origin.y = self.bounds.height
        } completion: { _ in
            super.removeFromSuperview()
        }
    }
    
    func initialize() {
        setView()
        bind()
    }
    
    func setView() {
        if photoURLs.isEmpty {
            photo_view.isHidden = true
        }
        
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        collectionView.register(UINib(nibName: "ProfileImageCell", bundle: nil), forCellWithReuseIdentifier: "ProfileImageCell")
        
        like_view.layer.borderWidth = 1
        like_view.layer.borderColor = UIColor(red: 255/255, green: 228/255, blue: 228/255, alpha: 1).cgColor
        profile_imageView.layer.cornerRadius = profile_imageView.frame.size.height / 2
        
        guard let memInfo = memInfo else {
            return
        }
        
        sex_view.borderWidth = 1
        if memInfo.gender == "m" || memInfo.gender == "M" {
            sex_imageView.image = UIImage(named: "icoSexM")
            profileFrame_imageView.image = UIImage(named: "imgProfileLineM")
            sex_view.borderColor = UIColor(red: 200/255, green: 211/255, blue: 249/255, alpha: 1)
            age_label.textColor = UIColor(red: 93/255, green: 126/255, blue: 232/255, alpha: 1)
        } else if memInfo.gender == "f" || memInfo.gender == "F" {
            sex_imageView.image = UIImage(named: "icoSexFm")
            profileFrame_imageView.image = UIImage(named: "imgProfileLineFm")
            sex_view.borderColor = UIColor(red: 251/255, green: 194/255, blue: 206/255, alpha: 1)
            age_label.textColor = UIColor(red: 1, green: 84/255, blue: 119/255, alpha: 1)
        }
        
        guard let photoInfo = self.memInfo?.profile_image else { return }
        let defPhotoURL = URL(string: photoInfo)
        DispatchQueue.main.async {
            self.profile_imageView.kf.setImage(with: defPhotoURL)
        }
        
        nickName_label.text = memInfo.name
        introduction_label.text = memInfo.contents
        age_label.text = memInfo.age
        
    }
    
    func bind() {
        
        let other_tap = UITapGestureRecognizer()
        let totalImage_tap = UITapGestureRecognizer()
        
        another_view.addGestureRecognizer(other_tap)
        totalImage_view.addGestureRecognizer(totalImage_tap)
        
        other_tap.rx.event
            .throttle(.seconds(1), scheduler: MainScheduler.instance)
            .bind { (_) in
                self.removeFromSuperview()
            }.disposed(by: bag)
        
        totalImage_tap.rx.event
            .bind { (_) in
                guard !self.photoURLs.isEmpty else { return }
                
                guard let vc = App.visibleViewController() else { return }
                let photoView = PhotoView()
                photoView.frame = vc.view.bounds
//                photoView.prevSelected = 0
//                photoView.imgURLsArray =
                self.addSubview(photoView)
            }.disposed(by: bag)
        
        send_button.rx.tap
            .bind { (_) in
                guard let vc = App.visibleViewController() else { return }
                let sb = UIStoryboard(name: "Story", bundle: nil)
                guard let storySendVC = sb.instantiateViewController(withIdentifier: "StorySendViewController") as? StorySendViewController else {
                    return
                }
                storySendVC.modalPresentationStyle = .overFullScreen
                vc.present(storySendVC, animated: true, completion: nil)
            }.disposed(by: bag)
        
        list_button.rx.tap
            .bind { _ in
                let sendView = StorySendView()
                sendView.frame = self.bounds
                if let memInfo = self.memInfo {
                    sendView.viewData = JSON(memInfo)
                }
                self.addSubview(sendView)
            }.disposed(by: bag)
    }
}

extension ProfileView: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProfileImageCell", for: indexPath) as? ProfileImageCell {
            
            return cell
        }
        
        return UICollectionViewCell()
    }
    
}
