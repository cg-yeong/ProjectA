//
//  RESTAPI.swift
//  ProjectA
//
//  Created by inforex on 2021/07/23.
//

import Foundation
import Alamofire

class RESTManager: NSObject {
    class var sharedInstance: RESTManager {
        struct Static {
            static let instance: RESTManager = RESTManager()
        }
        return Static.instance
    }
    
    func request(_ path: String,
                 method: HTTPMethod = .get,
                 parameters: [String : Any]? = nil,
                 result: ((_ response: Any?) -> Void)? = nil) {
        //result: ((_ response: Any?) -> Void)? = nil)
        // path : URL String
        let encoding: ParameterEncoding = (method == .post) ? JSONEncoding.default : URLEncoding.queryString
        // post : JSON , get: : URL query
        
        AF.request(path,
                   method: method,
                   parameters: parameters,
                   encoding: encoding)
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
        }
        
    }
    
    /**
     handler = { [weak self] response in
         guard let self = self else { return }
         switch response.result {
         case .success(let data):
             guard let userData = userDatas.first else { return }
         case .failure(let error):
             print(error.localizedDescription)
         }
     }
     */
    func requestData(_ path: String,
                     method: HTTPMethod = .get,
                     param: Parameters? = nil,
                     result: ((_ response: Any?) -> Void)? = nil) {
        let encoding: ParameterEncoding = (method == .post) ? JSONEncoding.default : URLEncoding.queryString
        
        
        
        AF.request(path, method: method, parameters: param, encoding: encoding, headers: nil, interceptor: nil, requestModifier: nil).responseDecodable(of: Member.self) { response in
            let completionHandler = result ?? { _ in } // nil
            switch response.result {
            case .success(let data):
                print(response)
                completionHandler(data)
                
            case .failure(let error):
                print(error.localizedDescription)
                completionHandler(nil)
                
            }
        }
    }
    
    
}
