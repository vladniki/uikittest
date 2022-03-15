//
//  SBBottomSheetTransitionDelegate.swift
//  SpasiboUIKit
//
//  Created by Vladislav Novoseltsev on 03.02.2022.
//  Copyright © 2021 SberSpasibo. All rights reserved.
//

import UIKit

final class SBBottomSheetTransitionDelegate: NSObject, UIViewControllerTransitioningDelegate {

    var isDismissInteractive = false
    let interactiveTransition: UIPercentDrivenInteractiveTransition = {
        let it = UIPercentDrivenInteractiveTransition()
        it.completionSpeed = 1
        it.completionCurve = .linear
        return it
    }()

    func animationController(
        forPresented presented: UIViewController,
        presenting: UIViewController,
        source: UIViewController
    ) -> UIViewControllerAnimatedTransitioning? {
        return SBBottomSheetAnimationTransition(isPresenting: true)
    }

    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return SBBottomSheetAnimationTransition(isPresenting: false)
    }

    func interactionControllerForDismissal(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return isDismissInteractive ? interactiveTransition : nil
    }
}
