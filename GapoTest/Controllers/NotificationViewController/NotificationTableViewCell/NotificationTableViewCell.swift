//
//  NotificationTableViewCell.swift
//  GapoTest
//
//  Created by Tấn Tạ Đình on 13/06/2021.
//

import UIKit

protocol NotificationTableViewCellDelegate: NSObject {
    func touchUpInButtonMore()
}

class NotificationTableViewCell: UITableViewCell {
    
    @IBOutlet weak var viewContent: UIView!
    @IBOutlet weak var viewAvatar: UIView!
    @IBOutlet weak var lblMessage: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var btnMore: UIButton!
    @IBOutlet weak var imageAvatar: UIImageView!
    @IBOutlet weak var imageIcon: UIImageView!
    weak var delegateCell: NotificationTableViewCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.imageAvatar.layer.cornerRadius = self.imageAvatar.frame.height/2
        self.imageAvatar.clipsToBounds = true
        self.imageIcon.layer.cornerRadius = self.imageIcon.frame.height/2
        self.imageIcon.clipsToBounds = true
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    func setupData(noti: NotificationResponse) {
        self.imageAvatar.setImageWithURL(noti.imageThumb)
        self.imageIcon.setImageWithURL(noti.icon)
        self.lblMessage.attributedText = self.getAttributedString(message: noti.message)
        self.lblDate.text = String.getDate(withTime: noti.createdAt)
        if noti.status == .read {
            self.viewContent.backgroundColor = .green
        } else {
            self.viewContent.backgroundColor = .white
        }
    }
    
    func getAttributedString(message: Message) -> NSMutableAttributedString {
        let messageText = NSMutableAttributedString.init(string: message.text)
        
        // set the custom font for range in string
        if message.highlights.count > 0 {
            messageText.setAttributes([NSAttributedString.Key.font: UIFont.getSFProTextBold(size: 14)],range: NSMakeRange(message.highlights[0].offset, message.highlights[0].length))
        }
        return messageText
    }
    
    @IBAction func actionTapMoreButton(_ sender: Any) {
        self.delegateCell?.touchUpInButtonMore()
    }
}
