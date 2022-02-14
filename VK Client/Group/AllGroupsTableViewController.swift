//
//  AllGroupsTableViewController.swift
//  VK Client
//
//  Created by Мария Коханчик on 07.02.2021.
//

import UIKit

class AllGroupsTableViewController: UITableViewController {

    var communites = [Community]()
    let networkService = NetworkManager()
    var imageService: ImageService?
    
    var searchController: UISearchController!
    var searchText = ""
    var isSearching = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.register(UINib(nibName: "AllGroupsTableViewCell", bundle: nil), forCellReuseIdentifier: "GroupCell")
        imageService = ImageService(container: tableView)
        configureSearchController()
        
    }

// MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return communites.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AllGroupCell", for: indexPath) as! AllGroupsTableViewCell
        
        let community = communites[indexPath.row]
        
        cell.groupName.text = community.name
        cell.groupImageView.image = imageService?.photo(atIndexpath: indexPath, byUrl: community.avatarURL)
        
        return cell
    }
}
    
extension AllGroupsTableViewController: UISearchResultsUpdating, UISearchBarDelegate {
        func updateSearchResults(for searchController: UISearchController) {
            guard let searchText = searchController.searchBar.text, !searchText.isEmpty else {
                return
            }
            if !isSearching {
                isSearching.toggle()
                networkService.getSearchCommunity(text: searchText, onComplete: { [weak self] (communites) in
                    self?.communites = communites
                    self?.tableView.reloadData()
                    self?.isSearching.toggle()
                }) { (error) in
                    self.isSearching.toggle()
                    print(error)
                }
            }
        }
        func  searchBarTextDidBeginEditing ( _  searchBar : UISearchBar) {
            communites.removeAll()
            tableView.reloadData()
        }
        func  searchBarCancelButtonClicked ( _  searchBar : UISearchBar) {
            communites.removeAll()
            tableView.reloadData()
        }
        
        func configureSearchController() {
            searchController = UISearchController(searchResultsController: nil)
            searchController.searchResultsUpdater = self
            searchController.searchBar.placeholder = "Search"
            searchController.searchBar.delegate = self
            searchController.searchBar.sizeToFit()
            tableView.tableHeaderView = searchController.searchBar
            
        }
}

