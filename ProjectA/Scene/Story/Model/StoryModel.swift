//
//  StoryModel.swift
//  ProjectA
//
//  Created by inforex on 2021/07/22.
//

import Foundation

// MARK: - StoryList
struct StoryList: Codable {
    let totalPage: Int
    let list: [List]
    let currentPage: Int
    let status: String

    enum CodingKeys: String, CodingKey {
        case totalPage = "total_page"
        case list
        case currentPage = "current_page"
        case status
    }
}
// MARK: - List
struct List: Codable {
    let sendMemGender: String
    let insDate: String
    let sendMemPhoto: String?
    let storyConts: String
    let sendChatName: String
    let regNo: String
    let readYn: String
//    let sendMemNo: String
//    let bjID: String

    enum CodingKeys: String, CodingKey {
        case sendMemGender = "send_mem_gender"
        case insDate = "ins_date"
        case sendMemPhoto = "send_mem_photo"
        case storyConts = "story_conts"
        case sendChatName = "send_chat_name"
        case regNo = "reg_no"
        case readYn = "read_yn"
//        case sendMemNo = "send_mem_no"
//        case bjID = "bj_id"
    }
}
