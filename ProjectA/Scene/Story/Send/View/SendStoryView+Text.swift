//
//  SendStoryView+Text.swift
//  ProjectA
//
//  Created by inforex on 2021/11/24.
//

import UIKit

extension StorySendView: UITextViewDelegate {
    
    func setTextView() {
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        conts_textView.delegate = self
        self.conts_textView.contentInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        self.placeholder_label.isHidden = false
    }
    
    @objc func keyboardWillShow(_ sender: Notification) {
        viewModel.editing(true)
        if let keyboardSize = (sender.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            self.keyboardConst.constant = keyboardSize.size.height
            if let bottomPaddi = UIApplication.shared.windows.first?.safeAreaInsets.bottom {
                self.keyboardConst.constant -= bottomPaddi
            }
            self.layoutIfNeeded()
        }
    }
    
    @objc func keyboardWillHide(_ sender: Notification) {
        viewModel.editing(false)
        if (sender.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue != nil {
            self.keyboardConst.constant = 0
            self.layoutIfNeeded()
        }
    }
    
}
