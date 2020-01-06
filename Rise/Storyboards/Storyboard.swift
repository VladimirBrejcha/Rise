//
//  Storyboard.swift
//  Rise
//
//  Created by Владимир Королев on 08.12.2019.
//  Copyright © 2019 VladimirBrejcha. All rights reserved.
//

import UIKit

struct Storyboard {
    static let main: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
    static let setupPlan: UIStoryboard = UIStoryboard(name: "SetupPlan", bundle: nil)
    static let settings: UIStoryboard = UIStoryboard(name: "Settings", bundle: nil)
    static let popUp: UIStoryboard = UIStoryboard(name: "ConfirmationPopUp", bundle: nil)
}

extension UIStoryboard {
    func instantiateViewController(withIdentifier typeIdentifier: UIViewController.Type) -> UIViewController {
        return instantiateViewController(withIdentifier: String(describing: typeIdentifier))
    }
    
    func instantiateViewController<Type: UIViewController>(of type: Type.Type) -> Type {
        return instantiateViewController(withIdentifier: String(describing: type)) as! Type
    }
}
