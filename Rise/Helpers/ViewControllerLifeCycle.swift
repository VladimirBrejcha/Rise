//
//  ViewControllerLifeCycle.swift
//  Rise
//
//  Created by Владимир Королев on 09.12.2019.
//  Copyright © 2019-2020 VladimirBrejcha. All rights reserved.
//

import Foundation

protocol ViewControllerLifeCycle: AnyObject {
    func viewDidLoad()
    func viewWillAppear()
    func viewDidAppear()
    func viewWillDisappear()
}

extension ViewControllerLifeCycle {
    func viewDidLoad() { }
    func viewWillAppear() { }
    func viewDidAppear() { }
    func viewWillDisappear() { }
}
