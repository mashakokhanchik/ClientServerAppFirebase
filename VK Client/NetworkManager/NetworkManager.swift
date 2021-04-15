//
//  NetworkManager.swift
//  VK Client
//
//  Created by Мария Коханчик on 20.03.2021.
//

import Foundation

class NetworkManager {
    
    var urlConstructor = URLComponents()
    let constants = NetworkConstants()
    let configuration: URLSessionConfiguration!
    let session: URLSession!
    
    init(){
        urlConstructor.scheme = "https"
        urlConstructor.host = "api.vk.com"
        configuration = URLSessionConfiguration.default
        session = URLSession(configuration: configuration)
    }
    
    func  getAuthorizeRequest() -> URLRequest? {
        urlConstructor.host = "oauth.vk.com"
        urlConstructor.path = "/authorize"
        
        urlConstructor.queryItems = [
            URLQueryItem(name: "client_id", value: constants.clientID),
            URLQueryItem(name: "scope", value: constants.scope),
            URLQueryItem(name: "display", value: "mobile"),
            URLQueryItem(name: "redirect_uri", value: "https://oauth.vk.com/blank.html"),
            URLQueryItem(name: "response_type", value: "token"),
            URLQueryItem(name: "v", value: constants.versionAPI)
        ]
        
        guard let url = urlConstructor.url else { return nil }
        let request = URLRequest(url: url)
        return request
    }
    
    func getFriends(onComplete: @escaping ([Friend]) -> Void, onError: @escaping (Error) -> Void) {
        urlConstructor.path = "/method/friends.get"
        
        urlConstructor.queryItems = [
            URLQueryItem(name: "order", value: "name"),
            URLQueryItem(name: "fields", value: "sex, bdate, city, country, photo_100, photo_200_orig"),
            URLQueryItem(name: "access_token", value: Session.shared.token),
            URLQueryItem(name: "v", value: constants.versionAPI),
        ]
        let task = session.dataTask(with: urlConstructor.url!) { (data, response, error) in
            
            if error != nil {
                onError(ServerError.errorTask)
            }
            
            guard let data = data else {
                onError(ServerError.noDataProvided)
                return
            }
            guard let friends = try? JSONDecoder().decode(Response<Friend>.self, from: data).response.items else {
                onError(ServerError.failedToDecode)
                return
            }
            DispatchQueue.main.async {
                onComplete(friends)
            }
        }
        task.resume()
        
    }
    
    func getPhoto(for ownerID: Int?, onComplete: @escaping ([Photo]) -> Void, onError: @escaping (Error) -> Void) {
        
        
        urlConstructor.path = "/method/photos.getAll"
        
        guard let owner = ownerID else { return }
        
        urlConstructor.queryItems = [
            URLQueryItem(name: "owner_id", value: String(owner)),
            URLQueryItem(name: "photo_sizes", value: "1"),
            URLQueryItem(name: "extended", value: "1"),
            URLQueryItem(name: "count", value: "20"),
            URLQueryItem(name: "access_token", value: Session.shared.token),
            URLQueryItem(name: "v", value: constants.versionAPI),
        ]
        let task = session.dataTask(with: urlConstructor.url!) { (data, response, error) in

            if error != nil {
                onError(ServerError.errorTask)
            }
            
            guard let data = data else {
                onError(ServerError.noDataProvided)
                return
            }
            guard let photos = try? JSONDecoder().decode(Response<Photo>.self, from: data).response.items else {
                onError(ServerError.failedToDecode)
                return
            }
            DispatchQueue.main.async {
                onComplete(photos)
            }
        }
        task.resume()
        
    }
    
    func getCommunity(onComplete: @escaping ([Community]) -> Void, onError: @escaping (Error) -> Void) {
        urlConstructor.path = "/method/groups.get"
        
        urlConstructor.queryItems = [
            URLQueryItem(name: "extended", value: "1"),
            URLQueryItem(name: "fields", value: "description"),
            URLQueryItem(name: "access_token", value: Session.shared.token),
            URLQueryItem(name: "v", value: constants.versionAPI),
        ]
        let task = session.dataTask(with: urlConstructor.url!) { (data, response, error) in
            
            if error != nil {
                onError(ServerError.errorTask)
            }
            
            guard let data = data else {
                onError(ServerError.noDataProvided)
                return
            }
            guard let communities = try? JSONDecoder().decode(Response<Community>.self, from: data).response.items else {
                onError(ServerError.failedToDecode)
                return
            }
            DispatchQueue.main.async {
                onComplete(communities)
            }
        }
        task.resume()
    }
    
    func getSearchCommunity(text: String?, onComplete: @escaping ([Community]) -> Void, onError: @escaping (Error) -> Void) {
        urlConstructor.path = "/method/groups.search"
        
        urlConstructor.queryItems = [
            URLQueryItem(name: "q", value: text),
            URLQueryItem(name: "access_token", value: Session.shared.token),
            URLQueryItem(name: "v", value: constants.versionAPI),
        ]
        let task = session.dataTask(with: urlConstructor.url!) { (data, response, error) in
            
            if error != nil {
                onError(ServerError.errorTask)
            }
            
            guard let data = data else {
                onError(ServerError.noDataProvided)
                return
            }
            guard let communities = try? JSONDecoder().decode(Response<Community>.self, from: data).response.items else {
                onError(ServerError.failedToDecode)
                return
            }
            DispatchQueue.main.async {
                onComplete(communities)
            }
        }
        task.resume()
    }
    
    func joinCommunity(id: Int, onComplete: @escaping (Int) -> Void, onError: @escaping (Error) -> Void) {
        urlConstructor.path = "/method/groups.join"
        
        urlConstructor.queryItems = [
            URLQueryItem(name: "group_id", value: String(id)),
            URLQueryItem(name: "access_token", value: Session.shared.token),
            URLQueryItem(name: "v", value: constants.versionAPI),
        ]
        let task = session.dataTask(with: urlConstructor.url!) { (data, response, error) in
            
            if error != nil {
                onError(ServerError.errorTask)
            }
            
            guard let data = data else {
                onError(ServerError.noDataProvided)
                return
            }
            guard let response = try? JSONDecoder().decode(ResponseJoin.self, from: data) else {
                onError(ServerError.failedToDecode)
                return
            }
            DispatchQueue.main.async {
                onComplete(response.response)
            }
        }
        task.resume()
    }
}
