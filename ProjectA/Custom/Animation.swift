//
//  Lottie.swift
//  ProjectA
//
//  Created by inforex on 2021/08/12.
//

import Foundation
import UIKit
import Lottie
import SDWebImageWebPCoder

class LottieAnime {
    
    func heartAnimation() {
        
        // webp
        var alterHearts: [String] = []
        //alterHearts = ["an_like_01","an_like_02","an_like_03","an_like_04","an_like_05","an_like_01","an_like_02"]
        
        guard let vc = App.visibleViewController() as? Broadcast else { return }
        
        (0...6).forEach { (i) in
            alterHearts.append("an_like_0\(Int.random(in: 1 ... 5))")
            let heartImgNm = alterHearts[i]
            
            guard let path = Bundle.main.path(forResource: heartImgNm, ofType: "webp") else {
                return
            }
            print(path)
            let heartImgView = UIImageView(image: UIImage(contentsOfFile: path))
//            let heartImgView = UIImageView()
//            heartImgView.sd_setImage(with: URL(string: path))
            heartImgView.alpha = 0
            
            let totalDuration = Double(CGFloat.random(in: 5.5 ... 6.0))
            let oX = 0 + CGFloat.random(in: 0 ... 60)
            let oY = vc.view.frame.maxY - CGFloat.random(in: 0 ... 80)
            
            let shakeXWeight = CGFloat.random(in: 0 ... 75)
            var cX: CGFloat { // shake: left or right
                return arc4random() % 2 == 0 ? shakeXWeight : -shakeXWeight
            }
            
            var size: CGFloat = 50
            
            heartImgView.frame = CGRect(x: oX, y: oY, width: size, height: size)
            // x, y, size, size
            vc.view.addSubview(heartImgView)
            
            UIView.animateKeyframes(withDuration: totalDuration, delay: drand48(), options: .calculationModePaced) {
                
                // a
                var eY = oY - CGFloat.random(in: 100 ... 150)
                UIView.addKeyframe(withRelativeStartTime: 0,
                                   relativeDuration: totalDuration * 0.15) {
                    
                    heartImgView.frame = CGRect(x: oX + cX, y: eY, width: size, height: size)
                    heartImgView.alpha = 1
                    
                }
                
                // b
                eY = oY - CGFloat.random(in: 250 ... 300)
                size += CGFloat(Int.random(in: 20 ... 30))
                UIView.addKeyframe(withRelativeStartTime: totalDuration * 0.15,
                                   relativeDuration: totalDuration * 0.55) {
                    
                    heartImgView.frame = CGRect(x: oX + cX, y: eY, width: size, height: size)
                    
                }
                
                // c
                eY = CGFloat(Int.random(in: 0 ... 80))
                size += 20
                UIView.addKeyframe(withRelativeStartTime: totalDuration * 0.7, relativeDuration: totalDuration * 0.3) {
                    heartImgView.frame = CGRect(x: oX + cX, y: eY, width: size, height: size)
                    heartImgView.alpha = 0
                    
                }
                
            } completion: { finished in
                if finished { heartImgView.removeFromSuperview() }
            }

        }
        
    }
   
}




