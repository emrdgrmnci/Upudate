//
//  MainViewControllerBuilder.swift
//  Zappy
//
//  Created by Emre Değirmenci on 4.09.2020.
//  Copyright © 2020 Ali Emre Degirmenci. All rights reserved.
//

import UIKit

final class MainViewControllerBuilder {
    static func make() -> UINavigationController {
        let mainViewController = MainViewController()
        let nc = UINavigationController(rootViewController: mainViewController)
        let viewModel = MainViewModel()
        mainViewController.viewModel = viewModel
        return nc
    }
}
