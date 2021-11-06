//
//  main.swift
//  Rise
//
//  Created by Vladimir Korolev on 21.10.2021.
//  Copyright © 2021 VladimirBrejcha. All rights reserved.
//

import UIKit

fileprivate let appDelegateClass: AnyClass = NSClassFromString("TestsAppDelegate") ?? AppDelegate.self

UIApplicationMain(
    CommandLine.argc,
    CommandLine.unsafeArgv,
    nil,
    NSStringFromClass(appDelegateClass)
)
