//
//  NotificationViewModel.swift
//  GapoTest
//
//  Created by Tấn Tạ Đình on 13/06/2021.
//

import Foundation
import RxSwift
import SwiftyJSON

class NotificationViewModel: BaseViewModel {
    let listNotiResponse: PublishSubject<[NotificationResponse]> = PublishSubject()
    fileprivate var listNoti = [NotificationResponse]()
    
    func getListNotiResponse() {
        self.provider.getData { [weak self](success, IsFailResponseError, data) -> (Void) in
            guard let strongSelf = self else {
                return
            }
            
            if success && !IsFailResponseError , let data = data as? Data {
                do {
                    let jsonResponse = try JSON.init(data: data)
                    let arrNoti = jsonResponse["data"].arrayValue
                    var notis = [NotificationResponse]()
                    for item in arrNoti {
                        let noti = NotificationResponse.init(json: item)
                        notis.append(noti)
                    }
                    strongSelf.listNoti = notis
                    strongSelf.listNotiResponse.onNext(strongSelf.listNoti)
                } catch {
                    
                }
            }
        }
    }
    
    func handleSearch(textSearch: String) {
        if textSearch.count <= 0 {
            self.listNotiResponse.onNext(self.listNoti)
            return
        }
        let newNotis = self.listNoti.filter { (noti) -> Bool in
            noti.message.text.capitalized.contains(textSearch.capitalized)
        }
        self.listNotiResponse.onNext(newNotis)
    }
    
    func handleCancelSearch() {
        self.listNotiResponse.onNext(self.listNoti)
    }
    
    func handleReadNoti(noti: inout NotificationResponse) {
        noti.updateStatus(status: .read)
    }
    
}
