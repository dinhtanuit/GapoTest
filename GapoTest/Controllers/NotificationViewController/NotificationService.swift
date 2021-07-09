//
//  NotificationService.swift
//  GapoTest
//
//  Created by DinhTan on 07/07/2021.
//

import Foundation
import RxSwift
import Moya
import ObjectMapper

class NotificationService {
    
    func getListNotification() -> Single<NotificationNewResponse> {
        
        let response: Single<Response> = Single.create { singe in
            if let path = Bundle.main.path(forResource: "noti", ofType: "json") {
                do {
                    let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
                    let response = Response.init(statusCode: 200, data: data)
                    singe(.success(response))
                } catch {
                    singe(.error(Error.self as! Error))
                    // handle error
                }
            }
            
            return Disposables.create {
                
            }
        }
        
        return response
            .filterSuccessfulStatusCodes()
            .mapObject(NotificationNewResponse.self)
    }
    
    
}
