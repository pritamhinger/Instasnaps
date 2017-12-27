//
//  UIColor+Extension.swift
//  Instasnaps
//
//  Created by Pritam Hinger on 27/12/17.
//  Copyright © 2017 AppDevelapp. All rights reserved.
//

import UIKit

extension UIColor{
    static func rgb(red: CGFloat, green: CGFloat, blue: CGFloat) -> UIColor{
        return UIColor(red: red/255, green: green/255, blue: blue/255, alpha: 1)
    }
}
