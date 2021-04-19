//
//  CurrentSession.swift
//  VK Client
//
//  Created by Мария Коханчик on 16.03.2021.
//

import Foundation

class Session {
    static var shared = Session()
    
    var token: String?
    var userID: Int?
    
    private init() {}
}
