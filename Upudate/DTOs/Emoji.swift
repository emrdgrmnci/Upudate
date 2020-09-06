//
//  Emoji.swift
//  Upudate
//
//  Created by Emre Değirmenci on 4.09.2020.
//  Copyright © 2020 Ali Emre Degirmenci. All rights reserved.
//

import UIKit

struct Emoji: Equatable {
    var image: UIImage
    var name: String
}

extension Emoji {
    static func fake() -> Emoji {
        return self.init(image: UIImage(named: "angry")!, name: "angry")
    }
}
