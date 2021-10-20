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
        Emoji(image: UIImage(named: "A")!, name: "A"),
        Emoji(image: UIImage(named: "Grinning")!, name: "Grinning"),
        Emoji(image: UIImage(named: "B")!, name: "B"),
        Emoji(image: UIImage(named: "happy")!, name: "happy"),
        Emoji(image: UIImage(named: "C")!, name: "C"),
        Emoji(image: UIImage(named: "smile")!, name: "smile"),
        Emoji(image: UIImage(named: "D")!, name: "D"),
        Emoji(image: UIImage(named: "angry")!, name: "angry"),
        Emoji(image: UIImage(named: "E")!, name: "E"),
        Emoji(image: UIImage(named: "cool")!, name: "cool"),
        Emoji(image: UIImage(named: "F")!, name: "F"),
        Emoji(image: UIImage(named: "pirate")!, name: "pirate"),
        Emoji(image: UIImage(named: "G")!, name: "G"),
        Emoji(image: UIImage(named: "H")!, name: "H"),
        Emoji(image: UIImage(named: "I")!, name: "I"),
        Emoji(image: UIImage(named: "J")!, name: "J"),
        Emoji(image: UIImage(named: "K")!, name: "K"),
        Emoji(image: UIImage(named: "L")!, name: "L"),
        Emoji(image: UIImage(named: "M")!, name: "M"),
        Emoji(image: UIImage(named: "N")!, name: "N"),
        Emoji(image: UIImage(named: "O")!, name: "O"),
        Emoji(image: UIImage(named: "P")!, name: "P"),
        Emoji(image: UIImage(named: "Q")!, name: "Q"),
        Emoji(image: UIImage(named: "R")!, name: "R"),
        Emoji(image: UIImage(named: "S")!, name: "S"),
        Emoji(image: UIImage(named: "T")!, name: "T"),
        Emoji(image: UIImage(named: "U")!, name: "U"),
        Emoji(image: UIImage(named: "V")!, name: "V"),
        Emoji(image: UIImage(named: "W")!, name: "W"),
        Emoji(image: UIImage(named: "X")!, name: "X"),
        Emoji(image: UIImage(named: "Y")!, name: "Y"),
        Emoji(image: UIImage(named: "Z")!, name: "Z")

    ]
}

extension MainViewModel: MainViewModelInterface {
    func load() {
        delegate?.handleOutputs(.showEmojis(emojis))
    }
}


