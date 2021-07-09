//
//  ExampleMenuPage.swift
//  DTMvvm_Example
//
//  Created by Dao Duy Duong on 10/1/18.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import UIKit
import RxCocoa
import DTMvvm

class ExampleMenuPage: ListPage<ExampleMenuPageViewModel> {

    override func initialize() {
        // super will pin our tableView to view edges
        // remove this if we want to custom tableView layout
        super.initialize()
        
        let count = navigationController?.viewControllers.count ?? 0
        if count > 1 {
            enableBackButton = true
        }
        
        tableView.estimatedRowHeight = 200
        tableView.register(ExampleMenuCell.self, forCellReuseIdentifier: ExampleMenuCell.identifier)
    }
    
    override func bindViewAndViewModel() {
        super.bindViewAndViewModel()
        
        guard let viewModel = viewModel else { return }
        
        viewModel.rxPageTitle ~> rx.title => disposeBag
    }
    
    override func cellIdentifier(_ cellViewModel: ExampleMenuCellViewModel) -> String {
        return ExampleMenuCell.identifier
    }
    
    override func selectedItemDidChange(_ cellViewModel: ExampleMenuCellViewModel) {
        if let indexPath = viewModel?.rxSelectedIndex.value {
            tableView.deselectRow(at: indexPath, animated: true)
        }
    }
}

class ExampleMenuPageViewModel: ListViewModel<MenuModel, ExampleMenuCellViewModel> {
    
    let rxPageTitle = BehaviorRelay(value: "")
    
    override func react() {
        let models = getMenuModels()
        itemsSource.reset([models.toCellViewModels()])
        
        // set page title
        rxPageTitle.accept(model?.title ?? "")
    }
    
    override func selectedItemDidChange(_ cellViewModel: ExampleMenuCellViewModel) {
        if let page = pageToNavigate(cellViewModel) {
            navigationService.push(to: page, options: .auto)
        }
    }
    
    func getMenuModels() -> [MenuModel] {
        return []
    }
    
    func pageToNavigate(_ cellViewModel: ExampleMenuCellViewModel) -> UIViewController? {
        return nil
    }
}

/// Menu for home page
class HomeMenuPageViewModel: ExampleMenuPageViewModel {
    
    override func react() {
        super.react()
        
        rxPageTitle.accept("DTMvvm Examples")
    }
    
    override func getMenuModels() -> [MenuModel] {
        return [
            MenuModel(withTitle: "MVVM Examples", desc: "Examples about different ways to use base classes Page, ListPage and CollectionPage."),
            MenuModel(withTitle: "Data Binding Examples", desc: "Examples about how to use data binding."),
            MenuModel(withTitle: "Service Injection Examples", desc: "Examples about how to create a service and register it; how to inject to our ViewModel."),
            MenuModel(withTitle: "Transition Examples", desc: "Examples about how to create a custom transitioning animation and apply it."),
        ]
    }
    
    override func pageToNavigate(_ cellViewModel: ExampleMenuCellViewModel) -> UIViewController? {
        guard let indexPath = rxSelectedIndex.value else { return nil }

        var page: UIViewController?
        page = NotificationViewController(viewModel: NotificationViewModel.init(), style: .plain)
//        switch indexPath.row {
//        case 0:
//            page = ExampleMenuPage(viewModel: MvvmMenuPageViewModel(model: cellViewModel.model))
//
//        case 1:
//            page = ExampleMenuPage(viewModel: DataBindingMenuPageViewModel(model: cellViewModel.model))
//
//        case 2: ()
//
//        case 3:
//            page = ExampleMenuPage(viewModel: TransitionMenuPageViewModel(model: cellViewModel.model))
//
//        default: ()
//        }

        return page
    }
}











