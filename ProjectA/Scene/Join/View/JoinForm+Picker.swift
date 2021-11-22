//
//  JoinForm+Picker.swift
//  ProjectA
//
//  Created by inforex on 2021/07/27.
//

import Foundation
import UIKit

extension JoinForm: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func createPicker() {
        let picker = UIPickerView()
        picker.delegate = self
        picker.dataSource = self
        birthYear.inputView = picker
        birthMonth.inputView = picker
        birthDay.inputView = picker
        
        createToolBar()
    }
    
    func createToolBar() {
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        toolBar.isTranslucent = true
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(pickerDone))
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        toolBar.setItems([flexibleSpace, doneButton], animated: false)
        birthDay.inputAccessoryView = toolBar
        birthYear.inputAccessoryView = toolBar
        birthMonth.inputAccessoryView = toolBar
    }
    @objc func pickerDone() {
        self.endEditing(true)
    }
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        // 행 수 결정
        if birthYear.isFirstResponder {
            return 80 // +++
        } else if birthMonth.isFirstResponder {
            return 12
        } else {
            return 31
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if birthYear.isFirstResponder {
            return "\(1942 + row)"
        } else {
            return "\(row + 1)"
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        pickerView.reloadInputViews()
        if birthYear.isFirstResponder {
            birthYear.text = "\(1942 + row)"
        } else if birthMonth.isFirstResponder {
            birthMonth.text = "\(row + 1)"
        } else {
            birthDay.text = "\(row + 1)"
        }
    }
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 50.0
    }
    
    
    func validateBirth() -> Bool {
        guard birthDay.text! != "", birthMonth.text! != "" else {
            return false
        }
        
        return true
    }
}
