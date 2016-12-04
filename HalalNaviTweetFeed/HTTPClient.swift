//
//  HTTPClient.swift
//  HalalNaviTweetFeed
//
//  Created by Syakiruddin Yusof on 03/12/2016.
//  Copyright © 2016 Syakiruddin Yusof. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class HTTPClient
{
   //Authenticate the client's device
    static func AUTH_CLIENT(completionBlock: Void -> ()) {
        
        if ClientData.accessToken != nil {
            completionBlock()
        }
        
        let credentials = "\(Constant.Twitter.API_KEY):\(Constant.Twitter.API_SECRET)"
        let headers = ["Authorization": "Basic \(credentials.getBase64())"]
        let params: [String : AnyObject] = ["grant_type": "client_credentials"]
        
        Alamofire.request(.POST, Constant.Twitter.TOKEN_URL, headers: headers, parameters: params)
            .responseJSON { response in
                if let JSON = response.result.value {
                    ClientData.accessToken = JSON.objectForKey("access_token") as? String
                    completionBlock()
                }
        }
    }
    
    //Fetch data from API
    static func GET(URLString : String, headers : [String: String]?, parameters : [String: AnyObject]?, fromViewController viewController : UIViewController, completion : (output : JSON?) -> Void)  {
        
        Alamofire.request(.GET, Constant.Twitter.TIMELINE_URL, headers: headers, parameters: parameters).responseJSON { (response) in
            
            switch response.result {
            case .Success(let value) :
                let swiftyJSON = JSON(value)
                completion(output: swiftyJSON)
            case .Failure(_) :
                self.alertError(forResponse: response, delegate: viewController)
            }
        }
        
    }
    
    //Handle error
    static func alertError(forResponse response :  Response<AnyObject,NSError>, delegate viewController : UIViewController) {
        
        let statusCode = response.response?.statusCode
        let errorTitle = "Error Code : \(response.response?.statusCode)"
        let errorDescription = "It looks like something is wrong at the moment"
        var alertController = UIAlertController(title: errorTitle, message: errorDescription, preferredStyle: .Alert)
        let dismissAction = UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Cancel, handler: nil)
        
        if statusCode == 0 {
            alertController = UIAlertController(title: "Unable to Connect to Internet", message: "Unable to connect to the internet at the moment. Please try again later.", preferredStyle: .Alert)
        }
        
        alertController.addAction(dismissAction)
        viewController.presentViewController(alertController, animated: true, completion: nil)
    }

}

