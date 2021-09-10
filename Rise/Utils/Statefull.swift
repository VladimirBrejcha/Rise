//
//  Statefull.swift
//  Rise
//
//  Created by Vladimir Korolev on 22.02.2021.
//  Copyright © 2021 VladimirBrejcha. All rights reserved.
//

protocol Statefull {
    associatedtype State
    var state: State? { get }
    func setState(_ state: State)
}
