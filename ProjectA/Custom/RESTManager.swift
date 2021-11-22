//
//  RESTAPI.swift
//  ProjectA
//
//  Created by inforex on 2021/07/23.
//

import Foundation
import Alamofire

struct WebpageData {
    
    static var basePage = "http://babyhoney.kr"
    static var apiPage: String { return WebpageData.basePage + "/api/" }
    static var memberPath: String { return apiPage + "member/" }
}

class RESTManager: NSObject {
    
    func request(_ path: String,
                 method: HTTPMethod = .get,
                 parameters: [String : Any]? = nil,
                 result: @escaping (Any?) -> Void) {
        
        let encoding: ParameterEncoding = (method == .post) ? JSONEncoding.default : URLEncoding.queryString
        // post : JSON , get: : URL query
        
        AF.request(path,
                   method: method,
                   parameters: parameters,
                   encoding: encoding)
            .responseJSON { (response) in
                let completionHandler = result // result ?? nil
                switch response.result {
                case .success(let res):
                    print(res)
                    completionHandler(res)
                // 콜백 함수 result로 커스텀?
                case .failure(let error):
                    print(error.localizedDescription)
                    completionHandler(nil)
                }
            }
        
    }
    
    func requestJSON(_ path: String,
                     method: HTTPMethod = .get,
                     param: Parameters? = nil,
                     result: ((_ response: Any?) -> Void)? = nil) {
        let encoding: ParameterEncoding = (method == .post) ? JSONEncoding.default : URLEncoding.queryString
        AF.sessionConfiguration.timeoutIntervalForRequest = 5
        AF.sessionConfiguration.timeoutIntervalForResource = 5
        AF.request(path,
                   method: method,
                   parameters: param,
                   encoding: encoding,
                   headers: nil, interceptor: nil, requestModifier: nil)
            .responseJSON { response in
                let completionHandler = result ?? { _ in }
                switch response.result {
                case .success(let res):
                    print(res)
                    completionHandler(res)
                // 콜백 함수 result로 커스텀?
                case .failure(let error):
                    print(error.localizedDescription)
                    
                    completionHandler(nil)
                }
                
            }.resume()
    }
    
    
    func memberREST(email: String, handler: ((Member?) -> Void)? = nil) {
        let handler = handler ?? { _ in }
        let path = WebpageData.memberPath + email
        self.requestJSON(path, method: .get, param: nil) { result in
            guard let res = result else {
                handler(nil)
                return // nil
            }
            // not nil
            do {
                let json = try JSONSerialization.data(withJSONObject: res, options: .prettyPrinted)
                let memInfo = try JSONDecoder().decode(Member.self, from: json)
                handler(memInfo)
            } catch {
                print("디코딩 오류")
            }
        }
        
    }
    
    
    
}
