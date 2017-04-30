//
//  Extension.swift
//  WorldMap
//
//  Created by NiteshTak on 30/4/17.
//  Copyright © 2017 NiteshTak. All rights reserved.
//

import UIKit

extension UIColor {
    
    static func withRGB(red: Int, green: Int, blue: Int) -> UIColor {
        return UIColor(red: CGFloat(red)/255, green: CGFloat(green)/255, blue: CGFloat(blue)/255, alpha: 1)
    }
}

extension CGRect {
    init(_ x:CGFloat, _ y:CGFloat, _ w:CGFloat, _ h:CGFloat) {
        self.init(x:x, y:y, width:w, height:h)
    }
}

extension CGPoint{
    init(_ x:CGFloat,_ y:CGFloat) {
        self.init(x: x ,y: y)
    }
}

