//
//  Community.swift
//  VK Client
//
//  Created by Мария Коханчик on 30.03.2021.
//

import UIKit
import RealmSwift

class Community: Object, Codable {
    @objc dynamic var id: Int = 0
    @objc dynamic var name: String = ""
    @objc dynamic var avatarURL: String = ""
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case avatarURL = "photo_50"
    }
    override static func primaryKey() -> String? {
        return "id"
    }
    
    override static func indexedProperties() -> [String] {
        return ["name"]
    }
}
