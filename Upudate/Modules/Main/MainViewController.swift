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

enum ImageSource {
    case photoLibrary
    case camera
}

class MainViewController: UIViewController, UINavigationControllerDelegate {

    fileprivate let collectionView:UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.register(MainCollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        return cv
    }()

    var imagePicker: UIImagePickerController!
    lazy var givenImage = UIImageView()
    lazy var emojiImage = UIImageView()
    lazy var saveButton = UIButton()

    fileprivate var selectedRow = -1

    fileprivate let data = [
        Data(emoji: #imageLiteral(resourceName: "happy")),
        Data(emoji: #imageLiteral(resourceName: "happy-2")),
        Data(emoji: #imageLiteral(resourceName: "smile"))
    ]



    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .red
        givenImageConstraints()
        emojiImageConstraints()
        saveButtonConstraints()
        collectionViewConstraints()

        //        collectionView.delegate = self
        //        collectionView.dataSource = self

//        emojiImage.isUserInteractionEnabled = true
    }

    //MARK: - Given Image Constraints
    private func givenImageConstraints() {
        self.view.addSubview(givenImage)
        givenImage.addSubview(emojiImage)
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

    //MARK: - Emoji Image Constraints
    private func emojiImageConstraints() {
        emojiImage.backgroundColor = .green
        emojiImage.image = UIImage(named: "happy-2")
        emojiImage.snp.makeConstraints { make in
            make.width.height.equalTo(80)
        }
    }

    //MARK: -  Save Button Constraints
    private func saveButtonConstraints() {
        self.view.addSubview(saveButton)
        saveButton.backgroundColor = .blue
        saveButton.setTitle("Save", for: .normal)
        saveButton.snp.makeConstraints { make in
            make.right.equalTo(self.view.snp.right).offset(-30)
            make.left.equalTo(self.view.snp.left).offset(30)
            make.bottom.equalTo(self.givenImage).offset(80)
            make.width.height.equalTo(50)
        }
    }

    private func collectionViewConstraints() {
        view.addSubview(collectionView)
        collectionView.backgroundColor = .white
        collectionView.snp.makeConstraints { make in
            make.right.equalTo(self.view.snp.right).offset(-30)
            make.left.equalTo(self.view.snp.left).offset(30)
            make.bottom.equalTo(self.saveButton).offset(90)
            make.width.height.equalTo(80)
        }
    }
}
