//
//  DetailCollectionViewController.swift
//  ProjectA
//
//  Created by inforex on 2021/07/07.
//


import UIKit

class DetailCollectionViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    // MARK: - Properties
    var previewSelectedRow = 0
    var imgURLStringArray: [String] = []
    @IBOutlet weak var detailCollection: UICollectionView!
    @IBOutlet weak var countLabel: UILabel!
    
    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(previewSelectedRow)
   
        let deviceWidth = UIScreen.main.bounds.size.width
        print("기기 너비사이즈: ", deviceWidth)
      
        countLabel.text = "\(previewSelectedRow + 1) / \(imgURLStringArray.count)"
        detailCollection.delegate = self
        detailCollection.dataSource = self
        
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
//        detailCollection.reloadData()
//        self.detailCollection.scrollToItem(at: IndexPath(row: previewSelectedRow, section: 0), at: .centeredHorizontally, animated: false)
        let rect = self.detailCollection.layoutAttributesForItem(at: IndexPath(row: previewSelectedRow, section: 0))?.frame
        self.detailCollection.scrollRectToVisible(rect!, animated: false)
        
        
        
    }

    @IBAction func backButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    
    // MARK: - CollectionView
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imgURLStringArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width = UIScreen.main.bounds.width
        let height = width
        
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
       
        if let detailCell = collectionView.dequeueReusableCell(withReuseIdentifier: "details", for: indexPath) as? DetailPictureCell {
            
            if let imgURL = URL(string: imgURLStringArray[indexPath.row]) {
                detailCell.detailImage.kf.setImage(with: imgURL)
            }
  
            return detailCell
        }
        return UICollectionViewCell()
    }
        func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
            let pageFloat = (scrollView.contentOffset.x / scrollView.frame.size.width)
            let pageInt = Int(round(pageFloat))

            countLabel.text = "\(pageInt + 1) / \(imgURLStringArray.count)"

        }
    
    deinit {
        print("collectionVC deinit")
    }
    
}

