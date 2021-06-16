//
//  Font + Extension.swift
//  GapoTest
//
//  Created by Tấn Tạ Đình on 13/06/2021.
//

import Foundation
import UIKit
extension UIFont {
    
   static func getSFProTextBold(size: CGFloat) -> UIFont {
        guard let font = UIFont(name: "SFProText-BoldItalic", size: size) else {
            return UIFont.systemFont(ofSize: size)
        }
        
        return font
    }
    
    static func getSFProTextRegular(size: CGFloat) -> UIFont {
        guard let font = UIFont(name: "SFProText-Regular", size: size) else {
            return UIFont.systemFont(ofSize: size)
        }
        
        return font
    }
}
