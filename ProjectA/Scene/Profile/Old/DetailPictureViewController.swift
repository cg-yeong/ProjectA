//
//  DetailPictureViewController.swift
//  ProjectA
//
//  Created by inforex on 2021/07/06.
//
import UIKit

class DetailPictureViewController: UIViewController {
    
    // MARK: - Properties
    
    @IBOutlet weak var detailImage: UIImageView!
    @IBOutlet weak var countPicturesLabel: UILabel!
    
    // pinchScales
    var detailImageScale: CGFloat = 1.0
    let maxScale: CGFloat = 4.0
    let minScale: CGFloat = 1.0
    
    var previewSelectedRow = 0
    var imgDataArray: [Data] = []
    var imgURLStringArray: [String] = []
    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setImage()
        
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(gesture(_:)))
        swipeLeft.direction = UISwipeGestureRecognizer.Direction.left
        self.view.addGestureRecognizer(swipeLeft)
        
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(gesture(_:)))
        swipeRight.direction = UISwipeGestureRecognizer.Direction.right
        self.view.addGestureRecognizer(swipeRight)
        
        let pinch = UIPinchGestureRecognizer(target: self, action: #selector(pinchGesture(_:)))
        self.view.addGestureRecognizer(pinch)

    }
    
    // MARK: - Method
    func setImage() {
        if let imgURL = URL(string: imgURLStringArray[previewSelectedRow]) {
            self.detailImage.kf.setImage(with: imgURL)
        }
        countPicturesLabel.text = "\(previewSelectedRow + 1) / \(imgURLStringArray.count)"
    }
    
    @IBAction func backButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: Gestures
    @objc func gesture(_ sender: UIGestureRecognizer) {
        if let swipeGesture = sender as? UISwipeGestureRecognizer {
            switch swipeGesture.direction {
            case .right:
                if previewSelectedRow == imgURLStringArray.startIndex {
                    previewSelectedRow = imgURLStringArray.count - 1
                } else {
                    previewSelectedRow -= 1
                }
                setImage()
            case .left:
                if previewSelectedRow == imgURLStringArray.count - 1 {
                    previewSelectedRow = imgURLStringArray.startIndex
                } else {
                    previewSelectedRow += 1
                }
                setImage()
            default:
                break
            }
        }
    }
    
    @objc func pinchGesture(_ sender: UIPinchGestureRecognizer) {
        if sender.state == .began || sender.state == .changed {
            let pinchScale: CGFloat = sender.scale
            if detailImageScale * pinchScale < maxScale && detailImageScale * pinchScale > minScale {
                detailImageScale *= pinchScale
                detailImage.transform = detailImage.transform.scaledBy(x: pinchScale, y: pinchScale)
            }
            sender.scale = 1.0
        }
    }
    
    
    deinit {
        print("deatilImageView deinit")
    }
}
