//
//  ProfileImageCell.swift
//  ProjectA
//
//  Created by inforex on 2021/11/18.
//

import Foundation
import RxSwift
import RxCocoa

class ProfileImageCell: UICollectionViewCell {
    @IBOutlet weak var imageView: UIImageView!
    
    var bag = DisposeBag()
}
