//
//  MainContracts.swift
//  Upudate
//
//  Created by Emre Değirmenci on 5.09.2020.
//  Copyright © 2020 Ali Emre Degirmenci. All rights reserved.
//

import Foundation

protocol MainViewModelProtocol {
    var delegate: MainViewModelDelegate? { get set }
    func load()
    func selectEmoji(at index: Int)
}

enum MainViewModelOutput: Equatable {
    case setLoading(Bool)
//    case showMovieList([MoviePresentation])
}

protocol MainViewModelDelegate: class {
    func handleViewModelOutput(_ output: MainViewModelOutput)
}
