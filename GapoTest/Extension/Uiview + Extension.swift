//
//  Uiview + Extension.swift
//  GapoTest
//
//  Created by Tấn Tạ Đình on 12/06/2021.
//

import Foundation
import UIKit

extension UIView {
    class func fromNib<T: UIView>() -> T {
        return Bundle(for: T.self).loadNibNamed(String(describing: T.self), owner: nil, options: nil)![0] as! T
    }
}

