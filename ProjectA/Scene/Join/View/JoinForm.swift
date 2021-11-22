//
//  JoinForm.swift
//  ProjectA
//
//  Created by inforex on 2021/07/26.
//

import Foundation
import UIKit

class JoinForm: XibView {
    
    @IBOutlet weak var formView: UIView!
    
    @IBOutlet weak var profileImageLine: UIView!
    @IBOutlet weak var nameLine: UIView!
    @IBOutlet weak var defaultImageView: UIView!
    @IBOutlet weak var profileImage: UIImageView!
    
    @IBOutlet weak var nameTextField: UITextField!
    
    @IBOutlet weak var maleButton: UIButton!
    @IBOutlet weak var femaleButton: UIButton!
    @IBOutlet var genderRadioButton: [UIButton]!
    
    @IBOutlet weak var birthYear: CustomUITextField!
    @IBOutlet weak var birthMonth: CustomUITextField!
    @IBOutlet weak var birthDay: CustomUITextField!
    
    @IBOutlet weak var introduceTextView: UITextView!
    @IBOutlet weak var introducePlaceHolder: UILabel!
    
    @IBOutlet weak var joinButton: UIButton!
    @IBOutlet weak var countText: UILabel!
    
    
    let weight = 19
    var isMan: Bool?
    var indexOfOneAndOnly: Int? = nil {
        didSet {
            if indexOfOneAndOnly == nil {
                isMan = nil
            } else if indexOfOneAndOnly == 1 {
                isMan = true
            } else {
                isMan = false
            }
        }
    }
    static var formViewOriginY = CGFloat(0)
    let joinButtonGradient: CAGradientLayer = CAGradientLayer()
    let imagePicker = UIImagePickerController()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if initCheck {
            initialize()
        }
        joinButtonGradient.frame = UIScreen.main.bounds
        
    }
    override func removeFromSuperview() {
        super.removeFromSuperview()
    }
    func initialize() {
        setLayout()
        setTextView()
        setImagePicker()
        createPicker()
    }
    
    
    func setLayout() {
        setJoinButton()
        
        let lineColor: UIColor = UIColor(red: 223/255, green: 223/255, blue: 223/255, alpha: 1)
        
        profileImageLine?.borderWidth = 1
        profileImageLine?.borderColor = lineColor
        profileImageLine?.cornerRadius = 10
        
        nameLine?.borderWidth = 1
        nameLine?.borderColor = lineColor
        nameLine?.cornerRadius = 5
        
        maleButton?.borderColor = lineColor
        maleButton?.borderWidth = 1
        femaleButton?.borderColor = lineColor
        femaleButton?.borderWidth = 1
        
        introduceTextView?.borderColor = lineColor
        introduceTextView?.borderWidth = 1
        
        joinButton?.cornerRadius = 25
    }
    
    func setJoinButton() {
        joinButtonGradient.frame = UIScreen.main.bounds
        joinButtonGradient.colors = [
            UIColor(red: 133/255, green: 129/255, blue: 255/255, alpha: 1).cgColor,
            UIColor(red: 152/255, green: 107/255, blue: 255/255, alpha: 1).cgColor
        ]
        joinButtonGradient.startPoint = CGPoint(x: 0, y: 0.5)
        joinButtonGradient.endPoint = CGPoint(x: 1, y: 0.5)
        joinButtonGradient.locations = [0, 1]
        joinButton.layer.cornerRadius = 25
        joinButton.layer.masksToBounds = true
        joinButton.layer.insertSublayer(joinButtonGradient, at: 0)
        
    }
    
    func setRadioColor() {
        for btn in genderRadioButton {
            if btn.isSelected == true {
                btn.backgroundColor = UIColor(red: 255/255, green: 230/255, blue: 240/255, alpha: 1)
                btn.borderColor = UIColor(red: 255/255, green: 152/255, blue: 193/255, alpha: 1)
            } else {
                btn.backgroundColor = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1)
                btn.borderColor = UIColor(red: 223/255, green: 223/255, blue: 223/255, alpha: 1)
            }
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
        print("회원가입 deinit")
    }
}


