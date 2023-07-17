//
//  Onboarding.swift
//  Rise
//
//  Created by Vladimir Korolev on 14.05.2022.
//  Copyright © 2022 VladimirBrejcha. All rights reserved.
//

import Localization
import CoreGraphics

enum Onboarding { }

extension Onboarding {
    
    static var defaultParams: Controller.Params {
        [
            .init(title: Text.Onboarding.Page1.title,
                  image: "hand.wave.fill",
                  animationTransform: CGAffineTransform(rotationAngle: (.pi / 6)),
                  description: Text.Onboarding.Page1.body),
            .init(title: Text.Onboarding.Page2.title,
                  image: "calendar",
                  animationTransform: CGAffineTransform(translationX: 0, y: 12),
                  description: Text.Onboarding.Page2.body),
            .init(title: Text.Onboarding.Page3.title,
                  image: "sun.dust.fill",
                  animationTransform: CGAffineTransform(scaleX: 1.15, y: 1.15),
                  description: Text.Onboarding.Page3.body),
            .init(title: Text.Onboarding.Page4.title,
                  image: "bird.fill",
                  animationTransform: CGAffineTransform(translationX: 0, y: 12),
                  description: Text.Onboarding.Page4.body),
            .init(title: Text.Onboarding.Page5.title,
                  image: "powersleep",
                  animationTransform: CGAffineTransform(translationX: 0, y: 12),
                  description: Text.Onboarding.Page5.body),
        ]
    }
}
