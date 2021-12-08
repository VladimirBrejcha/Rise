//
//  BackgroundView.swift
//  Rise
//
//  Created by Vladimir Korolev on 21.11.2021.
//  Copyright © 2021 VladimirBrejcha. All rights reserved.
//

import UIKit

extension View {
    enum Background {
        case `default`
        case rich

        var asUIView: UIView {
            let view = UIImageView()
            view.image = {
                switch self {
                case .default:
                    return Asset.Background.default.image
                case .rich:
                    return Asset.Background.rich.image
                }
            }()
            view.contentMode = .scaleAspectFill
            return view
        }
    }
}
