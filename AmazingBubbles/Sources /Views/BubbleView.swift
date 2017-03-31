//
//  BubbleView.swift
//  AmazingBubbles
//
//  Created by GlebRadchenko on 3/31/17.
//  Copyright © 2017 Gleb Rachenko. All rights reserved.
//

import UIKit

open class BubbleView: UIView {
    internal var tapGestureRecognizer: UITapGestureRecognizer?
    internal var currentSize: Int = 1
    
    open override var frame: CGRect {
        didSet {
            setNeedsDisplay()
        }
    }
    
    var contentColor: UIColor = .red
    
    open override func draw(_ rect: CGRect) {
        let circleRect = rect.insetBy(dx: 1, dy: 1)
        let path = UIBezierPath(ovalIn: circleRect)
        contentColor.setFill()
        path.fill()
    }
    
    open override var collisionBoundsType: UIDynamicItemCollisionBoundsType {
        return .ellipse
    }
}
