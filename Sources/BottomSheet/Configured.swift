//
//  Configured.swift
//  SpasiboUIKit
//
//  Created by Vladislav Novoseltsev on 01.12.2021.
//  Copyright © 2021 SberSpasibo. All rights reserved.
//

public func configured<T: AnyObject>(
    object: T,
    closure: (_ object: T) -> Void
) -> T {
    closure(object)
    return object
}
