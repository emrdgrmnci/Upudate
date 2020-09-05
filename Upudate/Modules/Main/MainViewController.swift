//
//  MainViewController.swift
//  Upudate
//
//  Created by Emre Değirmenci on 4.09.2020.
//  Copyright © 2020 Ali Emre Degirmenci. All rights reserved.
//

import UIKit
import SnapKit

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
    lazy var emojiImage1 = UIImageView()
    lazy var emojiImage2 = UIImageView()
    lazy var emojiImage3 = UIImageView()
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
        emojiImage1Constraints()
        emojiImage2Constraints()
        emojiImage3Constraints()
        saveButtonConstraints()
        collectionViewConstraints()

        //        collectionView.delegate = self
        //        collectionView.dataSource = self

        //        emojiImage.isUserInteractionEnabled = true
    }

    //MARK: - Given Image Constraints
    private func givenImageConstraints() {
        self.view.addSubview(givenImage)
        givenImage.addSubview(emojiImage1)
        givenImage.addSubview(emojiImage2)
        givenImage.addSubview(emojiImage3)
        givenImage.image = UIImage(named: "example")
        givenImage.snp.makeConstraints { make in
            make.right.equalTo(self.view.snp.right).offset(-30)
            make.left.equalTo(self.view.snp.left).offset(30)
            make.top.equalTo(self.view).offset(80)
            make.bottom.equalTo(self.view).offset(-180)
            make.width.height.equalTo(300)
        }
    }

    //MARK: - Emoji Image1 Constraints
    private func emojiImage1Constraints() {
        emojiImage1.image = UIImage(named: "happy")
        emojiImage1.snp.makeConstraints { make in
            make.width.height.equalTo(80)
        }
    }

    //MARK: - Emoji Image2 Constraints
    private func emojiImage2Constraints() {
        emojiImage2.image = UIImage(named: "happy-2")
        emojiImage2.snp.makeConstraints { make in
            make.left.equalTo(90)
            make.width.height.equalTo(80)
        }
    }

    //MARK: - Emoji Image3 Constraints
    private func emojiImage3Constraints() {
        emojiImage3.image = UIImage(named: "smile")
        emojiImage3.snp.makeConstraints { make in
            make.left.equalTo(200)
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

    //MARK: -  CollectionView Constraints
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
