//
//  String+toDateTime.swift
//  HalalNaviTweetFeed
//
//  Created by Syakiruddin Yusof on 03/12/2016.
//  Copyright © 2016 Syakiruddin Yusof. All rights reserved.
//

import Foundation

extension String
{
    func toDateTime() -> NSDate
    {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "EEE MMM dd HH:mm:ss Z yyyy"
        let dateFromString : NSDate = dateFormatter.dateFromString(self)!
        return dateFromString
    }
}

