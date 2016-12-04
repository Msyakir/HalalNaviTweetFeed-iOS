//
//  Constant.swift
//  HalalNaviTweetFeed
//
//  Created by Syakiruddin Yusof on 02/12/2016.
//  Copyright © 2016 Syakiruddin Yusof. All rights reserved.
//

import Foundation
import UIKit

struct Constant
{
    //MARK: DEVICE DIMENSION
    struct Device {
        static let IS_IPHONE = UIDevice.currentDevice().userInterfaceIdiom == .Phone
        static let IS_IPAD = UIDevice.currentDevice().userInterfaceIdiom == .Pad
        static let IS_RETINA = UIScreen.mainScreen().scale >= 2.0
        static let SCREEN_WIDTH = UIScreen.mainScreen().bounds.size.width
        static let SCREEN_HEIGHT = UIScreen.mainScreen().bounds.size.height
        static let SCREEN_MAX_LENGTH = max(SCREEN_WIDTH, SCREEN_HEIGHT)
        static let SCREEN_MIN_LENGTH = min(SCREEN_WIDTH, SCREEN_HEIGHT)
        static let IS_IPHONE_4_OR_LESS = IS_IPHONE && (SCREEN_MAX_LENGTH < 568.0)
        static let IS_IPHONE_5 = IS_IPHONE && (SCREEN_MAX_LENGTH == 568.0)
        static let IS_IPHONE_6  = IS_IPHONE && (SCREEN_MAX_LENGTH == 667.0)
        static let IS_IPHONE_6P = IS_IPHONE && (SCREEN_MAX_LENGTH == 736.0)
        
    }
    //MARK: Twitter
    struct Twitter {
        static let API_KEY = "aM7CWEnkTI1WV1qNqKtwIxT12"
        static let API_SECRET = "nG5TFvOCxlT9NVA7sfvYwvRueneVymXxXw2W2d7ftdkD46HJop"
        static let TIMELINE_URL = "https://api.twitter.com/1.1/statuses/user_timeline.json"
        static let TOKEN_URL = "https://api.twitter.com/oauth2/token"
    }
    
}