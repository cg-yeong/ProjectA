//
//  PhotoView.swift
//  ProjectA
//
//  Created by inforex on 2021/11/18.
//

import UIKit
import SwiftyJSON
import RxCocoa
import RxSwift
import Kingfisher

class PhotoView: XibView {
    
    @IBOutlet weak var photos_imageView: UIImageView!
    @IBOutlet weak var index_label: UILabel!
    @IBOutlet weak var closeBtn: UIButton!
    
    var imageScale: CGFloat = 1.0
    let maxScale: CGFloat = 4.0
    let minScale: CGFloat = 1.0
    
    var prevSelected = 0
    var imgURLsArray: [String] = []
    
    let bag = DisposeBag()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setImage()
        bind()
    }
    
    func setImage() {
        if let imgURL = URL(string: imgURLsArray[prevSelected]) {
            self.photos_imageView.kf.setImage(with: imgURL)
        }
        index_label.text = "\(prevSelected + 1) / \(imgURLsArray.count)"
    }
    
    func bind() {
        let swipe = UISwipeGestureRecognizer()
        let zoom = UIPinchGestureRecognizer()
        
        photos_imageView.addGestureRecognizer(zoom)
        self.addGestureRecognizer(swipe)
        
        closeBtn.rx.tap
            .bind { _ in
                self.removeFromSuperview()
            }.disposed(by: bag)
        
        swipe.rx.event
            .bind { swipe in
                self.swipe(swipe)
            }.disposed(by: bag)
        
        zoom.rx.event
            .bind { sender in
                self.zoomPinch(sender)
            }.disposed(by: bag)
    }
    
    @objc func swipe(_ sender: UISwipeGestureRecognizer) {
        switch sender.direction {
        case .left:
            if prevSelected == imgURLsArray.count - 1 {
                prevSelected = imgURLsArray.startIndex
            } else {
                prevSelected -= 1
            }
            setImage()
        case .right:
            if prevSelected == imgURLsArray.startIndex {
                prevSelected = imgURLsArray.count - 1
            } else {
                prevSelected += 1
            }
            setImage()
        case .down:
            self.removeFromSuperview()
        default:
            return
        }
    }
    
    @objc func zoomPinch(_ sender: UIPinchGestureRecognizer) {
        if sender.state == .began || sender.state == .changed {
            let pinchScale: CGFloat = sender.scale
            if imageScale * pinchScale < maxScale, imageScale * pinchScale > minScale {
                imageScale *= pinchScale
                photos_imageView.transform = photos_imageView.transform.scaledBy(x: pinchScale, y: pinchScale)
            }
            sender.scale = 1.0
        }
    }
    
    deinit {
        print("사진 뷰 deinit")
    }
}
