//
//  JoinForm+Image.swift
//  ProjectA
//
//  Created by inforex on 2021/07/27.
//

import Foundation
import UIKit

extension JoinForm: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func setImagePicker() {
        self.imagePicker.sourceType = .photoLibrary
        self.imagePicker.allowsEditing = true
        self.imagePicker.delegate = self
        
        let profileDidTap = UITapGestureRecognizer(target: self, action: #selector(profileDidTap))
        profileImage.addGestureRecognizer(profileDidTap)
    }
    
    @objc func profileDidTap() {
        print("프로필 탭")
        guard let rootVC = App.visibleViewController() else {
            return
        }
        let actionSheet = UIAlertController(title: "프로필 사진 변경", message: "앨범에서 사진을 골라 프로필을 변경하시겠습니까?", preferredStyle: .actionSheet)
        let photoAlbum = UIAlertAction(title: "저장된 사진", style: .default) { action in
            rootVC.present(self.imagePicker, animated: true, completion: nil)
        }
        actionSheet.addAction(photoAlbum)
        actionSheet.addAction(UIAlertAction(title: "취소", style: .cancel, handler: nil))
        rootVC.present(actionSheet, animated: true, completion: nil)
        
        
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        var newImage: UIImage? = nil
        
        if let possibleImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            newImage = possibleImage
        } else if let possibleImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            newImage = possibleImage
        }
        
        self.profileImage.image = newImage
        picker.dismiss(animated: true, completion: nil)
        
    }
}
