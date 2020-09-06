//
//  UpudateTests.swift
//  UpudateTests
//
//  Created by Emre Değirmenci on 4.09.2020.
//  Copyright © 2020 Ali Emre Degirmenci. All rights reserved.
//

import XCTest
@testable import Upudate

class UpudateTests: XCTestCase {

    private var viewModel: MainViewModelInterface!
    private var view: MockView!

    override func setUpWithError() throws {
        viewModel = MainViewModel()
        view = MockView()
        viewModel.delegate = view
    }

    func testExample() throws {
        viewModel.load()
        //angry, cool, grinning ,happy, pirate, smile
        XCTAssertEqual(view.outputs.count, 1)
    }
}

private class MockView: MainViewModelDelegate {
    var outputs: [MainViewModelOutputs] = []
    func handleOutputs(_ output: MainViewModelOutputs) {
        outputs.append(output)
    }
}
