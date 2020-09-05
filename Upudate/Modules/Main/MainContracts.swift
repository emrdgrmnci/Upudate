//
//  MainContracts.swift
//  Upudate
//
//  Created by Emre Değirmenci on 5.09.2020.
//  Copyright © 2020 Ali Emre Degirmenci. All rights reserved.
//

import Foundation

// View tarafından ViewModel'a göndermemiz gerekenler
protocol MainViewModelInterface: class {
    var delegate: MainViewModelDelegate? { get set }
    var emojiCount: Int { get }
    func emoji(index: Int) -> Emoji
}

// ViewModel ile işler yapınca View'u notify edeceğiz
// View bizim delegemiz
protocol MainViewModelDelegate: class {
    func notifyCollectionView()//CollectionView reload data
}

