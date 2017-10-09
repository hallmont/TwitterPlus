//
//  HeaderCell.swift
//  TwitterApp
//
//  Created by John Nguyen on 10/7/17.
//  Copyright © 2017 John Nguyen. All rights reserved.
//

import UIKit

class HeaderCell: UITableViewCell {

    @IBOutlet weak var headerPhoto: UIImageView!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var screenNameLabel: UILabel!
    @IBOutlet weak var followersLabel: UILabel!
    @IBOutlet weak var friendsLabel: UILabel!
    @IBOutlet weak var tweetsLabel: UILabel!
    
    var user: User! {
        didSet {
            if let bannerURL = user.bannerURL {
                headerPhoto.setImageWith( bannerURL )
            }
            if let profileURL = user.profileURL {
                profileImageView.setImageWith(profileURL)
            }
            nameLabel.text = user.name as! String
            screenNameLabel.text = user.screenNameDisplay
            followersLabel.text = "\(user.followersCount!)"
            friendsLabel.text = "\(user.friendsCount!)"
            tweetsLabel.text = "\(user.tweetsCount!)"
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
