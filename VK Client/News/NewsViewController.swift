//
//  NewsViewController.swift
//  VK Client
//
//  Created by Мария Коханчик on 19.04.2021.
//

import UIKit

class NewsViewController: UIViewController {
    
    let networkService = NetworkManager()
    
    override func loadView() {
        super.loadView()
        self.view = NewsView()

    }
    override func viewDidLoad() {
        super.viewDidLoad()

        networkService.getNews(onComplete: { (news) in
            self.view().newsTableView.news = news
            self.view().newsTableView.reloadData()
        }) { (error) in
            print(error)
        }
        title = "News"
        

    }
    
    func view() -> NewsView {
        return self.view as! NewsView
    }
    
}



