//
//  AccountCell.swift
//  TwitterApp
//
//  Created by John Nguyen on 10/6/17.
//  Copyright © 2017 John Nguyen. All rights reserved.
//

import UIKit

class AccountCell: UITableViewCell {

    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var fullNameLabel: UILabel!
    @IBOutlet weak var screenNameLabel: UILabel!
    
    var user: User! {
        didSet {
            print( "profileURL=\(user.profileURL)")
            profileImageView.setImageWith((user.profileURL)!)
            //fullNameLabel.text = user.name! as! String
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
