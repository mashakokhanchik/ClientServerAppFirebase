//
//  InteractiveManager.swift
//  VK Client
//
//  Created by Мария Коханчик on 23.02.2021.
//

import UIKit

class InteractiveManager: UIPercentDrivenInteractiveTransition {
    var interactionInProgress = false
    var shouldCompleteTransition = false
    
    var viewController: UIViewController! {
        didSet {
            let gesture = UIScreenEdgePanGestureRecognizer(target: self, action: #selector(handleGesture(_:)))
            gesture.edges = .left
            viewController?.view.addGestureRecognizer(gesture)
        }
    }
    
    @objc func handleGesture(_ gestureRecognizer: UIScreenEdgePanGestureRecognizer) {
        switch gestureRecognizer.state {
        case .began:
            interactionInProgress = true
            viewController.navigationController?.popViewController(animated: true)
        case .changed:
            let translation = gestureRecognizer.translation(in: gestureRecognizer.view)
            let relativeTranslation = abs(translation.x) / 50
            let progress = max(0, min(1, relativeTranslation))
            
            shouldCompleteTransition = progress > 0.35
            update(progress)
        case .cancelled:
            interactionInProgress = false
            cancel()
        case .ended:
            interactionInProgress = false
            shouldCompleteTransition ? finish() : cancel()
        default:
            break
        }
    }
}
