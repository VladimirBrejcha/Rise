//
//  StoryAssembler.swift
//  Rise
//
//  Created by Владимир Королев on 06.01.2020.
//  Copyright © 2020 VladimirBrejcha. All rights reserved.
//

protocol StoryAssembler {
    associatedtype View
    
    func assemble() -> View
}
