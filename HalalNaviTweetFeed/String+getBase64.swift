//
//  String+getBase64.swift
//  HalalNaviTweetFeed
//
//  Created by Syakiruddin Yusof on 03/12/2016.
//  Copyright © 2016 Syakiruddin Yusof. All rights reserved.
//

import Foundation

extension String {
    func getBase64() -> String {
        let credentialData = self.dataUsingEncoding(NSUTF8StringEncoding)!
        return credentialData.base64EncodedStringWithOptions([])
    }
}