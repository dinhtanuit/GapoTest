//
//  UiImageView + Extension.swift
//  GapoTest
//
//  Created by Tấn Tạ Đình on 13/06/2021.
//

import Foundation
import UIKit
import SDWebImage

extension UIImageView {
    
    func setImageWithURL(_ imageName: String, _ placeHolder: String? = nil) {
        let newImageName = imageName
        if let placeHolder = placeHolder, let image = UIImage.init(named: placeHolder) {
            self.sd_setImage(with: URL(string: newImageName), placeholderImage: image)
            
        } else {
            self.sd_setImage(with: URL(string: newImageName), placeholderImage: UIImage(named: "ic_DefaultAvatar"))
        }
        
    }
    
}
