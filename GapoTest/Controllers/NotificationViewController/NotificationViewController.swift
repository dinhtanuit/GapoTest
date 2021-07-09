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

    @IBOutlet weak var viewHeaderSearch: UIView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var btnSearch: UIButton!
    
    @IBOutlet weak var viewSearch: UIView!
    @IBOutlet weak var btnCancelSearch: UIButton!
    @IBOutlet weak var viewContentSearch: UIView!
    @IBOutlet weak var tfSearch: UITextField!
    @IBOutlet weak var btnClearSearch: UIButton!
    
    
//    let viewSearchBar = SearchBarView.instantiate()
//    let disposeBag = DisposeBag()
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
        tableView.register(UINib.init(nibName:"NotificationTableViewCell", bundle: nil), forCellReuseIdentifier: "NotificationTableViewCell")
    }
    
    override func bindViewAndViewModel() {
        super.bindViewAndViewModel()
        guard let viewModel = self.viewModel else {
            return
        }
        
        viewModel.rxPageTitle ~> self.lblTitle.rx.text => disposeBag
        viewModel.rxSearchText <~> self.tfSearch.rx.text => disposeBag
        viewModel.rxHideSearch ~> self.viewSearch.rx.isHidden => disposeBag
        
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

        }).disposed(by: self.disposeBag ?? DisposeBag.init())

        self.btnClearSearch.rx.tap.asDriver().throttle(RxTimeInterval.milliseconds(0)).drive(onNext: {
            [weak self] in

            guard let strongSelf = self else {
                return
            }
            strongSelf.tfSearch.text = ""

        }).disposed(by: self.disposeBag ?? DisposeBag.init())

        self.btnCancelSearch.rx.tap.asDriver().throttle(RxTimeInterval.milliseconds(0)).drive(onNext: {
            [weak self] in

            guard let strongSelf = self else {
                return
            }
            strongSelf.viewModel?.rxHideSearch.accept(true)
            strongSelf.tfSearch.text = ""
            strongSelf.tfSearch.endEditing(true)

        }).disposed(by: self.disposeBag ?? DisposeBag.init())

    }
    
    func setupBinding() {
//        self.notiViewModel.listNotiResponse.subscribe { [weak self] (listNoti) in
//            guard let strongSelf = self else {
//                return
//            }
//            strongSelf.listNoti =  listNoti
//            strongSelf.tbvListNoti.reloadData()
//        } onError: { error in
//            print(error)
//        } onCompleted: {
//            //
//        } onDisposed: {
//            //
//        }.disposed(by: self.disposeBag)
        
//        self.notiViewModel.listNotiResponse.observe(on: MainScheduler.instance).subscribe(onNext: { [weak self] (listNoti) in
//            guard let strongSelf = self else {
//                return
//            }
//            strongSelf.listNoti =  listNoti
//            strongSelf.tbvListNoti.reloadData()
//
//        }).disposed(by: self.disposeBag)
        
    }
    
    @IBAction func actionTextSearchEditingChanged(_ sender: Any) {
//        if let textSearch = self.tfSearch.text {
////            self.notiViewModel.handleSearch(textSearch: textSearch)
//        }
    }
}

//// MARK: ---UITableViewDelegate
//extension NotificationViewController: UITableViewDelegate {
//
//    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
//        return UITableView.automaticDimension
//    }
//
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        //
//        if indexPath.row < self.listNoti.count {
//            self.notiViewModel.handleReadNoti(noti: &self.listNoti[indexPath.row])
//            self.tbvListNoti.reloadRows(at: [indexPath], with: .none)
//        }
//    }
//}
//
//// MARK: ---UITableViewDataSource
//extension NotificationViewController: UITableViewDataSource {
//
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return self.listNoti.count
//    }
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: self.notiIdentifier, for: indexPath) as! NotificationTableViewCell
//        if self.listNoti.count > indexPath.row {
//            cell.setupData(noti: self.listNoti[indexPath.row])
//            cell.delegateCell = self
//        }
//        return cell
//    }
//}


// MARK: ---NotificationTableViewCellDelegate
extension NotificationViewController: NotificationTableViewCellDelegate {
    func touchUpInButtonMore() {
        //
    }
}
