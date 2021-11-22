//
//  String+DDay.swift
//  ProjectA
//
//  Created by inforex on 2021/07/28.
//

import Foundation

extension String {
    var DDay: Int? { // -> 초로 반환
        let calendar = Calendar.current
        let currentDate = Date()
        let dateFormatter = DateFormatter()
        
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        let timeZoneOffset = Double(TimeZone.current.secondsFromGMT(for: currentDate))
        guard let endDate = dateFormatter.date(from: self) else { return nil }
        guard let localEndDate = calendar.date(byAdding: .second,
                                               value: Int(timeZoneOffset),
                                               to: endDate) else { return nil }
        
        guard let second = calendar.dateComponents([.second], from: localEndDate, to: currentDate).second else {
            return nil
        }
        return second
    }
    
    var yearGap: Int? {
        let now = Date()
        let calendar = Calendar.current
        let date = DateFormatter()
        date.timeZone = TimeZone(abbreviation: "GMT")
        date.dateFormat = "yyyy"
        
        guard let writedDate = date.date(from: self) else { return nil }
        guard let yearGapResult = calendar.dateComponents([.year], from: writedDate, to: now).year else {
            return nil
        }
        
        return yearGapResult
    }
    
    var timeGap: Int? {
        let now = Date()
        let calendar = Calendar.current
        let date = DateFormatter()
        date.timeZone = TimeZone(abbreviation: "GMT")
        date.dateFormat = "yyyy-MM-dd HH:mm:ss"
        guard let writedDate = date.date(from: self) else { return nil }
        guard let timeGap = calendar.dateComponents([.second], from: writedDate, to: now).second else {
            return nil
        }
        
        return timeGap
    }

}
