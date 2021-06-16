//
//  Provider.swift
//  GapoTest
//
//  Created by Tấn Tạ Đình on 11/06/2021.
//

import Foundation
import SwiftyJSON

typealias RequestCompletion = ((_ success: Bool, _ IsFailResponseError: Bool, _ data: Any?) -> (Void))?

class Provider: NSObject {
    
    func getData(complete: RequestCompletion) {
        if let path = Bundle.main.path(forResource: "noti", ofType: "json") {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
                complete?(true,false,data)
            } catch {
                complete?(false,false,nil)
                // handle error
            }
        }
    }
    
}
