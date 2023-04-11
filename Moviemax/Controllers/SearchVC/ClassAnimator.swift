//
//  ClassAnimator.swift
//  Moviemax
//
//  Created by Aleksey Kosov on 11.04.2023.
//

import UIKit

class DismissAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.3
    }

    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let containerView = transitionContext.containerView
        let fromView = transitionContext.view(forKey: .from)!

        UIView.animate(withDuration: transitionDuration(using: transitionContext), animations: {
            fromView.frame.origin.y = containerView.bounds.height
        }, completion: { _ in
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        })
    }
}
