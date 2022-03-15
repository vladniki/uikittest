//
//  UIView+AddStretchedToBoundsSubview.swift
//  SpasiboUIKit
//
//  Created by Vladislav Novoseltsev on 03.02.2022.
//  Copyright © 2021 SberSpasibo. All rights reserved.
//

import UIKit

extension UIView {

    func addStretchedToBounds(
        subview: UIView,
        insets: UIEdgeInsets? = nil
    ) {
        subview.translatesAutoresizingMaskIntoConstraints = false
        addSubview(subview)
        let constants: UIEdgeInsets = insets ?? .zero

        NSLayoutConstraint.activate([
            subview.leadingAnchor.constraint(
                equalTo: leadingAnchor,
                constant: constants.left
            ),
            subview.topAnchor.constraint(
                equalTo: topAnchor,
                constant: constants.top
            ),
            trailingAnchor.constraint(
                equalTo: subview.trailingAnchor,
                constant: constants.right
            ),
            bottomAnchor.constraint(
                equalTo: subview.bottomAnchor,
                constant: constants.bottom
            ),
        ])
    }
}
