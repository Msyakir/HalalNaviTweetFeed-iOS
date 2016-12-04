//
//  OfflineFeed.swift
//  HalalNaviTweetFeed
//
//  Created by Syakiruddin Yusof on 04/12/2016.
//  Copyright © 2016 Syakiruddin Yusof. All rights reserved.
//

import Foundation
import RealmSwift

class OfflineFeed: Object {
    dynamic var text = ""
    dynamic var created_at = ""
    dynamic var userName = ""
    dynamic var screenName = ""
    dynamic var userProfileImageUrl = ""
    dynamic var retweetUserName = ""
    dynamic var retweetScreenName = ""
    dynamic var retweetProfileImageUrl = ""
    dynamic var retweetText = ""
    dynamic var descriptionImageUrl = ""
    dynamic var retweetImageUrl = ""
    dynamic var profileImageData: NSData?
}