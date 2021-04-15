//
//  PhotoCollectionViewCell.swift
//  VK Client
//
//  Created by Мария Коханчик on 07.02.2021.
//

import UIKit

class PhotoCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet var photo: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        
        layer.borderColor = UIColor.blue.cgColor
        layer.borderWidth = 0.5
        layer.cornerRadius = 25      
    }
}
