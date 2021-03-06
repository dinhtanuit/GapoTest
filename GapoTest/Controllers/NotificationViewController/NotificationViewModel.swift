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

class NotificationViewModel: GPBaseListViewModel<NotificationModel, NotificationTableViewCellViewModel> {
    
    let rxPageTitle = BehaviorRelay<String?>(value: nil)
    // Alert service injection
    let alertService: IAlertService = DependencyManager.shared.getService()
    let flickrService: NotificationService = DependencyManager.shared.getService()
    
    let rxSearchText = BehaviorRelay<String?>(value: nil)
    let rxHideSearch = BehaviorRelay<Bool>(value: true)
    var rxEndRefreshControl = BehaviorRelay<Bool>(value: false)
    
    var listNotiSearch = [NotificationModel]()
    
    override func react() {
        self.getListItems()
        rxPageTitle.accept("Thông báo")
        
        rxSearchText
            .do(onNext: { text in
               //
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
    
    override func getListItems() {
        self.flickrService.getListNotification()
            .map(prepareSources(_:))
            .subscribe { [weak self] cellViewModel in
                self?.rxShowEmptyState.accept(cellViewModel.isEmpty)
                self?.handleGetListItems(cellViewModel, nextLink: "")
                self?.endRefreshControl()
            } onError: { error in
                //
                self.handleError(error: error)
            } => self.disposeBag
    }
    
    
    override func loadMoreItems() {
        if itemsSource.count <= 0 {
            return
        }
        //        super.loadMoreItems()
        self.flickrService.getListNotification()
            .map(prepareSources(_:))
            .subscribe { [weak self] cellViewModel in
                self?.handleGetListItems(cellViewModel, nextLink: "NextLink")
            } onError: { error in
                //
                self.handleError(error: error)
            } => self.disposeBag
    }
    
    override func handleError(error: Error) {
        super.handleError(error: error)
        alertService.presentOkayAlert(title: "Error", message: "Đã có lỗi xảy ra")

    }
    
    override func reload() {
        rxEndRefreshControl.accept(false)
        super.reload()
    }
    
    func endRefreshControl() {
        rxEndRefreshControl.accept(true)
    }
    
    private func doSearch(keyword: String) {
        
        if keyword.count <= 0 {
            let listCellViewModel = self.listNotiSearch.toCellViewModels() as [NotificationTableViewCellViewModel]
            self.rxShowEmptyState.accept(listCellViewModel.isEmpty)
            self.itemsSource.reset([self.listNotiSearch.toCellViewModels()])
            return
        }
        
        let newNotis = self.listNotiSearch.filter { (noti) -> Bool in
            noti.message.text.capitalized.contains(keyword.capitalized)
        }
        
        let listCellViewModel = newNotis.toCellViewModels() as [NotificationTableViewCellViewModel]
        self.rxShowEmptyState.accept(listCellViewModel.isEmpty)
        self.itemsSource.reset([listCellViewModel])
        
    }
    
    private func prepareSources(_ response: NotificationNewResponse) -> [NotificationTableViewCellViewModel] {
        self.listNotiSearch = response.data
        let listCellViewModel = self.listNotiSearch.toCellViewModels() as [NotificationTableViewCellViewModel]
        return listCellViewModel
    }
    
}
