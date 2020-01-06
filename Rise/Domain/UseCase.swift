//
//  UseCase.swift
//  Rise
//
//  Created by Владимир Королев on 05.01.2020.
//  Copyright © 2020 VladimirBrejcha. All rights reserved.
//

import Foundation

protocol UseCase {
    associatedtype InputValue
    associatedtype CompletionHandler
    associatedtype OutputValue
    
    func execute(_ requestValue: InputValue, completion: CompletionHandler) -> OutputValue
}
