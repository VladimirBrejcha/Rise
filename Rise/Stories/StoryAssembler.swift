//
//  StoryAssembler.swift
//  Rise
//
//  Created by Владимир Королев on 06.01.2020.
//  Copyright © 2020 VladimirBrejcha. All rights reserved.
//

import Foundation

protocol StoryAssembler {
    associatedtype View
    associatedtype ViewInput
    associatedtype ViewOutput
    
    func assemble() -> View
    func assemble(view: ViewInput) -> ViewOutput
}