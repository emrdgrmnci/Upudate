//
//  UIViewController+.swift
//  Zappy
//
//  Created by Emre Değirmenci on 15.01.2021.
//  Copyright © 2021 Ali Emre Degirmenci. All rights reserved.
//

import UIKit.UIImageView
import UIKit.UIImage
import UIKit.UIBarButtonItem

extension UIViewController {
    func setNavigationItem(name: String) {
        let imageView = UIImageView(image: UIImage(named: name))
        self.navigationItem.titleView = imageView
    }
}
