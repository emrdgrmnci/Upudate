//
//  MainViewController.swift
//  Upudate
//
//  Created by Emre Değirmenci on 4.09.2020.
//  Copyright © 2020 Ali Emre Degirmenci. All rights reserved.
//

import UIKit
import SnapKit

final class MainViewController: UIViewController, UIGestureRecognizerDelegate {
    fileprivate let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(MainCollectionViewCell.self, forCellWithReuseIdentifier: CollectionViewCell.cell.rawValue)
        return collectionView
    }()

    private var imagePicker: UIImagePickerController!
    lazy var givenImage = UIImageView()
    private var parentView = UIView()
    private var initialCenter = CGPoint()

    // ViewModel ve View arası data değişikliğini Observe et
    var viewModel: MainViewModelInterface! {
        didSet {
            //notify metotlarına ulaşıyoruz
            viewModel.delegate = self
        }
    }

    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        givenImageConstraints()
        collectionViewConstraints()

        collectionView.delegate = self
        collectionView.dataSource = self

        //Save to PhotoLibrary
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save,
                                                            target: self,
                                                            action: #selector(savePhoto))
        //Add Photo from camera or library
        navigationItem.leftBarButtonItem =
            UIBarButtonItem(barButtonSystemItem: .add,
                            target: self,
                            action: #selector(addPhoto))
    }

    //MARK: - AddGestures
    func addGestures(to stickerView: UIImageView) {
        let emojiPanGesture = UIPanGestureRecognizer(target: self, action: #selector(emojiDidMove))
        stickerView.addGestureRecognizer(emojiPanGesture)
        emojiPanGesture.delegate = self
    }

    //MARK: - PanGesture
    @objc func emojiDidMove(_ gestureRecognizer: UIPanGestureRecognizer) {
        guard let piece = gestureRecognizer.view else { return }
        let translation = gestureRecognizer.translation(in: piece.superview)
        if gestureRecognizer.state == .began {
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

    //MARK: - CreateEmojiView
    private func createEmojiView(emoji: Emoji) {
        let x = CGFloat.random(in: 0...(parentView.frame.width - 80))
        let y = CGFloat.random(in: 0...(parentView.frame.height - 80))
        let imageView = UIImageView(frame: CGRect(x: x, y: y, width: 80, height: 80))
        imageView.image = emoji.image
        imageView.isUserInteractionEnabled = true
        imageView.contentMode = .scaleAspectFit
        let gesture = UIPanGestureRecognizer(target: self, action: #selector(emojiDidMove(_:)))
        imageView.addGestureRecognizer(gesture)
        parentView.addSubview(imageView)
    }
}

// MARK: - UIImagePickerControllerDelegate
extension MainViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    //MARK: - AddFromPhotoLibrary
    @objc func addFromPhotoLibrary() {
        selectImageFrom(.photoLibrary)
    }

    //MARK: - SavePhoto
    @objc func savePhoto() {
        UIImageWriteToSavedPhotosAlbum(saveEmojiAddedImage(), self, #selector(image(_:didFinishSavingWithError:contextInfo:)), nil)
    }

    //MARK: - AddPhoto
    @objc func addPhoto() {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        let actionSheet = UIAlertController(title: ImageAlertTitle.photoSourceTitle.rawValue, message: ImageAlertTitle.photoSourceMessage.rawValue, preferredStyle: .actionSheet)
        actionSheet.addAction(UIAlertAction(title: ImageAlertTitle.cameraSourceTitle.rawValue, style: .default, handler: {(action: UIAlertAction) in
            if !UIImagePickerController.isSourceTypeAvailable(.camera) { //If device has no cam!
                self.presentAlert(withTitle: "", message: ImageAlertTitle.deviceHasNoCamera.rawValue)
            } else {
                self.selectImageFrom(.camera)
            }
        }))

        actionSheet.addAction(UIAlertAction(title: ImageAlertTitle.actionSheetPhotoLibraryTitle.rawValue, style: .default, handler: {(action: UIAlertAction) in
            imagePickerController.sourceType = .photoLibrary
            self.present(imagePickerController, animated: true, completion: nil)
        }))

        actionSheet.addAction(UIAlertAction(title: ImageAlertTitle.actionSheetCancelTitle.rawValue, style: .cancel, handler: nil))
        self.present(actionSheet, animated: true, completion: nil)
    }

    //MARK: - SaveEmojiAddedImage
    //Final Image
    private func saveEmojiAddedImage() -> UIImage {
        UIGraphicsBeginImageContext(parentView.frame.size)
        parentView.layer.render(in: UIGraphicsGetCurrentContext()!)
        guard let image = UIGraphicsGetImageFromCurrentImageContext() else { return UIImage(named: "smile")! }
        UIGraphicsEndImageContext()
        return image
    }

    //MARK: - Image Picker
    func selectImageFrom(_ source: ImageSource){
        imagePicker =  UIImagePickerController()
        imagePicker.delegate = self
        switch source {
        case .camera:
            imagePicker.sourceType = .camera
        case .photoLibrary:
            imagePicker.sourceType = .photoLibrary
        }
        present(imagePicker, animated: true, completion: nil)
    }

    //MARK: - DidFinishSavingWithError
    @objc func image(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        if let error = error {
            presentAlert(withTitle: ImageAlertTitle.imageSavingErrorTitle.rawValue, message: error.localizedDescription)
        } else {
            presentAlert(withTitle:  ImageAlertTitle.imageSavingSuccessTitle.rawValue, message: ImageAlertTitle.imageSavingSuccessMessage.rawValue)
        }
    }

    //MARK: - DidFinishPickingMediaWithInfo
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]){
        guard let selectedImage = info[.originalImage] as? UIImage else {
            presentAlert(withTitle: ImageAlertTitle.imagePickingErrorTitle.rawValue, message: ImageAlertTitle.imagePickingErrorMessage.rawValue)
            return
        }
        givenImage.image = selectedImage
        picker.dismiss(animated: true, completion: nil)
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}


//MARK: - UICollectionViewDelegate
extension MainViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let emoji = viewModel.emoji(index: indexPath.row)
        createEmojiView(emoji: emoji)
    }
}

//MARK: - UICollectionViewDataSource
extension MainViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 80, height: 80)
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.emojiCount
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CollectionViewCell.cell.rawValue, for: indexPath) as! MainCollectionViewCell
        let emoji = viewModel.emoji(index: indexPath.item)
        cell.configure(with: emoji)
        return cell
    }
}

//MARK: - MainViewModelDelegate
extension MainViewController: MainViewModelDelegate {
    func notifyCollectionView() {
        func notifyTableView() {
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }
    }
}
