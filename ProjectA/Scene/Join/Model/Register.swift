//
//  Register.swift
//  ProjectA
//
//  Created by inforex on 2021/07/29.
//

import Foundation

// 회원가입 리턴
struct Register: Codable {
    let profile_url: String?
    let redirect_url: String?
    let inserted_id: Int
    let msg: String
    let hash: String
    let email: String
    let name: String
    let code: Int
    let age: String
    let gender: String
}
