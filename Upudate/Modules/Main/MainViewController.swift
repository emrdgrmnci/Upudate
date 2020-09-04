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

    lazy var givenImage = UIImageView()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .red
        givenImageConstraints()

        navigationItem.leftBarButtonItem = UIBarButtonItem(title: BarButtonTitle.photoLibrary.rawValue, style: .plain, target: self, action: #selector(addTapped))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: BarButtonTitle.camera.rawValue, style: .plain, target: self, action: #selector(addTapped))
    }

    //MARK: - Given Image Constraints
    private func givenImageConstraints() {
        self.view.addSubview(givenImage)
        givenImage.backgroundColor = .green
        givenImage.image = UIImage(named: "happy")
        givenImage.snp.makeConstraints { make in
            make.right.equalTo(self.view.snp.right).offset(-30)
            make.left.equalTo(self.view.snp.left).offset(30)
            make.top.equalTo(self.view).offset(80)
            make.bottom.equalTo(self.view).offset(-180)
            make.width.height.equalTo(300)
        }
    }

    @objc func addTapped() {
        print("bars tapped")
    }
}
