//
//  ViewInput.swift
//  Rise
//
//  Created by Владимир Королев on 09.12.2019.
//  Copyright © 2019 VladimirBrejcha. All rights reserved.
//

import Foundation

protocol ViewInput: AnyObject {
    func performSegue(withIdentifier: String, sender: Any?)
    func showError(with message: String)
}
