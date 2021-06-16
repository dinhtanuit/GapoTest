//
//  NotificationResponse.swift
//  GapoTest
//
//  Created by Tấn Tạ Đình on 11/06/2021.
//

import Foundation
import SwiftyJSON
class NotificationResponse {
    let id, type, title: String
    let message: Message
    let image: String
    let icon: String
    var status: StatusType
    let subscription: Subscription
    let readAt, createdAt, updatedAt, receivedAt: Int
    let imageThumb: String
    let animation, tracking, subjectName: String
    let isSubscribed: Bool
    
    init(json: JSON) {
        self.id = json["id"].stringValue
        self.type = json["type"].stringValue
        self.title = json["title"].stringValue
        self.message = Message.init(withJson: json["message"])
        self.image = json["iamge"].stringValue
        self.icon = json["icon"].stringValue
        self.status = StatusType.init(rawValue: json["status"].stringValue) ?? .unRead
        self.subscription = Subscription.init(withJson: json["subscription"])
        self.readAt = json["readAt"].intValue
        self.createdAt = json["createdAt"].intValue
        self.updatedAt = json["updatedAt"].intValue
        self.receivedAt = json["receivedAt"].intValue
        self.imageThumb = json["imageThumb"].stringValue
        self.animation = json["animation"].stringValue
        self.tracking = json["tracking"].stringValue
        self.subjectName = json["subjectName"].stringValue
        self.isSubscribed = json["isSubscribed"].boolValue
    }
    
    func updateStatus(status: StatusType) {
        self.status = status
    }
}

// MARK: - Message
struct Message: Codable {
    let text: String
    let highlights: [Highlight]
    
    init(withJson json: JSON) {
        self.text = json["text"].stringValue
        var arrHighlight = [Highlight]()
        for item in json["highlights"].arrayValue {
            let highlight = Highlight.init(withJson: item)
            arrHighlight.append(highlight)
        }
        self.highlights = arrHighlight
        
    }
}

// MARK: - Highlight
struct Highlight: Codable {
    let offset, length: Int
    init(withJson json: JSON) {
        self.offset = json["offset"].intValue
        self.length = json["length"].intValue
    }
}

// MARK: - Subscription
struct Subscription: Codable {
    let targetID, targetType, targetName: String
    let level: Int
    
    enum CodingKeys: String, CodingKey {
        case targetID = "targetId"
        case targetType, targetName, level
    }
    
    init(withJson json: JSON) {
        self.targetID = json["targetID"].stringValue
        self.targetType = json["targetType"].stringValue
        self.targetName = json["targetName"].stringValue
        self.level = json["level"].intValue
    }
}

enum StatusType: String {
    case unRead = "unread"
    case read = "read"
}
