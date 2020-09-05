//
//  UIViewController+Extensions.swift
//  Upudate
//
//  Created by Emre Değirmenci on 5.09.2020.
//  Copyright © 2020 Ali Emre Degirmenci. All rights reserved.
//

import UIKit

extension UIViewController {
  func presentAlert(withTitle title: String, message : String) {
    let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
    let okAction = UIAlertAction(title: "OK", style: .default) { action in
    }
    alertController.addAction(okAction)
    self.present(alertController, animated: true, completion: nil)
  }
}

