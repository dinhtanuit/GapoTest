//
//  NotificationViewController.swift
//  GapoTest
//
//  Created by Tấn Tạ Đình on 11/06/2021.
//

import UIKit
import RxSwift
import RxCocoa
import DTMvvm
import Action
import Alamofire

class NotificationViewController: ListPage<NotificationViewModel> {
//    let notiViewModel = NotificationViewModel()

    @IBOutlet weak var emptyView: UIView!
    @IBOutlet weak var viewHeaderSearch: UIView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var btnSearch: UIButton!
    
    @IBOutlet weak var viewSearch: UIView!
    @IBOutlet weak var btnCancelSearch: UIButton!
    @IBOutlet weak var viewContentSearch: UIView!
    @IBOutlet weak var tfSearch: UITextField!
    @IBOutlet weak var btnClearSearch: UIButton!
    
    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(handlePullToRefresh), for: .valueChanged)
        return refreshControl
    }()
    
    var listNoti: [NotificationResponse] = [NotificationResponse]()
    let notiIdentifier = "NotificationTableViewCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func initialize() {
        super.initialize()
        self.viewHeaderSearch.backgroundColor = .green
        self.tableView.removeFromSuperview()
        self.tableView.translatesAutoresizingMaskIntoConstraints = true
        self.view.addSubview(self.tableView)
        self.tableView.autoPinEdge(toSuperviewEdge: .bottom)
        self.tableView.autoPinEdge(toSuperviewEdge: .left)
        self.tableView.autoPinEdge(toSuperviewEdge: .right)
        self.tableView.autoPinEdge(.top, to: .bottom, of: self.viewHeaderSearch, withOffset: 0, relation: .equal)
        
        self.initializeContent()
        tableView.estimatedRowHeight = 100
        tableView.register(UINib.init(nibName:NotificationTableViewCell.identifier, bundle: nil), forCellReuseIdentifier: NotificationTableViewCell.identifier)
        if #available(iOS 10.0, *) {
            self.tableView.refreshControl = refreshControl
        } else {
            self.tableView.addSubview(refreshControl)
        }
       
        self.emptyView.isHidden = true
        self.view.bringSubviewToFront(self.emptyView)
    }
    
    override func bindViewAndViewModel() {
        super.bindViewAndViewModel()
        guard let viewModel = self.viewModel else {
            return
        }
        
        viewModel.rxPageTitle ~> self.lblTitle.rx.text => disposeBag
        viewModel.rxSearchText <~> self.tfSearch.rx.text => disposeBag
        viewModel.rxHideSearch ~> self.viewSearch.rx.isHidden => disposeBag
        
        viewModel.rxIsShowEmptyView.subscribe(onNext: { [weak self]  isShowEmptyView in
            self?.emptyView.isHidden = !isShowEmptyView
        }) => disposeBag
        
        self.tableView.rx.endReach(30).subscribe(onNext: {
            viewModel.loadMoreItems()
        }) => disposeBag
        
        viewModel.rxEndRefreshControl.skip(1).subscribe(onNext: { [weak self] isEnded in
            guard let self = self, isEnded else { return }
            self.stopRefreshControl()
        }) => disposeBag
    }
    
    func stopRefreshControl() {
        DispatchQueue.main.async {
            self.refreshControl.endRefreshing()
        }
    }
    
    @objc func handlePullToRefresh() {
        viewModel?.reload()
    }
    
    override func cellIdentifier(_ cellViewModel: NotificationTableViewCellViewModel) -> String {
        return NotificationTableViewCell.identifier
    }
    
    override func selectedItemDidChange(_ cellViewModel: ListPage<NotificationViewModel>.CVM) {
        if let indexPath = viewModel?.rxSelectedIndex.value {
            self.tableView.deselectRow(at: indexPath, animated: true)
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func initializeContent() {
        self.setupView()
        self.handlerAction()

    }

    func setupView() {
        self.viewSearch.isHidden = true
        self.viewContentSearch.layer.cornerRadius = self.viewContentSearch.frame.height/2
    }
    
    func handlerAction() {
        self.btnSearch.rx.tap.asDriver().throttle(RxTimeInterval.milliseconds(0)).drive(onNext: {
            [weak self] in

            guard let strongSelf = self else {
                return
            }

            strongSelf.viewModel?.rxHideSearch.accept(false)
            strongSelf.tfSearch.becomeFirstResponder()

        }) => disposeBag

        self.btnClearSearch.rx.tap.asDriver().throttle(RxTimeInterval.milliseconds(0)).drive(onNext: {
            [weak self] in

            guard let strongSelf = self else {
                return
            }
            strongSelf.tfSearch.text = ""

        }) => disposeBag

        self.btnCancelSearch.rx.tap.asDriver().throttle(RxTimeInterval.milliseconds(0)).drive(onNext: {
            [weak self] in

            guard let strongSelf = self else {
                return
            }
            strongSelf.viewModel?.rxHideSearch.accept(true)
            strongSelf.tfSearch.text = ""
            strongSelf.tfSearch.endEditing(true)

        }) => disposeBag

    }
    
    func setupBinding() {
    }
    
    @IBAction func actionTextSearchEditingChanged(_ sender: Any) {
//        if let textSearch = self.tfSearch.text {
////            self.notiViewModel.handleSearch(textSearch: textSearch)
//        }
    }
}

