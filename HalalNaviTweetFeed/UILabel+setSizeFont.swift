//
//  UILabel+setSizeFont.swift
//  HalalNaviTweetFeed
//
//  Created by Syakiruddin Yusof on 05/12/2016.
//  Copyright © 2016 Syakiruddin Yusof. All rights reserved.
//

import Foundation
import UIKit

extension UILabel {
    func setSizeFont (sizeFont: CGFloat) {
        self.font =  UIFont(name: self.font.fontName, size: sizeFont)!
        self.sizeToFit()
    }
}