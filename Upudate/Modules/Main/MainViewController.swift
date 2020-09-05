//
//  MainViewController.swift
//  Upudate
//
//  Created by Emre Değirmenci on 4.09.2020.
//  Copyright © 2020 Ali Emre Degirmenci. All rights reserved.
//

import UIKit
import SnapKit

class MainViewController: UIViewController, UIGestureRecognizerDelegate {
    fileprivate let collectionView:UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.register(MainCollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        return cv
    }()

    private var imagePicker: UIImagePickerController!
    lazy var givenImage = UIImageView()
    private var parentView = UIView()
    private var initialCenter = CGPoint()

    fileprivate var selectedRow = -1

    fileprivate let emojis = [
        Emoji(image: UIImage(named: "grinning")!, name: "grinning"),
        Emoji(image: UIImage(named: "happy")!, name: "happy"),
        Emoji(image: UIImage(named: "smile")!, name: "smile"),
        Emoji(image: UIImage(named: "angry")!, name: "angry"),
        Emoji(image: UIImage(named: "cool")!, name: "cool"),
        Emoji(image: UIImage(named: "pirate")!, name: "pirate")
    ]

    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        givenImageConstraints()
        collectionViewConstraints()

        collectionView.reloadData()
        collectionView.delegate = self
        collectionView.dataSource = self

        //
        //        //Camera
        //        navigationItem.rightBarButtonItem = UIBarButtonItem(title: BarButtonTitle.camera.rawValue, style: .plain, target: self, action: #selector(takePhoto))

        //        saveButton.addTarget(self, action: #selector(savePhoto), for: .touchUpInside)
    }

    //MARK: - AddGestures
    func addGestures(to stickerView: UIImageView) {
        let stickerPanGesture = UIPanGestureRecognizer(target: self, action: #selector(stickerDidMove))
        stickerView.addGestureRecognizer(stickerPanGesture)
        stickerPanGesture.delegate = self
    }

    @objc func saveImage() {

    }

    //MARK: - PanGesture
    @objc func stickerDidMove(_ gestureRecognizer: UIPanGestureRecognizer) {
        guard gestureRecognizer.view != nil else {return}
        let piece = gestureRecognizer.view!
        // Get the changes in the X and Y directions relative to
        // the superview's coordinate space.
        let translation = gestureRecognizer.translation(in: piece.superview)
        if gestureRecognizer.state == .began {
            // Save the view's original position.
            self.initialCenter = piece.center
        }
        // Update the position for the .began, .changed, and .ended states
        if gestureRecognizer.state != .cancelled {
            // Add the X and Y translation to the view's original position.
            let newCenter = CGPoint(x: initialCenter.x + translation.x, y: initialCenter.y + translation.y)
            if(newCenter.x - 40 > 0 && newCenter.y - 40 > 0 && newCenter.x + 40 < parentView.frame.width && newCenter.y + 40 < parentView.frame.height) {
                piece.center = newCenter
            }

        }
        else {
            // On cancellation, return the piece to its original location.
            piece.center = initialCenter
        }
    }

    //MARK: - Given Image Constraints
    private func givenImageConstraints() {
        view.addSubview(parentView)
        parentView.addSubview(givenImage)
        givenImage.image = UIImage(named: "example")
        parentView.snp.makeConstraints { make in
            make.right.equalTo(view.snp.right).offset(-30)
            make.left.equalTo(view.snp.left).offset(30)
            make.top.equalTo(view.snp.topMargin).offset(15)
            make.height.equalTo(450)
        }

        givenImage.snp.makeConstraints { make in
            make.right.equalTo(parentView.snp.right)
            make.left.equalTo(parentView.snp.left)
            make.top.equalTo(parentView.snp.top)
            make.bottom.equalTo(parentView.snp.bottom)
        }
    }

    //MARK: -  CollectionView Constraints
    private func collectionViewConstraints() {
        view.addSubview(collectionView)
        collectionView.backgroundColor = .white
        collectionView.layer.cornerRadius = 20
        collectionView.snp.makeConstraints { make in
            make.right.equalTo(self.view.snp.right).offset(-30)
            make.left.equalTo(self.view.snp.left).offset(30)
            make.top.equalTo(self.givenImage.snp.bottom).offset(15)
            make.height.equalTo(80)
        }
    }

    private func createEmojiView(emoji: Emoji) {
        let x = CGFloat.random(in: 0...(parentView.frame.width - 80))
        let y = CGFloat.random(in: 0...(parentView.frame.height - 80))
        let imageView = UIImageView(frame: CGRect(x: x, y: y, width: 80, height: 80))
        imageView.image = emoji.image
        imageView.isUserInteractionEnabled = true
        imageView.contentMode = .scaleAspectFit
        let gesture = UIPanGestureRecognizer(target: self, action: #selector(stickerDidMove(_:)))
        imageView.addGestureRecognizer(gesture)
        parentView.addSubview(imageView)
    }

}

//MARK: - UICollectionViewDelegate
extension MainViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let emoji = emojis[indexPath.row]
        createEmojiView(emoji: emoji)
    }
}

//MARK: - UICollectionViewDataSource
//TODO: - Contractor yapısı kurmaya çalış
extension MainViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 80, height: 80)
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return emojis.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! MainCollectionViewCell
        cell.data = self.emojis[indexPath.item]
        return cell
    }
}


