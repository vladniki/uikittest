//
//  SBBottomSheetViewController.swift
//  SpasiboUIKit
//
//  Created by Vladislav Novoseltsev on 03.02.2022.
//  Copyright © 2021 SberSpasibo. All rights reserved.
//

import UIKit

protocol SBBottomSheetViewPresentable: UIViewController {
    var backgroundView: UIView { get }
    var contentView: UIView { get }
    var contentBottomConstraint: NSLayoutConstraint { get }
}

public class SBBottomSheetViewController: UIViewController, SBBottomSheetViewPresentable {

// MARK: - Public UI

    lazy var backgroundView = configured(object: UIView()) { object in
        object.translatesAutoresizingMaskIntoConstraints = false
        object.backgroundColor = UIColor.black.withAlphaComponent(Constants.alpha)
        object.addGestureRecognizer(
            UITapGestureRecognizer(
                target: self,
                action: #selector(close)
            )
        )
    }

    lazy var contentView = configured(object: UIView()) { object in
        object.translatesAutoresizingMaskIntoConstraints = false
        object.backgroundColor = .white
        object.layer.cornerRadius = Constants.cornerRadius
        object.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        object.addGestureRecognizer(
            UIPanGestureRecognizer(
                target: self,
                action: #selector(panGesture(_:))
            )
        )
        object.clipsToBounds = true
    }

    var contentBottomConstraint = NSLayoutConstraint()

    public var backgroundColor: UIColor? {
        get { backgroundView.backgroundColor }
        set { backgroundView.backgroundColor = newValue }
    }

// MARK: - Lifecycles

    public init(child: UIViewController) {
        self.childVC = child
        self.childView = nil
        super.init(nibName: nil, bundle: nil)
        commonInit()
    }

    public init(view childView: UIView) {
        self.childVC = nil
        self.childView = childView
        super.init(nibName: nil, bundle: nil)
        commonInit()
    }

    private func commonInit() {
        transitioningDelegate = transitionDelegate
        modalPresentationStyle = .custom
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

// MARK: - Private methods
    
    private func setupUI() {
        view.backgroundColor = .clear
        view.addStretchedToBounds(subview: backgroundView)
        view.addSubview(contentView)

        if let childVC = childVC {
            addChild(childVC)
            childVC.didMove(toParent: self)
        }

        let childView = childVC?.view ?? childView ?? UIView()
        childView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(childView)

        if UIApplication.shared.keyWindow?.safeAreaInsets.bottom == .zero {
            additionalSafeAreaInsets.bottom = Constants.additionalSafeAreaInsetsBottom
            viewSafeAreaInsetsDidChange()
        }

        contentBottomConstraint = contentView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        NSLayoutConstraint.activate([
            contentView.topAnchor.constraint(greaterThanOrEqualTo: view.layoutMarginsGuide.topAnchor ),
            contentView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            contentBottomConstraint,

            childView.topAnchor.constraint(equalTo: view.topAnchor),
            childView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            childView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            childView.bottomAnchor.constraint(equalTo: contentView.layoutMarginsGuide.bottomAnchor),
        ])
    }

// MARK: - Handlers

    @objc private func close() {
        transitionDelegate.isDismissInteractive = false
        dismiss(animated: true, completion: nil)
    }

    @objc private func panGesture(_ gesture: UIPanGestureRecognizer) {
        switch gesture.state {
        case .began:
            transitionDelegate.isDismissInteractive = true
            dismiss(animated: true, completion: nil)

        case .changed:
            let dy = gesture.translation(in: view).y
            guard dy > .zero else { return }
            let percent = dy / max(
                Constants.minHeight,
                contentView.frame.height
            )
            transitionDelegate.interactiveTransition.update(percent)

        case .ended:
            let velocity = gesture.velocity(in: gesture.view)
            let dy = gesture.translation(in: view).y
            if dy > Constants.deltaY || velocity.y > Constants.maxY {
                transitionDelegate.interactiveTransition.finish()
            } else {
                transitionDelegate.interactiveTransition.cancel()
            }
            transitionDelegate.isDismissInteractive = false

        default:
            transitionDelegate.interactiveTransition.cancel()
            transitionDelegate.isDismissInteractive = false
        }
    }

// MARK: - Constants

    private enum Constants {
        static let deltaY: CGFloat = 100
        static let maxY: CGFloat = 500
        static let minHeight: CGFloat = 1

        static let cornerRadius: CGFloat = 32
        static let alpha: CGFloat = 0.6

        static let additionalSafeAreaInsetsBottom: CGFloat = 12
    }

// MARK: - Variables

    private let transitionDelegate = SBBottomSheetTransitionDelegate()
    private let childVC: UIViewController?
    private let childView: UIView?
}
