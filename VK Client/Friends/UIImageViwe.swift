//
//  UIImageViwe.swift
//  VK Client
//
//  Created by Мария Коханчик on 30.03.2021.
//

import UIKit

extension UIImageView {
    
    func loadImage(by imageURL: String) {
        guard let url = URL(string: imageURL) else { return }
        
        let cache = URLCache.shared
        let request = URLRequest(url: url)
        
        if let imageDate = cache.cachedResponse(for: request)?.data {
            self.image = UIImage(data: imageDate)
        } else {
            URLSession.shared.dataTask(with: request) { (data, response, _ ) in
                guard let data = data, let response = response else {
                    return
                }
                let cacheResponse = CachedURLResponse(response: response, data: data)
                cache.storeCachedResponse(cacheResponse, for: request)
                DispatchQueue.main.async {
                    self.image = UIImage(data: data)
                }
                
            }.resume()
        }
    }
}
