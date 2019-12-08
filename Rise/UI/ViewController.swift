//
//  ViewController.swift
//  Rise
//
//  Created by Владимир Королев on 09.12.2019.
//  Copyright © 2019 VladimirBrejcha. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    func showError(with message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title: "Ok", style: .cancel)
        alert.addAction(cancelAction)
        
        self.present(alert, animated: true)
    }
    
    func performSegue(withIdentifier typeIdentifier: UIViewController.Type, sender: Any?) {
        return performSegue(withIdentifier: String(describing: typeIdentifier), sender: sender)
    }
}
