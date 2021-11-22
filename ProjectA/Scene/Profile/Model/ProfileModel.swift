//
//  ProfileModel.swift
//  ProjectA
//
//  Created by inforex on 2021/07/22.
//

import Foundation

struct profileAPI: Codable {
    let result: MemberAndPhoto
}

struct MemberAndPhoto: Codable {
    let photo: PhotoInfo
    let member: MemberInfo
}

struct PhotoInfo: Codable {
    let photoList: [PictureInfo]
    let defPhoto: String
    let avataUrl: String
}

// MARK: 사진 URL
struct PictureInfo: Codable {
    let url: String
}

struct MemberInfo: Codable {
    let loc: String
    let distance: Int
    let mem_sex: String
    let l_code: String
    var chat_conts: String
    let mem_id: String
    let mem_age: String
    let chat_name: String
    let totLikeCnt: String
    
    enum CodingKeys: String, CodingKey {
        case loc
        case distance
        case mem_sex
        case l_code
        case chat_conts
        case mem_id
        case mem_age
        case chat_name
        case totLikeCnt
    }
    
}
