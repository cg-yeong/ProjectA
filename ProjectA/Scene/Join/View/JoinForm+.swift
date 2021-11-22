//
//  JoinForm+.swift
//  ProjectA
//
//  Created by inforex on 2021/07/28.
//

import Foundation
import UIKit
import Alamofire

extension JoinForm {
    
    @IBAction func genderButton(_ sender: UIButton) {
        if indexOfOneAndOnly != nil {
            if !sender.isSelected { // newButton Selected!
                for index in genderRadioButton.indices {
                    genderRadioButton[index].isSelected = false
                }
                sender.isSelected = true
                indexOfOneAndOnly = genderRadioButton.firstIndex(of: sender)
            } else {
                sender.isSelected = false // true -> false
                indexOfOneAndOnly = nil
            }
        } else {
            sender.isSelected = true
            indexOfOneAndOnly = genderRadioButton.firstIndex(of: sender)
        }
        setRadioColor()
        print("isMan : \(String(describing: isMan))")
    }
    
    @IBAction func quitButton(_ sender: Any) {
        
        guard let vc = App.visibleViewController() else { return }
        let quit = UIAlertController(title: "뒤로가기", message: "회원가입을 취소하시겠습니까?", preferredStyle: .alert)
        let yes = UIAlertAction(title: "예", style: .default) { action in
            super.removeFromSuperview()
        }
        let no = UIAlertAction(title: "아니오", style: .cancel, handler: nil)
        quit.addAction(yes)
        quit.addAction(no)
        vc.present(quit, animated: true, completion: nil)
        
    }
    
    @IBAction func joinButton(_ sender: Any) {// socialEmail
        
        let name = nameTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        
        let imgData = self.profileImage.image?.pngData()
        let age: String = "\(birthYear.text!.yearGap!)"
        let contents = introduceTextView.text.trimmingCharacters(in: .whitespaces)
        guard name.count >= 2, indexOfOneAndOnly != nil, validateBirth() else {
            if name.count < 2 {
                Toast.show("이름을 2자 이상 10자 이하로 적어주세요.")
            } else if indexOfOneAndOnly == nil {
                Toast.show("성별을 선택해 주세요.")
            } else {
                Toast.show("생년월일을 선택해주세요.")
            }
            return
        }
        
        let gender = isMan! ? "m" : "f"
        
        let user = User(email: SocialEmail.shared.email!,
                        name: name,
                        profileImg: imgData,
                        age: age,
                        contents: contents,
                        gender: gender)
        print(user)
        memberRegister(with: user)
        
        
    }
    // -> 클래스화 하자
    func memberRegister(with model: User) {
        // joinButton에서 호출
        
        let path = "https://babyhoney.kr/api/member"
        let headers: HTTPHeaders = [
            "Content-Type" : "multipart/form-data"
        ]
        AF.upload(multipartFormData: { multipartFormData in
            multipartFormData.append(Data(model.email.utf8), withName: "email")
            multipartFormData.append(Data(model.name.utf8), withName: "name")
            multipartFormData.append(model.profileImg ?? .empty, withName: "profile_img", fileName: "name.png", mimeType: "image/webp")
            multipartFormData.append(Data(model.age.utf8), withName: "age")
            multipartFormData.append(Data(model.contents.utf8), withName: "contents")
            multipartFormData.append(Data(model.gender.utf8), withName: "gender")
        }, to: path, headers: headers).responseData { response in
            switch response.result {
            case .success(let data):
                print("딩",data)
                do {
                    let res = try JSONDecoder().decode(Register.self, from: data)
                    print("동 : \(res), \(res.email)")
                    if res.redirect_url != nil {
                        SocialEmail.shared.email = res.email
                        SocialEmail.shared.gender = res.gender
                        SocialEmail.shared.name = res.name
                        SocialEmail.shared.profile = res.profile_url
                        guard let vc = App.visibleViewController() as? ViewController else { return }
                        //vc.home = "https://pida83.gabia.io/member/list/\(res.email)"
                        // 사연 보내기 다른 데이터
                        guard let url = URL(string: "https://pida83.gabia.io/member/list/\(SocialEmail.shared.email!)") else {
                            return
                        }
                        var req = URLRequest(url: url)
                        req.timeoutInterval = 2.0
                        vc.wkWebView.load(req)
                    }
                    self.removeFromSuperview()
                    
                } catch {
                    print("댕: 중복 이메일!",error.localizedDescription)
                }
            case .failure(let error):
                print("땡!",error.localizedDescription)
            }
            
        }
    }
}

