//
//  MyGroupsTableViewController.swift
//  VK Client
//
//  Created by Мария Коханчик on 07.02.2021.
//

import UIKit
import RealmSwift
import FirebaseDatabase

class MyGroupsTableViewController: UITableViewController, UISearchBarDelegate {

    private var communitesFirebase = [FirebaseCommunity]()
    private let ref = Database.database().reference(withPath: "Users").child(String(Session.shared.userID!))
    
    var myCommunites = [Community]()
    var communites: Results<Community>?
    var token: NotificationToken?
    
    let networkService = NetworkManager()
    var realmManager = RealmManager()
    var imageService: ImageService?
    
    //@IBOutlet var searchBar: UISearchBar!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.register(UINib(nibName: "MyGroupsTableViewCell", bundle: nil), forCellReuseIdentifier: "GroupCell")
        //self.searchBar.delegate = self
        
        imageService = ImageService(container: tableView)
        
        realmManager.updateCommunites()
        pairTableAndRealm()
        
        ref.observe(.value, with: { snapshot in
            var communites: [FirebaseCommunity] = []
            
            for child in snapshot.children {
                if let snapshot = child as? DataSnapshot,
                   let group = FirebaseCommunity(snapshot: snapshot) {
                    communites.append(group)
                }
            }
            print("Обновлен список добавленных групп")
            communites.forEach { print($0.name) }
            print(communites.count)
        })
    }
    
    @IBAction func addGroup(segue: UIStoryboardSegue) {
        if segue.identifier == "addGroup" {
            let allCommunityController = segue.source as! AllGroupsTableViewController
            if let indexPath = allCommunityController.tableView.indexPathForSelectedRow {
                let community = allCommunityController.communites[indexPath.row]
                networkService.joinCommunity(id: community.id, onComplete: { (value) in
                    if value == 1 {
                        let fireCommunity = FirebaseCommunity(name: community.name, id: community.id)
                        let communityRef = self.ref.child(community.name.lowercased())
                        
                        communityRef.setValue(fireCommunity.toAnyObject())
                        
                        print("Запрос на вступление в группу отправлен")
                        DispatchQueue.main.asyncAfter(deadline: .now() + 10) {
                            self.realmManager.updateCommunites()
                        }
                    } else {
                        print("Запрос отклонён")
                    }
                }) { (error) in
                    print(error)
                }
            }
        }
    }
    
    func pairTableAndRealm() {
        guard let realm = try? Realm() else { return }
        communites = realm.objects(Community.self)
        token = communites?.observe { [weak self] (changes: RealmCollectionChange) in
            guard let tableView = self?.tableView else { return }
            switch changes {
            case .initial:
                tableView.reloadData()
            case .update(_, let deletions, let insertions, let modifications):
                tableView.beginUpdates()
                tableView.insertRows(at: insertions.map({ IndexPath(row: $0, section: 0) }),
                                     with: .automatic)
                tableView.deleteRows(at: deletions.map({ IndexPath(row: $0, section: 0)}),
                                     with: .automatic)
                tableView.reloadRows(at: modifications.map({ IndexPath(row: $0, section: 0) }),
                                     with: .automatic)
                tableView.endUpdates()
            case .error(let error):
                fatalError("\(error)")
            }
        }
    }
    
// MARK: - Table view data source

//    override func numberOfSections(in tableView: UITableView) -> Int {
//        return 1
//    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return communites?.count ?? 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "GroupCell", for: indexPath) as! MyGroupsTableViewCell
        
        guard let community = communites?[indexPath.row] else { return cell }
        
        cell.groupName.text = community.name
        cell.groupImageView.image = imageService?.photo(atIndexpath: indexPath, byUrl: community.avatarURL)
        
        return cell
    }

//    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
//        if editingStyle == .delete {
//            myCommunites.remove(at: indexPath.row)
//            tableView.deleteRows(at: [indexPath], with: .fade)
//        }
//    }

//    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
//        self.myCommunites = []
//
//        if searchText.count == 0 {
//            self.myCommunites = [Community]()
//        } else {
//            for group in [Community]() where group.name.lowercased().contains(searchText.lowercased()) {
//                self.myCommunites.append(group)
//            }
//        }
//        self.tableView.reloadData()
//    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
}
