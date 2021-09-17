//
//  ErrorViewAddable.swift
//  Rise
//
//  Created by Vladimir Korolev on 18.08.2020.
//  Copyright © 2020 VladimirBrejcha. All rights reserved.
//

import UIKit

protocol ErrorViewAddable: AnyObject, ErrorViewRemovable {
    func presentErrorView(from error: Error)
    var errorViewSuperview: UIView { get }
}

extension ErrorViewAddable where Self: ErrorViewCreatable {
    func presentErrorView(from error: Error) {
        removeErrorView()
        
        let errorView = makeErrorView(for: error)
        errorViewSuperview.addSubview(errorView)
        errorView.center = errorViewSuperview.center
    }
}
