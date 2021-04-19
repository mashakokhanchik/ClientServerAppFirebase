//
//  Response.swift
//  VK Client
//
//  Created by Мария Коханчик on 30.03.2021.
//

import Foundation

class Response<T: Codable>: Codable {
    let response: Items<T>
}
class Items<T: Codable>: Codable {
    let items: [T]
}

class ResponseJoin: Codable {
    let response: Int
}
