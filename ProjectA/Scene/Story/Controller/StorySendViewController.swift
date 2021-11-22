//
//  StorySendViewController.swift
//  ProjectA
//
//  Created by inforex on 2021/07/12.
//



import UIKit
import SwiftyJSON
import Alamofire

class StorySendViewController: UIViewController {
    
    @IBOutlet weak var inputStoryTextView: UITextView!
    @IBOutlet weak var countTextViewLabel: UILabel!
    @IBOutlet weak var sendStoryButton: UIButton!
    @IBOutlet weak var storyTextView: UIView!
    
    @IBOutlet weak var keyboardConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var modalView: UIView!
    
    var txtCount: Int = 0
    var newLineCount = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setView()
        textViewDidEndEditing(inputStoryTextView)
        let screenDidTap = UITapGestureRecognizer(target: self, action: #selector(screenDidTap))
        backView.addGestureRecognizer(screenDidTap)
    }
    
    
    func setView() {
        countTextViewLabel.text = "(0/300)"
        sendStoryButton.layer.cornerRadius = 19
        sendStoryButton.isEnabled = false
        sendStoryButton.isMultipleTouchEnabled = false
        
        storyTextView.layer.cornerRadius = 5
        storyTextView.layer.masksToBounds = true
        inputStoryTextView.delegate = self
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        modalView.layer.shadowColor = UIColor.black.cgColor
        modalView.layer.shadowOffset = .zero
        modalView.layer.shadowRadius = 10
        modalView.layer.shadowOpacity = 0.6
    }
    
    @IBAction func downButton(_ sender: Any) {
        screenDidTap()
    }
    
    // MARK: 키보드
    @objc func screenDidTap() {
        if keyboardConstraint.constant == 0 {
            dismiss(animated: true, completion: nil)
        } else {
            inputStoryTextView.resignFirstResponder()
        }
    }
    @objc func keyboardWillShow(_ sender: Notification) {
        if let keyboardSize = (sender.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {

            keyboardConstraint.constant = keyboardSize.size.height
            if let window = UIApplication.shared.keyWindow {
                let bottomPadding = window.safeAreaInsets.bottom
                self.keyboardConstraint.constant -= bottomPadding
            }
            self.view.layoutIfNeeded()
        }
        
    }
    
    @objc func keyboardWillHide(_ sender: Notification) {
        if (sender.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue != nil {
            keyboardConstraint.constant = 0
            self.view.layoutIfNeeded()
        }
        
    }
    
    @IBAction func sendStoryButton(_ sender: Any) {
        let afterTrimText = inputStoryTextView.text.trimmingCharacters(in: .whitespacesAndNewlines)
        if afterTrimText.isEmpty {
            self.view.showToast(message: ToastMessage.empty.rawValue, keyboardStatus: keyboardConstraint.constant)
        } else if txtCount < 10 {
            self.view.showToast(message: ToastMessage.notOverTen.rawValue, keyboardStatus: keyboardConstraint.constant)
            
        } else if inputStoryTextView.text != "" {
            // 이제 전송 가능
            self.view.isUserInteractionEnabled = false
            let param: [String : Any] = [
                "bj_id" : "geunyeong",
                "send_mem_gender" : "F",
                "send_chat_name" : "카리나2",
                "send_mem_photo" : "",
                "send_mem_no" : "25",
                "story_conts" : inputStoryTextView.text!
            ]
            
            sendStoryAPI(param)
        }
        
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
        print("사연 보내기 deinit")
    }
}

// MARK: - 텍스트 뷰
extension StorySendViewController: UITextViewDelegate {
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor(red: 102/255, green: 102/255, blue: 102/255, alpha: 1) {
            textView.text = nil
            textView.textColor = UIColor(red: 17/255, green: 17/255, blue: 17/255, alpha: 1)
            // (102, 102, 102): placeholder, (17, 17, 17): Text Color
        }
        sendStoryButton.isEnabled = true
        
    }
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "10자 이상 300자 이내로 작성해주세요."
            textView.textColor = UIColor(red: 102/255, green: 102/255, blue: 102/255, alpha: 1)
            sendStoryButton.isEnabled = false
        }
    }
    
    func countNewLines(text: String) -> Int {
        var txtCount = text.count
        
        let newLineCount: Int = text.reduce(0) { $1.isNewline ? $0 + 1 : $0 }
        txtCount += newLineCount * 19
        return txtCount
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let currentText = textView.text ?? ""
        guard let stringRange = Range(range, in: currentText) else { return false }

        let textAfterLimit = currentText.replacingCharacters(in: stringRange, with: text)
        if countNewLines(text: textAfterLimit) >= 301 {
            self.view.showToast(message: ToastMessage.overLimit.rawValue, keyboardStatus: keyboardConstraint.constant)
        }
        return countNewLines(text: textAfterLimit) <= 300
    }
    
    func textViewDidChange(_ textView: UITextView) {
        txtCount = countNewLines(text: textView.text)
        countTextViewLabel.text = "(\(txtCount)/300)"
        
        
        if !textView.text.isEmpty {
            self.sendStoryButton.setGradient(color1: UIColor(red: 133/255, green: 129/255, blue: 255/255, alpha: 1), color2: UIColor(red: 152/255, green: 107/255, blue: 255/255, alpha: 1))
            gradient.isHidden = false
        } else {
            gradient.isHidden = true
        }
    }// end
    
    
}

// MARK: 사연보내기 API 
extension StorySendViewController {
    func sendStoryAPI(_ parameter: Parameters) {
        let urlString: String = "https://pida83.gabia.io/api/story"
        // 전송중 체크
        Alamofire.request(URL(string: urlString)!, method: .post, parameters: parameter, encoding: JSONEncoding.prettyPrinted, headers: nil).responseJSON { [self] response in
            
            switch response.result {
            case .success(_):
                
                self.presentingViewController?.dismiss(animated: inputStoryTextView.resignFirstResponder(), completion: {
                    findRootVCAndShowToast()
                })
                
            case .failure(let error):
                print(error.localizedDescription)
                self.view.showToast(message: ToastMessage.timeOver.rawValue, keyboardStatus: keyboardConstraint.constant)
            }
            self.view.isUserInteractionEnabled = true
        } // AlamoFire END
    } // SendAPI END
    
    func findRootVCAndShowToast() {
        let presentVC = UIApplication.shared.keyWindow?.rootViewController?.presentedViewController
        if presentVC != nil {
            presentVC?.view.showToast(message: ToastMessage.success.rawValue, keyboardStatus: keyboardConstraint.constant)
        }
    }
    
}


// MARK: 그라데이션..
let gradient: CAGradientLayer = CAGradientLayer()
extension UIView {
    func setGradient(color1: UIColor, color2: UIColor) {
        gradient.colors = [color1.cgColor, color2.cgColor]
        gradient.locations = [0.0, 1.0]
        gradient.startPoint = CGPoint(x: 0.0, y: 0.5)
        gradient.endPoint = CGPoint(x: 1.0, y: 0.5)
        gradient.frame = bounds
        layer.insertSublayer(gradient, at: 0)
        layer.masksToBounds = true
        self.layoutIfNeeded()
        
    }
    // MARK: 토스트 메세지
    func showToast(message: String, keyboardStatus: CGFloat) {
        let toastLabel = UILabel(frame: CGRect(x: self.frame.size.width / 2 - 75, y: self.frame.size.height - 120, width: 200, height: 30))
        toastLabel.center.x = self.center.x
        if keyboardStatus != 0 || message == ToastMessage.success.rawValue || message == ToastMessage.timeOver.rawValue {
            toastLabel.center.y = self.center.y
        }
        toastLabel.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        toastLabel.textColor = UIColor.white
        toastLabel.font = UIFont.systemFont(ofSize: 14.0)
        toastLabel.textAlignment = .center
        toastLabel.text = message
        toastLabel.alpha = 1.0
        toastLabel.layer.cornerRadius = 10;
        toastLabel.clipsToBounds = true
        self.addSubview(toastLabel)
        UIView.animate(withDuration: 5.0, delay: 0.1, options: .curveEaseOut) {
            toastLabel.alpha = 0.0
        } completion: { (isCompleted) in
            toastLabel.removeFromSuperview()
        }
    }
}

