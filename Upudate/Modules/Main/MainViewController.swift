//
//  MainViewController.swift
//  Upudate
//
//  Created by Emre Değirmenci on 4.09.2020.
//  Copyright © 2020 Ali Emre Degirmenci. All rights reserved.
//

import UIKit
import SnapKit

enum BarButtonTitle: String {
    case photoLibrary = "Photo Library"
    case camera = "Camera"
}

class MainViewController: UIViewController {

    lazy var box = UIImageView()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .red

        //        self.view.addSubview(box)
        //        box.backgroundColor = .green
        //        box.image = UIImage(named: "a")
        //        box.snp.makeConstraints { (make) -> Void in
        //            make.width.height.equalTo(50)
        //            make.center.equalTo(self.view)
        //        }
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: BarButtonTitle.photoLibrary.rawValue, style: .plain, target: self, action: #selector(addTapped))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: BarButtonTitle.camera.rawValue, style: .plain, target: self, action: #selector(addTapped))
    }

    @objc func addTapped() {
        print("bars tapped")
    }
}
