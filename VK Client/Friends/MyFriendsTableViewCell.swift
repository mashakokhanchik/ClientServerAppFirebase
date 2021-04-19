//
//  MyFriendsTableViewCell.swift
//  VK Client
//
//  Created by Мария Коханчик on 07.02.2021.
//

import UIKit

class MyFriendsTableViewCell: UITableViewCell {

    @IBOutlet weak var friendName: UILabel!
    @IBOutlet weak var avatarURL: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.avatarURL.layer.cornerRadius = avatarURL.frame.width / 2
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    @IBAction func avatarButton(_ sender: Any) {
        self.avatarURL.transform = CGAffineTransform(scaleX: 0.01, y: 0.01)
                    UIView.animate(withDuration: 1.2,
                                   delay: 0.0,
                                   usingSpringWithDamping: 02,
                                   initialSpringVelocity: 0.2,
                                   options: .curveEaseOut,
                                   animations: {
                                    self.avatarURL.transform = CGAffineTransform(scaleX: 1, y: 1)
                                   },
                                   completion: nil)
    }
}





