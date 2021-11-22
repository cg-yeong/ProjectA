//
//  SocialEmail.swift
//  ProjectA
//
//  Created by inforex on 2021/08/02.
//

import Foundation

class SocialEmail {
    class var shared: SocialEmail {
        struct Static {
            static let instance: SocialEmail = SocialEmail()
        }
        return Static.instance
    }
    
    var email: String?
    var name: String?
    var profile: String?
    var gender: String?
    var age: String?
    
    
    private init() {
        
    }
}
