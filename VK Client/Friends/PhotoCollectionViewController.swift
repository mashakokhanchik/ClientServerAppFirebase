//
//  PhotoCollectionViewController.swift
//  VK Client
//
//  Created by Мария Коханчик on 07.02.2021.
//

import UIKit
import RealmSwift
import SDWebImage

class PhotoCollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {

    var photos = [Photo]()
    //var data: Friend!
    var userID: Int?
    var needUpdate: Bool = true

    let networkService = NetworkManager()
    let realmManager = RealmManager()
    var imageService: ImageService?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.collectionView.register(UINib(nibName: "PhotoCollectionViewCell", bundle: .none), forCellWithReuseIdentifier: "PhotoCell")
        self.collectionView.delegate = self

        self.setPhotos()

        NotificationCenter.default.addObserver(self,
                                               selector: #selector(setPhotos),
                                               name: RealmNotification.photosUpdate.name(),
                                               object: nil)
    }

    @objc private func setPhotos(){
        let photosRealm = realmManager.getPhotos(for: userID, update: needUpdate)
        needUpdate = false
        guard let photos = photosRealm else { return }
        self.photos = photos
        self.collectionView.reloadData()
    }

// MARK: UICollectionViewDataSource

//    override func numberOfSections(in collectionView: UICollectionView) -> Int {
//        return 1
//    }
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photos.count//photos.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotoCell", for: indexPath) as! PhotoCollectionViewCell

        guard let photoURL = photos[indexPath.item].sizes.last?.url else { return cell }
        
        cell.photo.sd_setImage(with: URL(string: photoURL))

        //cell.photo.image = imageService?.photo(atIndexpath: indexPath, byUrl: photoURL)

        return cell
    }

    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.collectionView.deselectItem(at: indexPath, animated: true)
        showPresenter(photos: photos, selectedPhoto: indexPath.item)
    }
//
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        return CGSize(width: 150, height: 150)
//    }
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
//        return 10
//    }
//
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
//        return 10
//    }

// MARK: UICollectionViewDelegate

//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//
//        return CGSize(width: Constants.galleryItemWidth, height: Constants.galleryItemWidth)
//    }

    func showPresenter(photos: [Photo], selectedPhoto: Int){
        let presentViewController = PresenterPhoto()
        presentViewController.photos = photos
        presentViewController.selectedPhoto = selectedPhoto
        presentViewController.modalPresentationStyle = .automatic
        presentViewController.modalTransitionStyle = .coverVertical
        navigationController?.pushViewController(presentViewController, animated: true)
    }
}

//struct Constants {
//    static let leftDistanceToView: CGFloat = 20
//    static let rightDistanceToView: CGFloat = 20
//    static let topDistanceToView: CGFloat = 20
//    static let galleryMinimumLineSpacing: CGFloat = 10
//    static let galleryItemWidth = (UIScreen.main.bounds.width - Constants.leftDistanceToView - Constants.rightDistanceToView - Constants.galleryMinimumLineSpacing) / 2
//}
