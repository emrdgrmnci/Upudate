//
//  MainViewModel.swift
//  Zappy
//
//  Created by Emre Değirmenci on 5.09.2020.
//  Copyright © 2020 Ali Emre Degirmenci. All rights reserved.
//

import Foundation
import UIKit

class MainViewModel {
    weak var delegate: MainViewModelDelegate?
    var emojis = [
        Emoji(image: UIImage(named: "grinning")!, name: "grinning"),
        Emoji(image: UIImage(named: "happy")!, name: "happy"),
        Emoji(image: UIImage(named: "smile")!, name: "smile"),
        Emoji(image: UIImage(named: "angry")!, name: "angry"),
        Emoji(image: UIImage(named: "cool")!, name: "cool"),
        Emoji(image: UIImage(named: "pirate")!, name: "pirate")
    ]
}

extension MainViewModel: MainViewModelInterface {
    func load() {
        delegate?.handleOutputs(.showEmojis(emojis))
    }
}


