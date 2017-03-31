//
//  Constants.swift
//  AmazingBubbles
//
//  Created by GlebRadchenko on 3/31/17.
//  Copyright © 2017 Gleb Rachenko. All rights reserved.
//

import Foundation

public struct BubbleConstants {
    public static var initialGravityStrength: CGFloat = 5
    public static var pushGravityStrength: CGFloat = 4
    public static var panGravityStrength: CGFloat = 7
    
    public static var minimalSizeForItem: CGSize = CGSize(width: 50, height: 50)
    public static var maximumSizeForItem: CGSize = CGSize(width: 150, height: 150)
    
    public static var growAnimationDuration: Double = 0.25
}
