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
    public var currentSize: Int = 1
    
    open override var frame: CGRect {
        didSet {
            clipsToBounds = true
            setNeedsDisplay()
            
        }
    }
    
    var contentColor: UIColor = UIColor(red: 79 / 255, green: 156 / 255, blue: 213 / 255, alpha: 1)
    
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
