//
//  NotificationModel.swift
//  GapoTest
//
//  Created by DinhTan on 07/07/2021.
//

import Foundation
import DTMvvm
import ObjectMapper

enum NotificationStatusType: String {
    case unRead = "unread"
    case read = "read"
}

class NotificationNewResponse: Model {
    
    var data = [NotificationModel]()
    
    convenience init() {
        self.init(JSON: [String: Any]())!
    }
    
    override func mapping(map: Map) {
        data <- map["data"]
    }
}

class NotificationModel: Model {
    var id = ""
    var type = ""
    var title: String = ""
    var message = MessageModel()
    var image: String = ""
    var icon: String = ""
    var status: NotificationStatusType = .unRead
    var subscription = SubscriptionModel()
    var readAt = 0
    var createdAt = 0
    var updatedAt = 0
    var receivedAt = 0
    var imageThumb = ""
    var animation = ""
    var tracking = ""
    var subjectName = ""
    var isSubscribed: Bool = false
    
    convenience init() {
        self.init(JSON: [String: Any]())!
    }
    
    override func mapping(map: Map) {
        self.id <- map["id"]
        self.type <- map["type"]
        self.title <- map["type"]
        self.message <- map["message"]
        self.image <- map["image"]
        self.icon <- map["icon"]
        self.status <- (map["status"], NotificationStatusTransform())
        self.subscription <- map["subscription"]
        self.readAt <- map["readAt"]
        self.createdAt <- map["createdAt"]
        self.updatedAt <- map["updatedAt"]
        self.receivedAt <- map["receivedAt"]
        self.imageThumb <- map["imageThumb"]
        self.animation <- map["animation"]
        self.tracking <- map["tracking"]
        self.subjectName <- map["subjectName"]
        self.isSubscribed <- map["isSubscribed"]
        
    }
    
}

// MARK: - Message
class MessageModel: Model {
    var text: String = ""
    var highlights: [Highlight] = [Highlight]()
    
    convenience init() {
        self.init(JSON: [String: Any]())!
    }
    override func mapping(map: Map) {
        self.text <- map["text"]
        self.highlights <- map["highlights"]
    }
    
}

// MARK: - Highlight
class HighlightModel: Model {
    var offset = 0
    var length: Int = 0
    
    convenience init() {
        self.init(JSON: [String: Any]())!
    }
    
    override func mapping(map: Map) {
        self.offset <- map["offset"]
        self.length <- map["length"]
    }
}

// MARK: - Subscription
class SubscriptionModel: Model {
    var targetID = ""
    var targetType = ""
    var targetName: String = ""
    var level: Int = 0
    
    convenience init() {
        self.init(JSON: [String: Any]())!
    }
    
    override func mapping(map: Map) {
        self.targetID <- map["targetID"]
        self.targetType <- map["targetType"]
        self.targetName <- map["targetName"]
        self.level <- map["level"]
    }
    
}
