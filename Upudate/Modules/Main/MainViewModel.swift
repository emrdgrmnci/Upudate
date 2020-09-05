//
//  MainViewModel.swift
//  Upudate
//
//  Created by Emre Değirmenci on 5.09.2020.
//  Copyright © 2020 Ali Emre Degirmenci. All rights reserved.
//

import Foundation

class MainViewModel {
    weak var delegate: MainViewModelDelegate?

    var emojis: [Emoji]

    init() {
        self.emojis = []
    }
}

extension MainViewModel: MainViewModelInterface {
    var emojiCount: Int {
        return 10
    }
}


