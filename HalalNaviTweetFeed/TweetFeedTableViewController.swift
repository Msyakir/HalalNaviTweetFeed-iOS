//
//  TweetFeedTableViewController.swift
//  HalalNaviTweetFeed
//
//  Created by Syakiruddin Yusof on 02/12/2016.
//  Copyright © 2016 Syakiruddin Yusof. All rights reserved.
//

import UIKit
import RealmSwift

class TweetFeedTableViewController: UITableViewController {
    
    var currentDate = NSDate()
    var HomeFeeds: [HomeFeed]?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Realm database migration
        RealmMigration.migration()
        
        // set up the refresh control
        self.refreshControl!.addTarget(self, action: #selector(TweetFeedTableViewController.refresh(_:)), forControlEvents: UIControlEvents.ValueChanged)
        
        //Check internet connection, if true fetch data from api, else read data from disk
        if(Reachability.isConnectedToNetwork() == true){
            getNewsFeedFromTimeline {
                self.tableView.reloadData()
            }
        }
        else{
             readFeedFromDisk()
        }
        
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(animated: Bool) {
        self.tableView.estimatedRowHeight = 100
        self.tableView.rowHeight = UITableViewAutomaticDimension
    }
    

 
   // MARK: - API Call Funtion
    
    func getNewsFeedFromTimeline(completion : () -> ()){
        
        HTTPClient.AUTH_CLIENT {
            guard let token = ClientData.accessToken else {
                // TODO: Show authentication error
                return
            }
            let headers = ["Authorization": "Bearer \(token)"]
            
            let parameters: [String : AnyObject] = [
                "screen_name" : "halalnavi",
                "exclude_replies" : true,
                "count" : 20,
                "tweet_mode" :"extended"
            ]
            
            HTTPClient.GET(Constant.Twitter.TIMELINE_URL, headers: headers, parameters: parameters, fromViewController: self) { (output) in

                let realm = try! Realm()
                try! realm.write {
                    realm.deleteAll()
                }
  
                self.HomeFeeds = [HomeFeed]()
              
                let userImageUrl = NSURL(string: output![0]["user"]["profile_image_url_https"].stringValue)
                
                let userImageData =  NSData(contentsOfURL:userImageUrl!)
                
                for file in output!.arrayValue
                {
                    let text = file["full_text"].stringValue
                    let created_at = file["created_at"].stringValue
                    let userName = file["user"]["name"].stringValue
                    let screenName = file["user"]["screen_name"].stringValue
                    let userProfileImageUrl = file["user"]["profile_image_url_https"].stringValue
                    let retweetUserName = file["retweeted_status"]["user"]["name"].stringValue
                    let retweetScreenName = file["retweeted_status"]["user"]["screen_name"].stringValue
                    let retweetText = file["retweeted_status"]["full_text"].stringValue
                    let retweetProfileImageUrl = file["retweeted_status"]["user"]["profile_image_url_https"].stringValue
                    let descriptionImageUrl = file["extended_entities"]["media"][0]["media_url_https"].stringValue
                    let retweetImageUrl = file["retweeted_status"]["entities"]["media"][0]["media_url_https"].stringValue
                    let tweetId = file["id"].intValue
                    
                    self.HomeFeeds?.append(HomeFeed(text: text, created_at: created_at, userName: userName, screenName: screenName, userProfileImageUrl: userProfileImageUrl, retweetUserName: retweetUserName, retweetScreenName: retweetScreenName, retweetProfileImageUrl: retweetProfileImageUrl,retweetText: retweetText, descriptionImageUrl: descriptionImageUrl, retweetImageUrl: retweetImageUrl, profileImageData: nil, tweetId: tweetId))
                    
                    self.saveFeedToDisk(text, created_at: created_at, userName: userName, screenName: screenName, retweetUserName: retweetUserName, retweetScreenName: retweetScreenName, retweetText: retweetText, userProfileImageUrl: userProfileImageUrl, retweetProfileImageUrl: retweetProfileImageUrl, profileImageData: userImageData!)
                    
                }
                completion()
            }
        }
    }
    
    //call when bottom cell is displayed, to show older tweet
    func getOldNewsFeedFromTimeline(completion : () -> ()){
        
        var max_id = 0
        
        HTTPClient.AUTH_CLIENT {
            guard let token = ClientData.accessToken else {
                // TODO: Show authentication error
                return
            }
            let headers = ["Authorization": "Bearer \(token)"]
            
            if let count = self.HomeFeeds?.last?.tweetId {max_id = count - 1}
            
            let parameters: [String : AnyObject] = [
                "screen_name" : "halalnavi",
                "exclude_replies" : true,
                "count" : 20,
                "tweet_mode" :"extended",
                "max_id" : max_id
            ]
            
            HTTPClient.GET(Constant.Twitter.TIMELINE_URL, headers: headers, parameters: parameters, fromViewController: self) { (output) in

                for file in output!.arrayValue
                {
                    let text = file["full_text"].stringValue
                    let created_at = file["created_at"].stringValue
                    let userName = file["user"]["name"].stringValue
                    let screenName = file["user"]["screen_name"].stringValue
                    let userProfileImageUrl = file["user"]["profile_image_url_https"].stringValue
                    let retweetUserName = file["retweeted_status"]["user"]["name"].stringValue
                    let retweetScreenName = file["retweeted_status"]["user"]["screen_name"].stringValue
                    let retweetText = file["retweeted_status"]["full_text"].stringValue
                    let retweetProfileImageUrl = file["retweeted_status"]["user"]["profile_image_url_https"].stringValue
                    let descriptionImageUrl = file["extended_entities"]["media"][0]["media_url_https"].stringValue
                    let retweetImageUrl = file["retweeted_status"]["entities"]["media"][0]["media_url_https"].stringValue
                    let tweetId = file["id"].intValue
                
                    //check if tweet already fetch, if false, store to array
                    let isTweetExist = self.HomeFeeds!.filter{$0.tweetId! == tweetId}.count > 0
                    if(isTweetExist == false){
                        self.HomeFeeds?.append(HomeFeed(text: text, created_at: created_at, userName: userName, screenName: screenName, userProfileImageUrl: userProfileImageUrl, retweetUserName: retweetUserName, retweetScreenName: retweetScreenName, retweetProfileImageUrl: retweetProfileImageUrl,retweetText: retweetText, descriptionImageUrl: descriptionImageUrl, retweetImageUrl: retweetImageUrl, profileImageData: nil, tweetId: tweetId))
                    }
                    
                }
                completion()
            }
        }
    }

    // MARK: - Local Storage
    
    func saveFeedToDisk(text: String, created_at: String, userName: String, screenName: String, retweetUserName: String, retweetScreenName: String, retweetText: String, userProfileImageUrl: String, retweetProfileImageUrl:String, profileImageData:NSData){
        
        let offlineFeed = OfflineFeed()
        
        offlineFeed.text = text
        offlineFeed.created_at = created_at
        offlineFeed.userName = userName
        offlineFeed.screenName = screenName
        offlineFeed.retweetUserName = retweetUserName
        offlineFeed.retweetScreenName = retweetScreenName
        offlineFeed.retweetText = retweetText
        offlineFeed.profileImageData = profileImageData
        
        let realm = try! Realm()
        try! realm.write {
            realm.add(offlineFeed)
        }
        
    
    }
    
    func readFeedFromDisk(){
       
        self.HomeFeeds = [HomeFeed]()
        let realm = try! Realm()
        let feeds = realm.objects(OfflineFeed)
        for feed in feeds{
            self.HomeFeeds?.append(HomeFeed(text: feed.text, created_at: feed.created_at, userName: feed.userName, screenName: feed.screenName, userProfileImageUrl: feed.userProfileImageUrl, retweetUserName: feed.retweetUserName, retweetScreenName: feed.retweetScreenName, retweetProfileImageUrl: feed.retweetProfileImageUrl,retweetText: feed.retweetText, descriptionImageUrl: feed.descriptionImageUrl, retweetImageUrl: feed.retweetImageUrl, profileImageData: feed.profileImageData, tweetId: 0))
        }
        
        getNewsFeedFromTimeline {
            dispatch_async(dispatch_get_main_queue()) {
                self.tableView.reloadData()
            }
            
        }
    
    }
    
    // MARK: - Helper Function
    
    func refresh(sender:AnyObject){
        
        if(Reachability.isConnectedToNetwork() == false){self.refreshControl!.endRefreshing()}
        
        getNewsFeedFromTimeline {
            dispatch_async(dispatch_get_main_queue()) {
                self.tableView.reloadData()
            }
            self.refreshControl!.endRefreshing()
        }
    }
    
    func hourBetweenDates(startDate: NSDate, endDate: NSDate) -> Int{
        
        let calendar = NSCalendar.currentCalendar()
        let components = calendar.components([.Hour], fromDate: startDate, toDate: endDate, options: [])
        let hour = abs(components.hour)
        return hour
    }
    
    
    func dayBetweenDates(startDate: NSDate, endDate: NSDate) -> Int{
        
        let calendar = NSCalendar.currentCalendar()
        let components = calendar.components([.Day], fromDate: startDate, toDate: endDate, options: [])
        let day = abs(components.day)
        return day
    }
    

    // MARK: - Table view data source
    
    //Last row is displayed, fetch older data
    override func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        if(Reachability.isConnectedToNetwork() == true){
            if (indexPath.row + 1) == HomeFeeds!.count {
                self.getOldNewsFeedFromTimeline({
                    
                    self.tableView.reloadData()
                })
            }
        }
    }

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let count = HomeFeeds?.count {
            return count
        }else { return 0 }
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var retCell =  UITableViewCell()
        if let HomeFeed = self.HomeFeeds?[indexPath.row] {
            if HomeFeed.retweetUserName != "" {
                
                let cell = tableView.dequeueReusableCellWithIdentifier("RetweetFeedTableViewCellTableViewCell") as! RetweetFeedTableViewCellTableViewCell
                
                cell.userProfileImageView.image = UIImage(named: "Thumbnail")
                cell.descriptionImageView.image = UIImage(named: "Thumbnail")
                
                if HomeFeed.text != "" {
                    cell.descriptionLabel.text = HomeFeed.retweetText
                }
                if HomeFeed.userName != "" {
                    cell.userNameLabel.text = HomeFeed.retweetUserName
                }
                if HomeFeed.screenName != "" {
                    cell.screenNameLabel.text = "@\(HomeFeed.retweetScreenName!)"
                }
                if HomeFeed.retweetProfileImageUrl != "" {
                    
                    let urlImage = HomeFeed.retweetProfileImageUrl!.stringByReplacingOccurrencesOfString("_normal", withString: "")
                    ImageLoader.loadImage(urlImage, imageView: cell.userProfileImageView, withWidth: 100, withHeight: 100)
                
                }
                if HomeFeed.created_at != "" {
                    let hour = self.hourBetweenDates(self.currentDate, endDate: HomeFeed.created_at!.toDateTime())
                    if(hour < 24 ){
                        cell.createdAtLabel.text = "\(hour)h"
                    }else{
                        let day = self.dayBetweenDates(self.currentDate, endDate: HomeFeed.created_at!.toDateTime())
                        cell.createdAtLabel.text = "\(day)d"
                    }
                }
                
                if HomeFeed.retweetImageUrl != "" {
                   cell.descriptionImageViewHeightLayoutConstraint.constant = 200
                    cell.imageButton.hidden = false
                    ImageLoader.loadImage(HomeFeed.retweetImageUrl!, imageView: cell.descriptionImageView, withWidth: 300, withHeight: 200)
                  
                }else{
                    cell.descriptionImageViewHeightLayoutConstraint.constant = 0
                }
                cell.tapBlock = {
                    let navigateViewVC = ImageDetailViewController(nibName: "ImageDetailViewController", bundle: nil)
                    navigateViewVC.imageUrl = HomeFeed.retweetImageUrl
                    self.navigationController?.useBlurForPopup = true
                    self.navigationController?.presentPopupViewController(navigateViewVC, animated: true, completion: {
                        print(self)
                        
                    })
                }
                
                retCell = cell
            
            }else{
                
                let cell = tableView.dequeueReusableCellWithIdentifier("TweetFeedTableViewCell") as! TweetFeedTableViewCell
                
                cell.userProfileImageView.image = UIImage(named: "Thumbnail")
                cell.descriptionImageView.image = UIImage(named: "Thumbnail")
                
                if HomeFeed.text != "" {
                    cell.descriptionLabel.text = HomeFeed.text
                }
                if HomeFeed.userName != "" {
                    cell.userNameLabel.text = HomeFeed.userName
                }
                if HomeFeed.screenName != "" {
                    cell.screenNameLabel.text = "@\(HomeFeed.screenName!)"
                }
                if HomeFeed.userProfileImageUrl != "" {
                    let urlImage = HomeFeed.userProfileImageUrl!.stringByReplacingOccurrencesOfString("_normal", withString: "")
                    ImageLoader.loadImage(urlImage, imageView: cell.userProfileImageView, withWidth: 100, withHeight: 100)
                    
                }else if(HomeFeed.profileImageData != nil){ cell.userProfileImageView.image = UIImage(data: HomeFeed.profileImageData!) }
                
                if HomeFeed.created_at != "" {
                    let hour = self.hourBetweenDates(self.currentDate, endDate: HomeFeed.created_at!.toDateTime())
                    if(hour < 24 ){
                        cell.createdAtLabel.text = "\(hour)h"
                    }else{
                        let day = self.dayBetweenDates(self.currentDate, endDate: HomeFeed.created_at!.toDateTime())
                        cell.createdAtLabel.text = "\(day)d"
                    }
                }
                if HomeFeed.descriptionImageUrl != "" {
                    cell.imageButton.hidden = false
                    cell.descriptionImageViewHeightLayoutConstraint.constant = 200
                    ImageLoader.loadImage(HomeFeed.descriptionImageUrl!, imageView: cell.descriptionImageView, withWidth: 300, withHeight: 200)
                }else{
                    cell.descriptionImageViewHeightLayoutConstraint.constant = 0
                }
                cell.tapBlock = {
                    let navigateViewVC = ImageDetailViewController(nibName: "ImageDetailViewController", bundle: nil)
                    navigateViewVC.imageUrl = HomeFeed.descriptionImageUrl
                    self.navigationController?.useBlurForPopup = true
                    self.navigationController?.presentPopupViewController(navigateViewVC, animated: true, completion: {
                        print(self)
                        
                    })
                }
                retCell = cell
            }
        }
      return retCell
    }
    
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.1
    }
    
    override func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.1
    }
    
}



