//
//  Member.swift
//  ProjectA
//
//  Created by inforex on 2021/07/28.
//

import Foundation

// 회원 체크
struct Member: Decodable {
    let mem_info: MemInfo?
    let code: Int
    let is_member: Bool
    let msg: String
    let redirect_url: String?
    
    enum CodingKeys: String, CodingKey {
        case mem_info
        case code
        case is_member
        case msg
        case redirect_url
    }
}

struct MemInfo: Decodable {
    let name: String
    let email: String
    let profile_image: String?
    let contents: String?
    let gender: String
    let age: String
    
    enum CodingKeys: String, CodingKey {
        case name
        case email
        case profile_image
        case contents
        case gender
        case age
    }
}
