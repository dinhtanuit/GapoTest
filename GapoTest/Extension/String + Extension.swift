//
//  String + Extension.swift
//  GapoTest
//
//  Created by Tấn Tạ Đình on 13/06/2021.
//

import Foundation
extension String {
    
   static func getDate(withTime time: Int) -> String {
        let date = NSDate(timeIntervalSince1970: TimeInterval(time))
        //Date formatting
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy, HH:mm"
        //dateFormatter.timeZone = NSTimeZone(name: "UTC")
        let dateString = dateFormatter.string(from: date as Date)
        return dateString
    }
}
