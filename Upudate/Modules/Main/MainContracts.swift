//
//  MainContracts.swift
//  Upudate
//
//  Created by Emre Değirmenci on 5.09.2020.
//  Copyright © 2020 Ali Emre Degirmenci. All rights reserved.
//

import Foundation

protocol MainViewModelInterface: class {
    var delegate: MainViewModelDelegate? { get set }
    func load()
}

protocol MainViewModelDelegate: class {
    func handleOutputs(_ output: MainViewModelOutputs)
}

enum MainViewModelOutputs {
    case showEmojis([Emoji])
}

extension MainViewModelOutputs: Equatable {
    static func == (lhs: MainViewModelOutputs, rhs: MainViewModelOutputs) -> Bool {
        switch (lhs, rhs) {
        case (.showEmojis(let a), .showEmojis(let b)):
            return a == b
        default:
            return false
        }
    }
}
