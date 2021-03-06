//
//  NewsView.swift
//  VK Client
//
//  Created by Мария Коханчик on 19.04.2021.
//

import UIKit

class NewsView: UIView {
    var newsTableView = NewsTableView()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        
        addSubview(newsTableView)
        
        newsTableView.translatesAutoresizingMaskIntoConstraints = false
        newsTableView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        newsTableView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        newsTableView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        newsTableView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
    }
    
    func setNews(news: [News]) {
        self.newsTableView.news = news
    }
    
}

class NewsTableView: UITableView {
    
    var news = [News]()
    var imageServise: ImageService?
    
    init(){
        super.init(frame: .zero, style: .grouped)
        delegate = self
        dataSource = self
        
        rowHeight = UITableView.automaticDimension
        estimatedRowHeight = UITableView.automaticDimension
        imageServise = ImageService(container: self)
        
        backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        register(NewsTableViewCell.self, forCellReuseIdentifier: NewsTableViewCell.reusedID)
        translatesAutoresizingMaskIntoConstraints = false
        showsVerticalScrollIndicator = false
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func loadImeges(indexPath: IndexPath, urls: [String]) -> [UIImage]?{
        var images = [UIImage]()
        for url in urls {
            if let image = self.imageServise?.photo(atIndexpath: indexPath, byUrl: url) {
                images.append(image)
            }
        }
        return images
    }
    
}

extension NewsTableView: UITableViewDelegate {

}

extension NewsTableView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return news.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = dequeueReusableCell(withIdentifier: NewsTableViewCell.reusedID, for: indexPath) as! NewsTableViewCell

        let post = news[indexPath.row]

        //cell.dateLabel.text
        cell.titleLabel.text = post.text
        //cell.likeControl.likeButton
        
//        guard let photosURL = post.photosURL else {return cell}
        
//        cell.photoView.photos = self.loadImeges(indexPath: indexPath, urls: photosURL)
        

        return cell
    }
    
    
}
