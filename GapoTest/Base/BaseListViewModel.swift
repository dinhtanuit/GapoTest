//
//  BaseListViewModel.swift
//  GAPO
//
//  Created by toandk on 6/21/21.
//  Copyright © 2021 GAPO. All rights reserved.
//

import Foundation
import DTMvvm
import RxSwift
import RxCocoa
import ASMvvm

class GPBaseListViewModel<M, CVM>: ListViewModel<M, CVM> where CVM: IGenericViewModel {
    var nextLink: String = ""
    let rxIsLoading = BehaviorRelay<Bool>(value: false)
    let rxShowEmptyState = BehaviorRelay<Bool>(value: false)
    var canLoadMore: Bool = true
    
    override func react() {
        super.react()
        getListItems()
    }
    
    func getListItems() {
        self.rxIsLoading.accept(true)
        // Call API here
        // Then handleGetListItems
    }

    func handleGetListItems(_ list: [CVM]?, nextLink: String) {
        guard let list = list else {
            self.rxIsLoading.accept(false)
            return
        }
        let isReload = nextLink.isEmpty
        self.nextLink = nextLink
        self.canLoadMore = !self.nextLink.isEmpty && list.count > 0
        self.rxIsLoading.accept(false)
        self.checkEmptyState(list, nextLink: nextLink)
        if isReload {
            self.itemsSource.reset(list, animated: false)
        }
        else {
            self.itemsSource.append(list)
        }
    }

    func loadMoreItems() {
        guard canLoadMore && !rxIsLoading.value else { return }
        getListItems()
    }

    func reload() {
        nextLink = ""
        getListItems()
    }

    private func checkEmptyState(_ list: [CVM]?, nextLink: String) {
        let isReload = nextLink.isEmpty
        if isReload && list?.count == 0 {
            rxShowEmptyState.accept(true)
        }
    }

    private func handleError(error: Error) {
        self.rxIsLoading.accept(false)
        // Uncomment to show error
        // Utils.showMessage(error.apiMessage)
    }
}

class GPBaseASMListVM<M, CVM>: ASMListViewModel<M, CVM> where CVM: IASMGenericViewModel {
    var nextLink: String = ""
    let rxShowEmptyState = BehaviorRelay<Bool>(value: false)
    
    override func react() {
        super.react()
        getListItems()
    }
    
    func getListItems() {
        self.rxIsLoading.accept(true)
        // Call API here
        // Then handleGetListItems
    }
    
    func handleGetListItems(_ list: [CVM]?, nextLink: String) {
        guard let list = list else {
            self.finishFetching()
            return
        }
        let isReload = nextLink.isEmpty
        self.nextLink = nextLink
        self.canLoadMore = !self.nextLink.isEmpty && list.count > 0
        self.finishFetching()
        self.checkEmptyState(list, nextLink: nextLink)
        if isReload {
            self.itemsSource.reset(list, animated: false)
        }
        else {
            self.itemsSource.append(list)
        }
    }

    func loadMoreItems() {
        guard canLoadMore && !rxIsLoading.value else { return }
        getListItems()
    }

    func reload() {
        nextLink = ""
        getListItems()
    }

    private func checkEmptyState(_ list: [CVM]?, nextLink: String) {
        let isReload = nextLink.isEmpty
        if isReload && list?.count == 0 {
            rxShowEmptyState.accept(true)
        }
    }

    private func handleError(error: Error) {
        self.finishFetching()
        // Uncomment to show error
        // Utils.showMessage(error.apiMessage)
    }
}
