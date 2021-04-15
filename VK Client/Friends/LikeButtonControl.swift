//
//  LikeButtonControl.swift
//  VK Client
//
//  Created by Мария Коханчик on 09.02.2021.
//

import UIKit

class LikeButtonControl: UIControl {
    
    var liked = 0
    
    private var likeColor: UIColor = UIColor.red
    private var disLikeColor: UIColor = UIColor.black
    
    var likeButton: UIButton = UIButton(type: .system)
    var likeCount: UILabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.setupView()
    }
    
    private func setupView() {
        self.likeButton.setImage(UIImage(systemName: "heart"), for: .normal)
        self.likeButton.setImage(UIImage(systemName: "heart.fill"), for: .selected)
        self.likeButton.tintColor = .red
        
        self.likeButton.addTarget(self, action: #selector(iLike(_:)), for: .touchUpInside)
    
        self.likeCount.text = "\(liked)"
        self.likeCount.font = self.likeCount.font.withSize(20)
        
        self.addSubview(self.likeButton)
        self.addSubview(self.likeCount)
        
        self.likeButton.translatesAutoresizingMaskIntoConstraints = false
        self.likeButton.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        self.likeButton.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        self.likeButton.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        
        self.likeCount.translatesAutoresizingMaskIntoConstraints = false
        self.likeCount.leadingAnchor.constraint(equalTo: self.likeButton.trailingAnchor, constant: 10).isActive = true
        self.likeCount.centerYAnchor.constraint(equalTo: self.likeButton.centerYAnchor).isActive = true
        self.likeCount.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 20).isActive = true
    }
    
    @objc private func iLike(_ sender: UIButton) {
        let view = !self.likeButton.isSelected
        self.likeButton.isSelected = view
        
        if view {
            self.liked += 1
            animate(completion: self.setupView)
        } else {
            self.liked -= 1
        }
        
        self.likeCount.text = "\(liked)"
        self.likeCount.textColor = view && self.liked > 0 ? self.likeColor : self.disLikeColor
    }
    
    private let animationRepeatDuration: CFTimeInterval = 2.0
    private let rotationAnimatonKey: String = "rotationAnimation"

    func animate(completion: @escaping () -> Void) {
            CATransaction.begin()
            CATransaction.setCompletionBlock { [weak self] in
                guard
                    let rotationAnimatonKey = self?.rotationAnimatonKey,
                    self?.likeButton.layer.animation(forKey: rotationAnimatonKey) != nil
                    else {
                    completion()
                    return
                }
            }
            let rotation: CABasicAnimation = CABasicAnimation(keyPath: "transform.rotation.y")
            rotation.toValue = NSNumber(value: Double.pi * 2)
            rotation.repeatCount = Float.greatestFiniteMagnitude
            rotation.repeatDuration = animationRepeatDuration
            likeButton.layer.add(rotation, forKey: rotationAnimatonKey)
            
            CATransaction.commit()
    }
    
}



