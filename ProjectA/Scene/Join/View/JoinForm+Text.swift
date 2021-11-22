//
//  JoinForm+Text.swift
//  ProjectA
//
//  Created by inforex on 2021/07/27.
//

import Foundation
import UIKit

extension JoinForm: UITextViewDelegate, UITextFieldDelegate {
    func setTextView() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        let screenDidTapForText = UITapGestureRecognizer(target: self, action: #selector(screenDidTapForText))
        self.addGestureRecognizer(screenDidTapForText)
        
        self.introduceTextView.delegate = self
        self.nameTextField.delegate = self        
        self.introduceTextView.contentInset = UIEdgeInsets(top: 0, left: 9, bottom: 0, right: 9)
       
    }
    
    @objc func keyboardWillShow(_ sender: Notification) {
        if let keyboardSize = (sender.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
//            if introduceTextView.isFirstResponder, self.frame.origin.y == 0 {
//                self.frame.origin.y = -keyboardSize.height
//            }
            
            if introduceTextView.isFirstResponder, self.formView.bounds.origin.y == 0 {
                if let window = UIApplication.shared.keyWindow {
                    let bottomPadding = window.safeAreaInsets.bottom
                    self.formView.bounds.origin.y = keyboardSize.height - bottomPadding
                } else {
                    self.formView.bounds.origin.y = keyboardSize.height
                }
                
            }
            
        }
    }
    
    @objc func keyboardWillHide(_ sender: Notification) {
//        if self.frame.origin.y != 0 {
//            self.frame.origin.y = 0
//        }
        self.formView.bounds.origin.y = 0
    }
    
    @objc func screenDidTapForText() {
        self.endEditing(true)
    }
    
    // MARK: - 텍스트 필드
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let text = textField.text ?? ""
        guard let range = Range(range, in: text) else { return false }
        let newText = text.replacingCharacters(in: range, with: string)
        if let char = string.cString(using: String.Encoding.utf8) {
            if strcmp(char, "\\b") == -92 {
                return true
            }
        }
        
        return newText.count <= 10
    }
    
    
    // MARK: - 텍스트 뷰
    func textViewDidChange(_ textView: UITextView) {
        visiblePlaceholder(textView)
        
        countText.text = "\(countingNewLine(text: textView.text))"
    }
    func textViewDidBeginEditing(_ textView: UITextView) {
        visiblePlaceholder(textView)
    }
    func textViewDidEndEditing(_ textView: UITextView) {
        visiblePlaceholder(textView)
    }
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let currentText = textView.text ?? ""
        guard let strRange = Range(range, in: currentText) else { return false }
        let textAfterTrim = currentText.replacingCharacters(in: strRange, with: text)
        if countingNewLine(text: textAfterTrim) >= 201 {
            Toast.show("200자 이상 입력할 수 없습니다.")
        }
        return countingNewLine(text: textAfterTrim) <= 200
    }
    
    func countingNewLine(text: String) -> Int {
        var txtCount = text.count
        let newLineCount: Int = text.reduce(0) { $1.isNewline ? $0 + 1 : $0 }
        txtCount += (newLineCount * weight)
//        let numberOfChars = text.count + (newLineCount * weight) - newLineCount
        return txtCount
    }
    
    func visiblePlaceholder(_ textView: UITextView) {
        if textView.text.isEmpty {
            introducePlaceHolder.isHidden = false
        } else {
            introducePlaceHolder.isHidden = true
            setJoinButton()
        }
    }
    
}
