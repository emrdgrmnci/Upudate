//
//  CircularProgreeBar.swift
//  Zappy
//
//  Created by Emre Değirmenci on 17.02.2021.
//  Copyright © 2021 Ali Emre Degirmenci. All rights reserved.
//

import Foundation
import UIKit

class CircularProgressBar: UIView {
    let shapeLayer       = CAShapeLayer()
    let secondShapeLayer = CAShapeLayer()
    var circularPath: UIBezierPath?

    override init(frame: CGRect) {
        super.init(frame: frame)
        print("Frame: \(self.frame)")
        makeCircle()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        makeCircle()
    }

    func makeCircle(){
        let circularPath = UIBezierPath(arcCenter: .zero, radius: self.bounds.width / 2, startAngle: 0, endAngle: 2 * CGFloat.pi, clockwise: true)
        shapeLayer.path = circularPath.cgPath
        shapeLayer.strokeColor = UIColor.orange.cgColor//UIColor.init(red: 0.0/255.0, green: 0.0/255.0, blue: 0.0/255.0, alpha: 1.0).cgColor
        shapeLayer.lineWidth = 3.0
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.lineCap = CAShapeLayerLineCap.round
        shapeLayer.strokeEnd = 0
        shapeLayer.position = self.center
        shapeLayer.transform = CATransform3DRotate(CATransform3DIdentity, -CGFloat.pi / 2, 0, 0, 1)
        shapeLayer.frame =  CGRect(x:0, y: 0, width:50, height:50)
        self.layer.addSublayer(shapeLayer)
    }

    func showProgress(percent: Float){
        shapeLayer.strokeEnd = CGFloat(percent/100)
    }
}
