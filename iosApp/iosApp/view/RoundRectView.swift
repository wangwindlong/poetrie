//
//  RoundRectView.swift
//  iosApp
//
//  Created by 王云龙 on 2023/11/19.
//  Copyright © 2023 orgName. All rights reserved.
//

import Foundation
import UIKit

class RoundRectView: UIView {
    private let shapeLayer = CAShapeLayer()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        // Set up the shape layer
        shapeLayer.lineWidth = 2
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.strokeColor = UIColor.magenta.cgColor
        layer.addSublayer(shapeLayer)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        // Update the shape layer path
        let path = UIBezierPath(roundedRect: bounds.insetBy(dx: 5.0, dy: 5.0), cornerRadius: 7.0)
        path.usesEvenOddFillRule = true
        shapeLayer.path = path.cgPath
    }
}
