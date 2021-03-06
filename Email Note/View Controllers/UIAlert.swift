//
//  AlertDarkMode.swift
//  Email Note
//
//  Created by Blake Gordon on 12/12/18.
//  Copyright © 2018 Blake Gordon. All rights reserved.
//

import UIKit

extension UIViewController {
    /// Shorthand method for presenting UIAlertController
    /// - Parameters:
    ///   - title: Title of the UIAlertController
    ///   - message: Message to present in the UIAlertController
    ///   - actions: Any desired actions for the UIAlertController. Default is Ok button
    func presentAlert(title: String, message: String, actions: [UIAlertAction] = [UIAlertAction(title: "Ok", style: .default)]) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        for action in actions {
            alert.addAction(action)
        }
        self.present(alert, animated: true)
    }
}
