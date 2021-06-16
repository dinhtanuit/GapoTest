//
//  BaseViewModel.swift
//  GapoTest
//
//  Created by Tấn Tạ Đình on 11/06/2021.
//

import Foundation

class BaseViewModel: NSObject {
    
    lazy var provider: Provider = {
        return Provider()
    }()
    
}
