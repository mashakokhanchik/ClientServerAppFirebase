//
//  ServerError.swift
//  VK Client
//
//  Created by Мария Коханчик on 30.03.2021.
//

import Foundation

enum ServerError: Error {
    case noDataProvided
    case failedToDecode
    case errorTask
}
