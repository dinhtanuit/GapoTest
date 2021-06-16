//
//  SearchBarView.swift
//  GapoTest
//
//  Created by Tấn Tạ Đình on 12/06/2021.
//

import UIKit
import RxSwift

class SearchBarView: UIView {
    @IBOutlet weak var viewContainerSearch: UIView!
    @IBOutlet weak var btnCancel: UIButton!
    @IBOutlet weak var imageIconSearch: UIImageView!
    @IBOutlet weak var tfSearch: UITextField!
    @IBOutlet weak var btnClear: UIButton!
    
    static func instantiate() -> SearchBarView {
        let view: SearchBarView = fromNib()
        view.backgroundColor = .clear
        view.viewContainerSearch.layer.cornerRadius = view.frame.height/2
        view.tfSearch.backgroundColor = .clear

        return view
    }
    
    

}
