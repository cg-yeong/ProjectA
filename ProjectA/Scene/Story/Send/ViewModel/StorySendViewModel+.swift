//
//  StorySendViewModel+.swift
//  ProjectA
//
//  Created by inforex on 2021/11/24.
//

import Foundation
import SwiftyJSON


extension StorySendViewModel {
    
    func setUp(_ initData: JSON) {
        let fromUser = MemInfo(name: initData["name"].stringValue,
                               email: initData["email"].stringValue,
                               profile_image: initData["profile_image"].stringValue,
                               contents: initData["contents"].string,
                               gender: initData["gender"].stringValue,
                               age: initData["age"].stringValue)
        self.model.fromUser.onNext(fromUser)
        
        let toUser = MemInfo(name: initData["name"].stringValue,
                             email: initData["email"].stringValue,
                             profile_image: initData["profile_image"].stringValue,
                             contents: initData["contents"].string,
                             gender: initData["gender"].stringValue,
                             age: initData["age"].stringValue)
        self.model.toUser.onNext(toUser)
    }
    
    func send(_ from: MemInfo, to: MemInfo, text: String, completion: ((Bool) -> Void)? = nil) {
        let completion = completion ?? { _ in }
//        let path = WebpageData.apiPage + "/story"
        let path = "http://pida83.gabio.io/api/story"
        let params: [String : String] = [
            "send_mem_gender" : from.gender,
            "send_mem_no" : String(4558),
            "send_chat_name" : from.name,
            "send_mem_photo" : from.profile_image ?? "",
            "story_conts" : text,
            "bj_id" : from.email
        ]
        
        print(params)
        RESTManager().request(path, method: .post, parameters: params) { response in
            guard response != nil else {
                completion(false)
                return
            }
            completion(true)
        }
    }
    
    func editing(_ begin: Bool) {
        self.model.editing.accept(begin)
    }
}
