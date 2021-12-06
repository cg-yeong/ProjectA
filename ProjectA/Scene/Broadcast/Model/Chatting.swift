//
//  Chatting.swift
//  ProjectA
//
//  Created by inforex on 2021/08/16.
//

import Foundation
import SwiftyJSON

struct Chat {
    var cmd: String?
    var msg: String?
    var from: [String : JSON]?
    
    var action: (() -> Void)?
}
