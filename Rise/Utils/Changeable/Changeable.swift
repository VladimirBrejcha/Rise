//
//  Changeable.swift
//  Rise
//
//  Created by Vladimir Korolev on 13.08.2020.
//  Copyright © 2020 VladimirBrejcha. All rights reserved.
//

protocol Changeable {
    init(copy: ChangeableWrapper<Self>)
}

extension Changeable {
    func changing(_ change: (inout ChangeableWrapper<Self>) -> Void) -> Self {
        var copy = ChangeableWrapper<Self>(self)
        change(&copy)
        return Self(copy: copy)
    }
}
