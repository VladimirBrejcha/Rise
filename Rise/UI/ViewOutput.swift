//
//  Viewoutput.swift
//  Rise
//
//  Created by Владимир Королев on 09.12.2019.
//  Copyright © 2019 VladimirBrejcha. All rights reserved.
//

import Foundation

protocol ViewOutput: AnyObject {
    func viewDidLoad()
    func viewWillAppear()
    func viewDidAppear()
    func viewWillDisappear()
}

extension ViewOutput {
    func viewDidLoad() { }
    func viewWillAppear() { }
    func viewDidAppear() { }
    func viewWillDisappear() { }
}
