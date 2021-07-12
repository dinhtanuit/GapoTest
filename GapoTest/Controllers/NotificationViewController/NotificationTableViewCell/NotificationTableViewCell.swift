//
//  NotificationTableViewCell.swift
//  GapoTest
//
//  Created by Tấn Tạ Đình on 13/06/2021.
//

import UIKit
import DTMvvm
import RxCocoa
import RxSwift

class NotificationTableViewCell: TableCell<NotificationTableViewCellViewModel> {
    
    @IBOutlet weak var viewContent: UIView!
    @IBOutlet weak var viewAvatar: UIView!
    @IBOutlet weak var lblMessage: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var btnMore: UIButton!
    @IBOutlet weak var imageAvatar: UIImageView!
    @IBOutlet weak var imageIcon: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.imageAvatar.layer.cornerRadius = self.imageAvatar.frame.height/2
        self.imageAvatar.clipsToBounds = true
        self.imageIcon.layer.cornerRadius = self.imageIcon.frame.height/2
        self.imageIcon.clipsToBounds = true
        // Initialization code
    }
    
    override func bindViewAndViewModel() {
        
        guard let viewModel = viewModel else { return }
        
        if self.viewContent == nil {
            return
        }
        viewModel.rxDate ~> self.lblDate.rx.text => disposeBag
        viewModel.rxImageIcon ~> self.imageIcon.rx.networkImage => disposeBag
        viewModel.rxImageAvatar ~> self.imageAvatar.rx.networkImage => disposeBag
        viewModel.rxMessage ~> self.lblMessage.rx.attributedText => disposeBag
        viewModel.rxBackground ~> self.viewContent.rx.backgroundColor => disposeBag
        
    }
    
    @IBAction func actionTapMoreButton(_ sender: Any) {
        viewModel?.handleClickMoreButton()
    }
}

class NotificationTableViewCellViewModel: CellViewModel<NotificationModel> {
    
    let rxImageAvatar = BehaviorRelay<NetworkImage>(value: NetworkImage())
    let rxImageIcon = BehaviorRelay<NetworkImage>(value: NetworkImage())
    let rxMessage = BehaviorRelay<NSAttributedString?>(value: nil)
    let rxDate = BehaviorRelay<String?>(value: nil)
    let rxReaded = BehaviorRelay<Bool?>(value: nil)
    let rxBackground = BehaviorRelay<UIColor?>(value: nil)
    let rxHandleClickMore = BehaviorRelay<Bool?>(value: nil)
    
    override func react() {
        rxImageAvatar.accept(NetworkImage(withURL: URL.init(string: model?.image ?? ""), placeholder: UIImage.from(color: .black), completion: nil))
        rxImageIcon.accept(NetworkImage.init(withURL: URL.init(string: model?.icon ?? ""), placeholder:  UIImage.from(color: .black), completion: nil))
        rxMessage.accept(self.getAttributedString(message: model?.message))
        rxDate.accept(String.getDate(withTime: model?.createdAt ?? 0))
        rxReaded.accept(model?.status == .read)
        
        rxReaded.observeOn(MainScheduler.instance).subscribe(onNext: { [weak self] status in
            if status ?? false {
                self?.model?.status = .read
                self?.rxBackground.accept(.green)
            } else {
                self?.model?.status = .unRead
                self?.rxBackground.accept(.white)
            }
        }) => disposeBag
    }
    
    func handleClickMoreButton() {
        print("CLick -- \(String(describing: indexPath?.row))")
    }
    
    func getAttributedString(message: MessageModel?) -> NSMutableAttributedString? {
        guard let message = message else { return nil }
        
        let messageText = NSMutableAttributedString.init(string: message.text)
        // set the custom font for range in string
        if message.highlights.count > 0 {
            messageText.setAttributes([NSAttributedString.Key.font: UIFont.getSFProTextBold(size: 14)],range: NSMakeRange(message.highlights[0].offset, message.highlights[0].length))
        }
        
        return messageText
    }
}
