//
//  Constants.swift
//  AmazingBubbles
//
//  Created by GlebRadchenko on 3/31/17.
//  Copyright © 2017 Gleb Rachenko. All rights reserved.
//

import Foundation

public struct BubbleConstants {
    public static var initialGravityStrength: CGFloat = 6
    public static var pushGravityStrength: CGFloat = 4
    public static var panGravityStrength: CGFloat = 20
    
    public static var minimalSizeForItem: CGSize = CGSize(width: 40, height: 40)
    public static var maximumSizeForItem: CGSize = CGSize(width: 100, height: 100)
    
    public static var growAnimationDuration: Double = 0.2
}
