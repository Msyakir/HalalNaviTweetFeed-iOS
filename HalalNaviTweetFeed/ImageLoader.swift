//
//  ImageLoader.swift
//  HalalNaviTweetFeed
//
//  Created by Syakiruddin Yusof on 04/12/2016.
//  Copyright © 2016 Syakiruddin Yusof. All rights reserved.
//

import Foundation
import Nuke

class ImageLoader {
    
    static func loadImage(url : String! , imageView : UIImageView, withWidth width : CGFloat , withHeight height : CGFloat) {
      
        var request = ImageRequest(URLRequest: NSURLRequest(URL: NSURL(string: url)!))
        
        // Set target size (in pixels) and content mode that describe how to resize loaded image
        request.targetSize = CGSize(width: width, height: height)

        // Control memory caching
        request.memoryCacheStorageAllowed = true // true is default
        request.memoryCachePolicy = .ReturnCachedImageElseLoad
        
        Nuke.taskWith(request) { response in
            switch response {
            case let .Success(image, _) :
                imageView.image = image
            case let .Failure(error):
                print("Error loading image : \(error)")
                imageView.image = UIImage(named: "Thumbnail")
            }
            
            }.resume()
        
        return
    }
}