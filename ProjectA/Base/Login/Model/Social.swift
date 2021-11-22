//
//  Social.swift
//  ProjectA
//
//  Created by inforex on 2021/08/16.
//

import Foundation

struct Social: Decodable {
    let cmd: String
    let userInfo: String?
}

struct naver: Decodable {
    let message: String
    let response: response
}
struct response: Decodable {
    let email: String
}
