//
//  Lottie.swift
//  ProjectA
//
//  Created by inforex on 2021/08/12.
//

import Foundation
import UIKit
import Lottie

class LottieAnime {
    
    
    
    func setLikeAnimation() {
        let aniView = AnimationView(name: "ani_live_like_full")
        guard let vc = App.visibleViewController() as? Broadcast else {
            return
        }
        aniView.center = vc.view.center
        aniView.contentMode = .scaleAspectFit
        aniView.frame = vc.likeButton.bounds
        aniView.play(fromProgress: aniView.currentProgress, toProgress: 1, loopMode: .playOnce) { (f) in
            //aniView.loopMode = .loop
            if f {
                aniView.removeFromSuperview()
//                aniView.stop()
            }
        }
        vc.likeButton.clipsToBounds = false
        vc.likeButton.addSubview(aniView)
        
    }
    
    
    func heartAnimation() {
        let alterHearts = ["an_like01","an_like02","an_like03","an_like04","an_like05","an_like01","an_like02"]
        guard let vc = App.visibleViewController() as? Broadcast else { return }
       
        (0...6).forEach { (i) in
            let heartImgNm = alterHearts[i]
            let heartImgView = UIImageView(image: UIImage(named: heartImgNm))
            heartImgView.alpha = 0
            let totalDuration = Double(CGFloat.random(in: 5.5 ... 6.0))
            let oX = 0 + CGFloat.random(in: 0...60)
            let oY = vc.view.frame.maxY - CGFloat.random(in: 0...80)
            
            let shakeXWeight = CGFloat.random(in: 0...75)
            var cX: CGFloat {
                return arc4random() % 2 == 0 ? 0 + shakeXWeight : 0 - shakeXWeight
            }
            
            var size: CGFloat = 50
            
            heartImgView.frame = CGRect(x: oX, y: oY, width: size, height: size)
            // x, y, size, size
            vc.view.addSubview(heartImgView)
            
            UIView.animateKeyframes(withDuration: totalDuration, delay: drand48(), options: .calculationModePaced) {
                //let eX = oX + cX
                var eY = oY - CGFloat.random(in: 100...150)
                // a
                UIView.addKeyframe(withRelativeStartTime: 0,
                                   relativeDuration: totalDuration * 0.15) {
                    
                    heartImgView.frame = CGRect(x: oX + cX, y: eY, width: size, height: size)
                    heartImgView.alpha = 1
                    print("1차 x좌표 : \(oX + cX)")
                    
                }
                
                // b
                eY = oY - CGFloat.random(in: 250 ... 300)
                size += CGFloat(Int.random(in: 20 ... 30))
                UIView.addKeyframe(withRelativeStartTime: totalDuration * 0.15,
                                   relativeDuration: totalDuration * 0.55) {
                    
                    heartImgView.frame = CGRect(x: oX + cX, y: eY, width: size, height: size)
                    print("2차 x좌표 : \(oX + cX)")
                }
                
                // c
                eY = CGFloat(Int.random(in: 0...80))
                size += 20
                UIView.addKeyframe(withRelativeStartTime: totalDuration * 0.7, relativeDuration: totalDuration * 0.3) {
                    heartImgView.frame = CGRect(x: oX + cX, y: eY, width: size, height: size)
                    heartImgView.alpha = 0
                    print("3차 x좌표 : \(oX + cX)")
                }
                
                
            } completion: { f in
                if f { heartImgView.removeFromSuperview() }
            }

        }
        
    }
   
}




