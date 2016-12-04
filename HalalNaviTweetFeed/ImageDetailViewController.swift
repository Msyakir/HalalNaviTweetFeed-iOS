//
//  ImageDetailViewController.swift
//  HalalNaviTweetFeed
//
//  Created by Syakiruddin Yusof on 02/12/2016.
//  Copyright © 2016 Syakiruddin Yusof. All rights reserved.
//

import UIKit

class ImageDetailViewController: UIViewController {

    var imageUrl:String?
    
    @IBOutlet weak var selectedImageView: UIImageView!
   
    override func viewDidLoad() {
        super.viewDidLoad()
    
        selectedImageView.layer.cornerRadius = 10.0
        selectedImageView.clipsToBounds = true
        ImageLoader.loadImage(imageUrl, imageView: selectedImageView, withWidth: 400, withHeight: 400)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func closeAction(sender: UIButton) {
        
        self.navigationController?.dismissPopupViewController(true, completion: nil)
    }

    @IBAction func scaleImage(sender: UIPinchGestureRecognizer) {
        
        self.view.transform = CGAffineTransformScale(self.view.transform, sender.scale, sender.scale)
        sender.scale = 1
        
    }


}
