//
//  TweetFeedTableViewCell.swift
//  HalalNaviTweetFeed
//
//  Created by Syakiruddin Yusof on 02/12/2016.
//  Copyright © 2016 Syakiruddin Yusof. All rights reserved.
//

import UIKit

class TweetFeedTableViewCell: UITableViewCell {
    
    @IBOutlet weak var userProfileImageView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var screenNameLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var createdAtLabel: UILabel!
    @IBOutlet weak var descriptionImageView: UIImageView!
    @IBOutlet weak var imageButton: UIButton!
    @IBOutlet weak var descriptionImageViewHeightLayoutConstraint: NSLayoutConstraint!
    @IBOutlet weak var imageButtonHeightLayoutConstraint: NSLayoutConstraint!
   
    var tapBlock: dispatch_block_t?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        userProfileImageView.layer.cornerRadius = 8.0
        descriptionImageView.layer.cornerRadius = 8.0
        userProfileImageView.clipsToBounds = true
        descriptionImageView.clipsToBounds = true
        
        if(Constant.Device.IS_IPHONE_5 == true){
            userNameLabel.setSizeFont(15)
            screenNameLabel.setSizeFont(12)
            descriptionLabel.setSizeFont(15)
            createdAtLabel.setSizeFont(12)
        }
        if(Constant.Device.IS_IPHONE_4_OR_LESS == true){
            userNameLabel.setSizeFont(13)
            screenNameLabel.setSizeFont(10)
            descriptionLabel.setSizeFont(13)
            createdAtLabel.setSizeFont(10)
        }
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBAction func imageButtonTapped(sender: AnyObject) {
        if let tapBlock = self.tapBlock {
            tapBlock()
        }
    }
   
   
}
