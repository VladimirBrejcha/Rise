//
//  ErrorView.swift
//  Rise
//
//  Created by Vladimir Korolev on 18.08.2020.
//  Copyright © 2020 VladimirBrejcha. All rights reserved.
//

import UIKit

final class ErrorView: UIView {
    struct Action {
        let title: String
        let action: (() -> Void)?
    }
    
    convenience init(title: String?, description: String?, actions: [ErrorView.Action]) {
        let width = UIScreen.main.bounds.width
        self.init(frame: CGRect(x: 0, y: 0, width: width, height: 400))
    }
}
