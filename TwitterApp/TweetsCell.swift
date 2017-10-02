//
//  TweetsCell.swift
//  TwitterApp
//
//  Created by John Nguyen on 9/29/17.
//  Copyright © 2017 John Nguyen. All rights reserved.
//

import UIKit

class TweetsCell: UITableViewCell {
    
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var tweetTextLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var screenNameLabel: UILabel!
    @IBOutlet weak var timestampLabel: UILabel!
    @IBOutlet weak var replyLabel: UILabel!
    
    var tweet: Tweet! {
        didSet {
            profileImageView.setImageWith((tweet.user?.profileURL)!)
            tweetTextLabel.text = tweet.text as String?
            nameLabel.text = tweet.user?.name as String?
            screenNameLabel.text = tweet.user?.screenNameDisplay
            timestampLabel.text = tweet.timestamp?.getElapsedInterval()
            
            if let replyScreenName = tweet.replyScreenName {
                replyLabel.text = "Replying to @\(replyScreenName)"
            } else {
                replyLabel.text = ""
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
