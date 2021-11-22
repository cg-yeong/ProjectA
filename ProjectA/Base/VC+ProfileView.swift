//
//  ViewController+.swift
//  ProjectA
//
//  Created by inforex on 2021/07/22.
//

import UIKit
import SwiftyJSON
import Alamofire

extension ViewController {
    
    @IBAction func showFMiniProfile(_ sender: Any) {
        let _: Parameters = ["cmd": "getProfile", "gender": "F", "id": "geunyeong"]
        //loadProfileAPI(param: parameter)
    }
    @IBAction func showMMiniProfile(_ sender: Any) {
        let _: Parameters = ["cmd": "getProfile", "gender": "M", "id": "geunyeong"]
        //loadProfileAPI(param: parameter)
        
    }
    
    func presentMiniProfile() {
        let miniProfileSB = UIStoryboard(name: "MiniProfile", bundle: nil)
        guard let miniProfileVC = miniProfileSB.instantiateViewController(withIdentifier: "ProfileViewController") as? ProfileViewController else {
            return
        }
        miniProfileVC.profilePhotoURLs = photoURLs
        miniProfileVC.setMemberInfos = setInfo
        miniProfileVC.modalPresentationStyle = .overFullScreen
        self.present(miniProfileVC, animated: true)
        
        self.view.isUserInteractionEnabled = true
    }
    
    func loadProfileAPI(param: String) {
        self.view.isUserInteractionEnabled = false
        let urlString: String = "https://pida83.gabia.io/member/list/\(param)"
        let header: HTTPHeaders = [
            "Content-Type" : "application/json; charset=utf-8",
            "Accept" : "application/json"
        ]
        
        AF.request(URL(string: urlString)!, method: .post, parameters: nil, encoding: JSONEncoding.prettyPrinted, headers: header).responseData { response in
            switch response.result {
            case .success(let data):
                let decoder = JSONDecoder()
                do {
                    let profileJSON = try decoder.decode(profileAPI.self, from: data)
                    self.photoURLs = profileJSON.result.photo.photoList.map{ $0.url }
                    self.setInfo = profileJSON.result
                    
                } catch {
                    print("Profile Not Found: \(error._code)")
                }
                
                self.presentMiniProfile()
            case .failure(let error):
                self.view.isUserInteractionEnabled = true
                print(error.localizedDescription)
            }
        }
    }
}
