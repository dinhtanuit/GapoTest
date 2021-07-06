//
//  NotificationViewController.swift
//  GapoTest
//
//  Created by Tấn Tạ Đình on 11/06/2021.
//

import UIKit
import RxSwift
import RxCocoa

class NotificationViewController: UIViewController {
    let notiViewModel = NotificationViewModel()

    @IBOutlet weak var viewHeaderSearch: UIView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var btnSearch: UIButton!
    @IBOutlet weak var tbvListNoti: UITableView!
    
    @IBOutlet weak var viewSearch: UIView!
    @IBOutlet weak var btnCancelSearch: UIButton!
    @IBOutlet weak var viewContentSearch: UIView!
    @IBOutlet weak var tfSearch: UITextField!
    @IBOutlet weak var btnClearSearch: UIButton!
    
    
//    let viewSearchBar = SearchBarView.instantiate()
    let disposeBag = DisposeBag()
    var listNoti: [NotificationResponse] = [NotificationResponse]()
    let notiIdentifier = "NotificationTableViewCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initializeContent()

        // Do any additional setup after loading the view.
    }
    
    func initializeContent(){
        self.setupView()
        self.handlerAction()
        self.registerTableViewCell()
        self.setupBinding()
        self.notiViewModel.getListNotiResponse()

    }

    func setupView() {
        self.tbvListNoti.delegate = self
        self.tbvListNoti.dataSource = self
        self.tbvListNoti.estimatedRowHeight = 100.0
        self.tbvListNoti.rowHeight = UITableView.automaticDimension
        
        self.viewSearch.isHidden = true
        self.viewContentSearch.layer.cornerRadius = self.viewContentSearch.frame.height/2
        
        self.lblTitle.text = "Thông báo"
        
    }
    
    func registerTableViewCell() {
        let notificationXib = UINib(nibName: self.notiIdentifier, bundle: nil)
        self.tbvListNoti.register(notificationXib, forCellReuseIdentifier: self.notiIdentifier)
    }
    
    func handlerAction() {
        self.btnSearch.rx.tap.asDriver().throttle(RxTimeInterval.milliseconds(0)).drive(onNext: {
            [weak self] in
            
            guard let strongSelf = self else {
                return
            }
            
            strongSelf.viewSearch.isHidden = false
            strongSelf.tfSearch.becomeFirstResponder()
           
        }).disposed(by: self.disposeBag)
        
        self.btnClearSearch.rx.tap.asDriver().throttle(RxTimeInterval.milliseconds(0)).drive(onNext: {
            [weak self] in
            
            guard let strongSelf = self else {
                return
            }
            strongSelf.tfSearch.text = ""
            strongSelf.notiViewModel.handleCancelSearch()
            
           
        }).disposed(by: self.disposeBag)
        
        self.btnCancelSearch.rx.tap.asDriver().throttle(RxTimeInterval.milliseconds(0)).drive(onNext: {
            [weak self] in
            
            guard let strongSelf = self else {
                return
            }
            strongSelf.viewSearch.isHidden = true
            strongSelf.tfSearch.text = ""
            strongSelf.tfSearch.endEditing(true)
            strongSelf.notiViewModel.handleCancelSearch()

        }).disposed(by: self.disposeBag)
        
    }
    
    func setupBinding() {
        self.notiViewModel.listNotiResponse.subscribe { [weak self] (listNoti) in
            guard let strongSelf = self else {
                return
            }
            strongSelf.listNoti =  listNoti
            strongSelf.tbvListNoti.reloadData()
        } onError: { error in
            print(error)
        } onCompleted: {
            //
        } onDisposed: {
            //
        }.disposed(by: self.disposeBag)
        
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
        if let textSearch = self.tfSearch.text {
            self.notiViewModel.handleSearch(textSearch: textSearch)
        }
    }
}

// MARK: ---UITableViewDelegate
extension NotificationViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //
        if indexPath.row < self.listNoti.count {
            self.notiViewModel.handleReadNoti(noti: &self.listNoti[indexPath.row])
            self.tbvListNoti.reloadRows(at: [indexPath], with: .none)
        }
    }
}

// MARK: ---UITableViewDataSource
extension NotificationViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.listNoti.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: self.notiIdentifier, for: indexPath) as! NotificationTableViewCell
        if self.listNoti.count > indexPath.row {
            cell.setupData(noti: self.listNoti[indexPath.row])
            cell.delegateCell = self
        }
        return cell
    }
}


// MARK: ---NotificationTableViewCellDelegate
extension NotificationViewController: NotificationTableViewCellDelegate {
    func touchUpInButtonMore() {
        //
    }
}
