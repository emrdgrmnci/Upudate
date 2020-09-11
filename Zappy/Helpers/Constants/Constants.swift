//
//  Constants.swift
//  Zappy
//
//  Created by Emre Değirmenci on 6.09.2020.
//  Copyright © 2020 Ali Emre Degirmenci. All rights reserved.
//

import Foundation

enum BarButtonTitle: String {
    case save = "Save"
}

enum ImageSource {
    case photoLibrary
    case camera
}

enum ImageAlertTitle: String {
    case photoSourceTitle = "Photo Source"
    case photoSourceMessage = "Choose a Source"
    case cameraSourceTitle = "Camera"
    case actionSheetPhotoLibraryTitle = "Photo Library"
    case actionSheetCancelTitle = "Cancel"
    case imageSavingErrorTitle = "Error"
    case imageSavingSuccessTitle = "Saved!"
    case imageSavingSuccessMessage = "Image saved successfully"
    case imagePickingErrorTitle = "Error!"
    case imagePickingErrorMessage = "Image not found!"
    case deviceHasNoCamera = "Device has no camera."
}

enum CollectionViewCell: String {
    case cell = "cell"
}
