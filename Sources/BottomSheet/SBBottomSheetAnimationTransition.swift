//
//  SBBottomSheetAnimationTransition.swift
//  SpasiboUIKit
//
//  Created by Vladislav Novoseltsev on 03.02.2022.
//  Copyright © 2021 SberSpasibo. All rights reserved.
//

import UIKit

final class SBBottomSheetAnimationTransition: NSObject, UIViewControllerAnimatedTransitioning {

// MARK: - Construction

    init(isPresenting: Bool) {
        self.isPresenting = isPresenting
    }

// MARK: - Methods

    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.3
    }

    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        if isPresenting {
            present(using: transitionContext)
        } else {
            dismiss(using: transitionContext)
        }
    }

    private func present(using transitionContext: UIViewControllerContextTransitioning) {
        let containerView = transitionContext.containerView
        guard
            let toViewController = transitionContext.viewController(forKey: .to) as? SBBottomSheetViewPresentable
        else {
            return
        }

        containerView.addSubview(toViewController.view)
        toViewController.view.layoutIfNeeded()
        toViewController.backgroundView.alpha = .zero
        toViewController.contentBottomConstraint.constant = toViewController.contentView.frame.height

        toViewController.view.layoutIfNeeded()
        let duration = transitionDuration(using: transitionContext)
        UIView.animate(
            withDuration: duration,
            delay: .zero,
            options: .curveLinear,
            animations: {
                toViewController.backgroundView.alpha = 1
                toViewController.contentBottomConstraint.constant = .zero
                toViewController.view.layoutIfNeeded()
            }, completion: { _ in
                transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
            }
        )

    }

    private func dismiss(using transitionContext: UIViewControllerContextTransitioning) {
        guard
            let fromViewController = transitionContext.viewController(forKey: .from) as? SBBottomSheetViewPresentable
        else {
            return
        }

        fromViewController.view.layoutIfNeeded()
        let duration = transitionDuration(using: transitionContext)
        UIView.animate(
            withDuration: duration,
            delay: .zero,
            options: .curveLinear,
            animations: {
                fromViewController.view.alpha = 1
                fromViewController.backgroundView.alpha = .zero
                fromViewController.contentBottomConstraint.constant = fromViewController.contentView.frame.height
                fromViewController.view.layoutIfNeeded()
            }, completion: { _ in
                if transitionContext.transitionWasCancelled {
                    fromViewController.contentBottomConstraint.constant = .zero
                    fromViewController.view.layoutIfNeeded()
                } else {
                    fromViewController.view.removeFromSuperview()
                }
                transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
            }
        )
    }

// MARK: - Variables

    private let isPresenting: Bool

}
