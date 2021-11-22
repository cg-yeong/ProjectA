//
//  API.swift
//  ProjectA
//
//  Created by inforex on 2021/07/14.
//

import Foundation

enum ToastMessage: String {
    case empty = "사연을 입력해주세요."
    case notOverTen = "10자 이상 작성해주세요."
    case overLimit = " 300자 이상 입력할 수 없습니다. "
    case success = " 사연을 성공적으로 보냈습니다. "
}

protocol sendDataDelegate {
    func sendData(data: String)
    func sendDefaultData(data: Dictionary<String, Any>)
}

protocol CustomCellEventDelegate {
    func moreEventButton(index: Int)
}
