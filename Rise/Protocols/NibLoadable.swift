//
//  NibLoadable.swift
//  Rise
//
//  Created by Владимир Королев on 10.10.2019.
//  Copyright © 2019-2020 VladimirBrejcha. All rights reserved.
//

import UIKit

protocol NibLoadable where Self: UIView {
    static var nibName: String { get }
}

extension NibLoadable {
    static var nibName: String { String(describing: Self.self) }
    static var nib: UINib { UINib(nibName: Self.nibName, bundle: Bundle(for: Self.self)) }

    func setupFromNib() {
        guard let view = Self.nib.instantiate(withOwner: self, options: nil).first as? UIView
            else { fatalError("Error loading \(self) from nib") }
        addSubview(view)
        view.frame = bounds
    }
}
