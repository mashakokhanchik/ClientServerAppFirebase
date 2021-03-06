//
//  MyFriendsTableViewController.swift
//  VK Client
//
//  Created by Мария Коханчик on 07.02.2021.
//

import UIKit
import RealmSwift
import SDWebImage

class MyFriendsTableViewController: UITableViewController, UISearchBarDelegate {

    //private var headers = [String]()

    let networkService = NetworkManager()
    let realmManager = RealmManager()
    var token: NotificationToken?
    var imageService: ImageService?

    var data = [Friend]()
    var friends: Results<Friend>?
    var friendsDict = [Character:[Friend]]()
    var firstLetters: [Character] {
        get {
            friendsDict.keys.sorted()
        }
    }

    private var lettersControl: LettersControl?
    private let searchController = UISearchController(searchResultsController: nil)
    private var searchBarIsEmpty: Bool {
        guard let text = searchController.searchBar.text else {
            return false
        }
        return text.isEmpty
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableView.register(UINib(nibName: "MyFriendsTableViewCell", bundle: nil), forCellReuseIdentifier: "FriendCell")
//        self.tableView.register(UINib(nibName: "HeaderMyFriends", bundle: nil), forHeaderFooterViewReuseIdentifier: "Header")

        tableView.dataSource = self

        realmManager.updateFriends()
        pairTableAndRealm()

        imageService = ImageService(container: tableView)
        setSearchController()

    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }

    func pairTableAndRealm() {
        guard let realm = try? Realm() else { return }
        friends = realm.objects(Friend.self)
        token = friends?.observe { [weak self] (changes: RealmCollectionChange) in
            switch changes {
            case .initial:
                self?.setFriends()
            case .update(_, _, _ , _):
                self?.setFriends()
            case .error(let error):
                fatalError("\(error)")
            }
        }
    }

    private func setFriends(){
        guard let friends = self.friends else { return }
        let tmpFriends = friends.filter{ !$0.lastName.isEmpty }
        self.data = Array(tmpFriends)
        self.friendsDict = self.getSortedUsers(searchText: nil, list: Array(tmpFriends))
        self.tableView.reloadData()
        self.setLettersControl()
    }

    private func getSortedUsers(searchText: String? , list: [Friend]) -> [Character:[Friend]]{
        var tempUsers: [Friend]
        if let text = searchText?.lowercased(), searchText != "" {
            tempUsers = list.filter{ $0.lastName.lowercased().contains(text) || $0.firstName.lowercased().contains(text) }
        } else {
            tempUsers = list
        }
        let sortedUsers = Dictionary.init(grouping: tempUsers) { $0.lastName.lowercased().first ?? "#" }
            .mapValues{ $0.sorted{ $0.lastName.lowercased() < $1.lastName.lowercased() } }
        return sortedUsers
    }

    private func setSearchController() {
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search"
        navigationItem.searchController = searchController
        definesPresentationContext = true

    }

    private func setLettersControl(){
        lettersControl = LettersControl()
        guard let lettersControl = lettersControl else {
            return
        }
        view.addSubview(lettersControl)

        lettersControl.translatesAutoresizingMaskIntoConstraints = false
        lettersControl.arrChar = friendsDict.keys.sorted()
        lettersControl.backgroundColor = .clear
        lettersControl.addTarget(self, action: #selector(scrollToSelectedLetter), for: [.touchUpInside])

        NSLayoutConstraint.activate([
            lettersControl.heightAnchor.constraint(equalToConstant: CGFloat(15*lettersControl.arrChar.count)),
            lettersControl.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            lettersControl.widthAnchor.constraint(equalToConstant: 20),
            lettersControl.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])

    }

    @objc func scrollToSelectedLetter(){
        guard let lettersControl = lettersControl else {
            return
        }
        let selectLetter = lettersControl.selectedLetter
        for indexSextion in 0..<firstLetters.count{
            if selectLetter == firstLetters[indexSextion]{
                tableView.scrollToRow(at: IndexPath(row: 0, section: indexSextion), at: .top, animated: true)
                break
            }
        }
    }

// MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return friendsDict.keys.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard !firstLetters.isEmpty else { return 0 }
        let key = firstLetters[section]
        return friendsDict[key]?.count ?? 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: "FriendCell", for: indexPath) as! MyFriendsTableViewCell

        
        
        let key = firstLetters[indexPath.section]
        let friendsForKey = friendsDict[key]
        guard let friend = friendsForKey?[indexPath.row] else { return cell }
        
        let i = friend.avatarURL

        cell.friendName.text = friend.firstName + " " + friend.lastName
        cell.avatarURL.sd_setImage(with: URL(string: i))
    
        //cell.avatarURL.image = imageService?.photo(atIndexpath: indexPath, byUrl: friend.avatarURL)

        return cell
    }

// MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showCollection" {
            if let indexPath = self.tableView.indexPathForSelectedRow {
                let controller = segue.destination as! PhotoCollectionViewController
                let users = friendsDict[firstLetters[indexPath.section]]
                guard let user = users?[indexPath.row] else { return }

                controller.userID = user.id
                controller.title = user.firstName + " " + user.lastName
            }
        }
    }

}
extension MyFriendsTableViewController: UISearchResultsUpdating{
    func updateSearchResults(for searchController: UISearchController) {
        filterFriendForSearchText(searchController.searchBar.text!)
    }

    private func filterFriendForSearchText(_ searchText: String){
        friendsDict = self.getSortedUsers(searchText: searchText, list: data)

        if searchText == "" {
            lettersControl?.isHidden = false
        }else{
            lettersControl?.isHidden = true
        }
        tableView.reloadData()
    }
}

