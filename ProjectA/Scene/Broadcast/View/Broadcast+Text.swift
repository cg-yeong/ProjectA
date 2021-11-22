//
//  Broadcast+Text.swift
//  ProjectA
//
//  Created by inforex on 2021/08/09.
//

import Foundation
import UIKit

extension Broadcast: UITextViewDelegate {
    
    func setTextView() {
        msgTextView.delegate = self
        msgTextView.textContainer.lineFragmentPadding = 0
        msgTextView.textContainerInset = UIEdgeInsets.zero
        msgTextView.textContainer.maximumNumberOfLines = 5
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        sendButton.isHidden = true
    }
    
   
    
    @objc func keyboardWillShow(_ sender: Notification) {
        
        if let keyboardSize = (sender.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            
            if let window = UIApplication.shared.keyWindow {
                let bottomPadding = window.safeAreaInsets.bottom
                keyboardConstraint.constant = keyboardSize.size.height - bottomPadding
            } else {
                keyboardConstraint.constant = keyboardSize.size.height
            }
            sendButton.isHidden = false
            self.view.layoutIfNeeded()
            print("키보드 올리기 : \(keyboardConstraint.constant)")
            
        }
    }
    @objc func keyboardWillHide(_ sender: Notification) {
        keyboardConstraint.constant = 0
        self.view.layoutIfNeeded()
        print("키보드 내리기 : \(keyboardConstraint.constant)")
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let currentText = textView.text ?? ""
        let newLineCnt: Int = currentText.reduce(0) { $1.isNewline ? $0 + 1 : $0 }
        /* let newLineCount: Int = text.reduce(0) { $1.isNewline ? $0 + 1 : $0 }
         txtCount += newLineCount * 19
         return txtCount*/
        
        guard let strRange = Range(range, in: currentText) else { return false }
        let textAfterTrim = currentText.replacingCharacters(in: strRange, with: text)
        let textCnt = newLineCnt * 19 + textAfterTrim.count
        
        if textCnt >= 101 { //
            Toast.show("100자 이상 입력할 수 없습니다.")
        }
        if newLineCnt > 4 {
            Toast.show("5줄 이상 입력할 수 없습니다.")
        }
        if let char = text.cString(using: String.Encoding.utf8) {
            if strcmp(char, "\\b") == -92 {
                return true
            }
        }
        
        return textCnt <= 100 && newLineCnt <= 4 //textAfterTrim.count <= 100
    }
    
}
