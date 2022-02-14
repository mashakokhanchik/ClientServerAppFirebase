//
//  AvatarView.swift
//  VK Client
//
//  Created by Мария Коханчик on 14.02.2021.
//

import UIKit

@IBDesignable class AvatarView: UIView {

    @IBOutlet var imageView: UIImageView! {
        didSet {
            
            self.imageView.layer.cornerRadius = self.cornerRadius
            self.imageView.clipsToBounds = true
        }
    }

    @IBInspectable var cornerRadius: CGFloat = 0 {
        didSet {
            self.layer.cornerRadius = cornerRadius
        }
    }

    @IBInspectable var shadowOffset: CGSize = .zero {
        didSet {
            self.backgroundColor = .clear
            self.layer.shadowColor = UIColor.black.cgColor
            self.layer.shadowOpacity = 1
            self.layer.shadowRadius = 10
            self.layer.shadowOffset = shadowOffset
        }
    }

}
