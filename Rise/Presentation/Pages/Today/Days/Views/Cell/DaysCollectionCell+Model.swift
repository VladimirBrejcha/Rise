//
//  DaysCollectionCell+Model.swift
//  Rise
//
//  Created by Vladimir Korolev on 18.09.2021.
//  Copyright © 2021 VladimirBrejcha. All rights reserved.
//

import UIKit
import DataLayer

extension Days.CollectionCell {

    struct Model: Hashable, Identifiable {

        typealias LeftRightTuple<T> = (left: T, right: T)
        typealias LeftMiddleRightTuple<T> = (left: T, middle: T, right: T)

        struct Identifier: Equatable, Hashable {

            enum Kind {
                case sun
                case schedule
            }
            let kind: Kind
            let day: Days.Controller.NoonedDay
        }

        enum State: Hashable {
            case loading
            case showingInfo (info: String)
            case showingError (error: String)
            case showingContent (left: String, right: String)
        }

        let state: State
        let image: LeftRightTuple<UIImage>
        let title: LeftMiddleRightTuple<String>
        let id: Identifier

        static func == (lhs: Model, rhs: Model) -> Bool {
            lhs.id == rhs.id && lhs.state == rhs.state
        }

        func hash(into hasher: inout Hasher) {
            hasher.combine(id)
        }
    }
}
