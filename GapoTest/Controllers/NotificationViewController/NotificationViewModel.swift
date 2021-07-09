//
//  NotificationViewModel.swift
//  GapoTest
//
//  Created by Tấn Tạ Đình on 13/06/2021.
//

import Foundation
import RxSwift
import SwiftyJSON
import DTMvvm
import RxCocoa

class NotificationViewModel: ListViewModel<NotificationModel, NotificationTableViewCellViewModel> {
    
    let rxPageTitle = BehaviorRelay<String?>(value: nil)
    // Alert service injection
    let alertService: IAlertService = DependencyManager.shared.getService()
    let flickrService: NotificationService = DependencyManager.shared.getService()
    
    let rxSearchText = BehaviorRelay<String?>(value: nil)
    let rxIsSearching = BehaviorRelay<Bool>(value: false)
    let rxHideSearch = BehaviorRelay<Bool>(value: true)
    
    var tmpBag: DisposeBag?
    var finishedSearching = false
    var listNotiSearch = [NotificationModel]()
    var resultNotiSearch = [NotificationModel]()

    override func react() {
        self.getListNotification()
        rxPageTitle.accept("Thông báo")

        rxSearchText
            .do(onNext: { text in
                self.tmpBag = nil // stop current load more if any
                self.finishedSearching = false // reset done state
                
                if !text.isNilOrEmpty {
                    self.rxIsSearching.accept(true)
                }
            })
            .debounce(.milliseconds(50), scheduler: Scheduler.shared.mainScheduler)
            .subscribe(onNext: { [weak self] text in
                if !text.isNilOrEmpty {
                    self?.doSearch(keyword: text!)
                }
            }) => disposeBag
        
        rxHideSearch
            .do(onNext: { isCancel in
                //
            })
            .debounce(.milliseconds(50), scheduler: Scheduler.shared.mainScheduler)
            .subscribe { [weak self] isCancel in
                self?.doSearch(keyword: "")
            } => disposeBag
    }
    
    override func selectedItemDidChange(_ cellViewModel: NotificationTableViewCellViewModel) {
        cellViewModel.rxReaded.accept(true)
    }
    
    private func getListNotification() {
        
        self.flickrService.getListNotification()
            .map(prepareSources(_:))
            .subscribe { [weak self] cellViewModel in
                self?.itemsSource.reset([cellViewModel])
            } onError: { [weak self] error in
                //
            } => self.disposeBag

    }
    
    private func doSearch(keyword: String) {
        
        if keyword.count <= 0 {
            self.itemsSource.reset([self.listNotiSearch.toCellViewModels()])
            return
        }
        
        let newNotis = self.listNotiSearch.filter { (noti) -> Bool in
            noti.message.text.capitalized.contains(keyword.capitalized)
        }
        
        let listCellViewModel = newNotis.toCellViewModels() as [NotificationTableViewCellViewModel]
        self.itemsSource.reset([listCellViewModel])
        
    }
    
    private func prepareSources(_ response: NotificationNewResponse) -> [NotificationTableViewCellViewModel] {
        self.listNotiSearch = response.data
        return self.listNotiSearch.toCellViewModels() as [NotificationTableViewCellViewModel]
    }
    
//    let listNotiResponse: PublishSubject<[NotificationResponse]> = PublishSubject()
//    fileprivate var listNoti = [NotificationResponse]()
//    
//    func getListNotiResponse() {
//        self.provider.getData { [weak self](success, IsFailResponseError, data) -> (Void) in
//            guard let strongSelf = self else {
//                return
//            }
//            
//            if success && !IsFailResponseError , let data = data as? Data {
//                do {
//                    let jsonResponse = try JSON.init(data: data)
//                    let arrNoti = jsonResponse["data"].arrayValue
//                    var notis = [NotificationResponse]()
//                    for item in arrNoti {
//                        let noti = NotificationResponse.init(json: item)
//                        notis.append(noti)
//                    }
//                    strongSelf.listNoti = notis
//                    strongSelf.listNotiResponse.onNext(strongSelf.listNoti)
//                } catch {
//                    
//                }
//            }
//        }
//    }
//    
//    func handleSearch(textSearch: String) {
//        if textSearch.count <= 0 {
//            self.listNotiResponse.onNext(self.listNoti)
//            return
//        }
//        let newNotis = self.listNoti.filter { (noti) -> Bool in
//            noti.message.text.capitalized.contains(textSearch.capitalized)
//        }
//        self.listNotiResponse.onNext(newNotis)
//    }
//    
//    func handleCancelSearch() {
//        self.listNotiResponse.onNext(self.listNoti)
//    }
//    
//    func handleReadNoti(noti: inout NotificationResponse) {
//        noti.updateStatus(status: .read)
//    }
    
}
