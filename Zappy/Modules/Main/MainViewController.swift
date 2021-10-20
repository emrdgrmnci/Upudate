//
//  MainViewController.swift
//  Zappy
//
//  Created by Emre Değirmenci on 4.09.2020.
//  Copyright © 2020 Ali Emre Degirmenci. All rights reserved.
//

import UIKit
import SnapKit
import GiphyUISDK
import GiphyCoreSDK
import SDWebImage
import Photos


final class MainViewController: UIViewController {
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
    private var emojis = [Emoji]()
    private let giphy = GiphyViewController()
    private let circularProgressBar = CircularProgressBar()

    private var gifImages: [UIImage] = []
    private var gifTimer: Timer?
    private var isSaveVideo = true
    private var isGIFAdded = false
    private var videoFileURL = URL(string: "")

    var indicator: UIActivityIndicatorView = UIActivityIndicatorView(style: .large)

    var viewModel: MainViewModelInterface! {
        didSet {
            viewModel.delegate = self
        }
    }

    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .systemGray2

        givenImageConstraints()
        collectionViewConstraints()


        collectionView.delegate = self
        collectionView.dataSource = self

        giphy.delegate = self
        giphy.mediaTypeConfig = [.gifs, .stickers, .text, .emoji]

        setupNavigation()

        viewModel.load()

        setupIndicator()
    }

    //MARK: - Setup Navigation
    private func setupNavigation() {
        self.setNavigationItem(name: "zappyIcon")
        //Save to PhotoLibrary
        navigationItem.rightBarButtonItems = [
            UIBarButtonItem(barButtonSystemItem: .save,
                            target: self,
                            action: #selector(fireTimer)),
            UIBarButtonItem(barButtonSystemItem: .undo,
                            target: self,
                            action: #selector(undoEmoji))]
        guard let rightBarButtonItems = navigationItem.rightBarButtonItems else { return }
        rightBarButtonItems[0].isEnabled = false
        rightBarButtonItems[1].isEnabled = false
        //Add Photo from camera or library
        navigationItem.leftBarButtonItems = [
            UIBarButtonItem(barButtonSystemItem: .add,
                             target: self,
                             action: #selector(addPhoto)),
            setupGIFBarButton()
        ]
        navigationItem.leftBarButtonItems?[0].tintColor = .systemGreen
        navigationItem.rightBarButtonItems?[0].tintColor = .systemOrange
        navigationItem.rightBarButtonItems?[1].tintColor = .systemPink
    }

    private func setupIndicator() {
        indicator.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
        indicator.center = view.center
        indicator.color = .orange
        self.view.addSubview(indicator)
        self.view.bringSubviewToFront(indicator)
    }

    private func setupGIFBarButton() -> UIBarButtonItem {
        let button = UIButton(type: UIButton.ButtonType.custom)
        button.setImage(UIImage(named: "gifIcon"), for: .normal)
        button.addTarget(self, action: #selector(addGiphy), for: .touchUpInside)
        button.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        let barButton = UIBarButtonItem(customView: button)
        self.navigationItem.leftBarButtonItems = [barButton]
        return barButton
    }
    //MARK: - touchesBegan
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let emojiView = touches.first?.view {
            parentView.bringSubviewToFront(emojiView)
        } else  if let gifView = touches.first?.view {
            parentView.bringSubviewToFront(gifView)
        }
    }

    //MARK: - PanGesture
    @objc func emojiDidMove(gestureRecognizer: UIPanGestureRecognizer) {
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

    //MARK: - PinchGesture
    @objc func emojiDidPinch(gestureRecognizer: UIPinchGestureRecognizer) {
        if gestureRecognizer.state == .began || gestureRecognizer.state == .changed {
            let currentScale: CGFloat = gestureRecognizer.view?.layer.value(forKeyPath: "transform.scale.x") as! CGFloat
            let minScale: CGFloat = 0.1
            let maxScale: CGFloat = 2.0
            let zoomSpeed: CGFloat = 0.5

            var deltaScale = gestureRecognizer.scale
            deltaScale = ((deltaScale - 1) * zoomSpeed) + 1
            deltaScale = min(deltaScale, maxScale / currentScale)
            deltaScale = max(deltaScale, minScale / currentScale)

            let zoomTransform = (gestureRecognizer.view?.transform)!.scaledBy(x: deltaScale, y: deltaScale)
            gestureRecognizer.view?.transform = zoomTransform
            gestureRecognizer.scale = 1
        }
    }

    //MARK: - RotateGesture
    @objc func emojiDidRotate(gestureRecognizer: UIRotationGestureRecognizer) {
        if gestureRecognizer.state == .began || gestureRecognizer.state == .changed {
            gestureRecognizer.view?.transform = (gestureRecognizer.view?.transform)!.rotated(by: gestureRecognizer.rotation)
            gestureRecognizer.rotation = 0
        }
    }

    //MARK: - Given Image Constraints
    private func givenImageConstraints() {
        view.addSubview(parentView)
        parentView.addSubview(givenImage)
        givenImage.image = UIImage(named: "example")
        givenImage.accessibilityLabel = "Example image"
        parentView.snp.makeConstraints { make in
            make.right.equalTo(view.snp.right).offset(0)
            make.left.equalTo(view.snp.left).offset(0)
            make.top.equalTo(view.snp.topMargin).offset(0)
            make.height.equalTo(480)
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
        collectionView.backgroundColor = .systemGray2
        collectionView.layer.cornerRadius = 20
        collectionView.snp.makeConstraints { make in
            make.right.equalTo(view.snp.right).offset(-20)
            make.left.equalTo(view.snp.left).offset(20)
            make.top.equalTo(givenImage.snp.bottom).offset(15)
            make.bottom.equalTo(view.snp.bottom).offset(-15)
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
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(emojiDidMove))
        let pinchGesture = UIPinchGestureRecognizer(target: self, action: #selector(emojiDidPinch))
        let rotationGesture = UIRotationGestureRecognizer(target: self, action: #selector(emojiDidRotate))
        panGesture.delegate = self
        pinchGesture.delegate = self
        rotationGesture.delegate = self
        imageView.addGestureRecognizer(panGesture)
        imageView.addGestureRecognizer(pinchGesture)
        imageView.addGestureRecognizer(rotationGesture)
        parentView.addSubview(imageView)
        guard let rightBarButtonItems = navigationItem.rightBarButtonItems else { return }
        rightBarButtonItems[1].isEnabled = true
    }

    //MARK: - CreateGifView
    private func createGifView(url: String?) {
        let x = CGFloat.random(in: 0...(parentView.frame.width - 80))
        let y = CGFloat.random(in: 0...(parentView.frame.height - 80))
        let imageView = SDAnimatedImageView(frame: CGRect(x: x, y: y, width: 120, height: 120))
        imageView.isUserInteractionEnabled = true
        if let url = url {
            imageView.sd_setImage(with: URL(string: url), completed: nil)
        }
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(emojiDidMove))
        let pinchGesture = UIPinchGestureRecognizer(target: self, action: #selector(emojiDidPinch))
        let rotationGesture = UIRotationGestureRecognizer(target: self, action: #selector(emojiDidRotate))
        panGesture.delegate = self
        pinchGesture.delegate = self
        rotationGesture.delegate = self
        imageView.addGestureRecognizer(panGesture)
        imageView.addGestureRecognizer(pinchGesture)
        imageView.addGestureRecognizer(rotationGesture)
        parentView.addSubview(imageView)
        guard let rightBarButtonItems = navigationItem.rightBarButtonItems else { return }
        rightBarButtonItems[0].isEnabled = true
        rightBarButtonItems[1].isEnabled = true
    }
}

// MARK: - UIImagePickerControllerDelegate
extension MainViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    //MARK: - AddFromPhotoLibrary
    @objc func addFromPhotoLibrary() {
        selectImageFrom(.photoLibrary)
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

    @objc func addGiphy() {
        present(giphy, animated: true, completion: nil)
    }

    //MARK: - UndoEmoji
    @objc func undoEmoji() {
        for view in parentView.subviews {
            if view == parentView.subviews.last {
                view.removeFromSuperview()
            }
            if parentView.subviews.count == 1 { // parentView.subviews.count == 1 = givenImage
                guard let rightBarButtonItems = navigationItem.rightBarButtonItems else { return }
                rightBarButtonItems[0].isEnabled = false
                rightBarButtonItems[1].isEnabled = false
            }
        }
    }

    @objc func fireTimer() {
        scheduledTimerWithTimeInterval()
    }

    private func scheduledTimerWithTimeInterval(){
        gifTimer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(saveEmojiAddedImage), userInfo: nil, repeats: true)
    }
    //MARK: - SaveEmojiAddedImage
    //Final Image
    @objc private func saveEmojiAddedImage() {
        UIGraphicsBeginImageContextWithOptions(parentView.frame.size, true, 0.0)
        parentView.drawHierarchy(in: parentView.bounds, afterScreenUpdates: true)
        guard let image = UIGraphicsGetImageFromCurrentImageContext() else { return }
        UIGraphicsEndImageContext()
        if isGIFAdded {
            self.gifImages.append(image)
            indicator.startAnimating()
            view.isUserInteractionEnabled = false
            print("Gif Images Count: \(gifImages.count)")
            if gifImages.count == 25 {
                self.stopTimer()
                indicator.stopAnimating()
                view.isUserInteractionEnabled = true
            }
        }
    }


    func stopTimer() {
        if gifTimer != nil {
            gifTimer!.invalidate()
            gifTimer = nil
            DispatchQueue.global(qos: .background).async {
                DispatchQueue.main.async {
                    self.createVideo()
                }
            }
        }
    }

    func createVideo()  {
        let settings = CXEImagesToVideo.videoSettings(codec: AVVideoCodecType.h264.rawValue, width: (gifImages[0].cgImage?.width)!, height: (gifImages[0].cgImage?.height)!)
        let movieMaker = CXEImagesToVideo(videoSettings: settings)
        movieMaker.createMovieFrom(images: gifImages){ (fileURL:URL) in
            if self.isSaveVideo {
                PHPhotoLibrary.shared().performChanges({
                    PHAssetChangeRequest.creationRequestForAssetFromVideo(atFileURL: fileURL)
                }) { saved, error in
                    self.gifImages.removeAll()
                    if saved {
                        self.gifImages.removeAll()
                        DispatchQueue.main.async {
                            self.presentAlert(withTitle: "Successful", message: "GIF saved successfully")
                        }
                    } else {
                        DispatchQueue.main.async {
                            self.presentAlert(withTitle: "Error", message: "")
                        }
                    }
                }
            } else {
                self.gifImages.removeAll()
                self.videoFileURL = fileURL
            }
        }
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
        let emoji = emojis[indexPath.row]
        createEmojiView(emoji: emoji)
    }
}

//MARK: - UICollectionViewDataSource
extension MainViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 80, height: 80)
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return emojis.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CollectionViewCell.cell.rawValue, for: indexPath) as! MainCollectionViewCell
        let emoji = emojis[indexPath.row]
        cell.configure(with: emoji)
        return cell
    }
}

//MARK: - MainViewModelDelegate
extension MainViewController: MainViewModelDelegate {
    func handleOutputs(_ output: MainViewModelOutputs) {
        switch output {
        case .showEmojis(let allEmojis):
            emojis = allEmojis
        }
    }
}

extension MainViewController: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return gestureRecognizer is UIRotationGestureRecognizer || gestureRecognizer is UIPinchGestureRecognizer
    }
}

extension MainViewController: GiphyDelegate {
    func didDismiss(controller: GiphyViewController?) {

    }

    func didSelectMedia(giphyViewController: GiphyViewController, media: GPHMedia) {
        let url = media.url(rendition: .fixedWidth, fileType: .gif)
        createGifView(url: url)
        isGIFAdded = true
    }
}
