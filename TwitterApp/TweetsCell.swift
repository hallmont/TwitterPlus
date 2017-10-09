//
//  TweetsCell.swift
//  TwitterApp
//
//  Created by John Nguyen on 9/29/17.
//  Copyright © 2017 John Nguyen. All rights reserved.
//

import UIKit

@objc protocol TweetsCellDelegate {
    //@objc optional func switchCell(switchCell: SwitchCell, didChangeValue value: Bool)
    @objc optional func showUserProfile( tweet: Tweet )
    @objc optional func handleRetweet( button: UIButton, tweet: Tweet )
}

class TweetsCell: UITableViewCell {
    
    @IBOutlet weak var profileImageButton: UIButton!
    @IBOutlet weak var tweetTextLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var screenNameLabel: UILabel!
    @IBOutlet weak var timestampLabel: UILabel!
    @IBOutlet weak var replyLabel: UILabel!
    @IBOutlet weak var retweetButton: UIButton!
    @IBOutlet weak var favoriteButton: UIButton!
    
    
    weak var delegate: TweetsCellDelegate?
    
    var tweet: Tweet! {
        didSet {
            profileImageButton.setBackgroundImageFor(UIControlState.normal, with: ((tweet.user?.profileURL)!))
            tweetTextLabel.text = tweet.text as String?
            nameLabel.text = tweet.user?.name as String?
            screenNameLabel.text = tweet.user?.screenNameDisplay
            timestampLabel.text = tweet.timestamp?.getElapsedInterval()
            retweetButton.updateRetweetDisplay(tweet: tweet)
            
            if let replyScreenName = tweet.replyScreenName {
                replyLabel.text = "Replying to @\(replyScreenName)"
            } else {
                replyLabel.text = ""
            }
        }
    }
    
    @IBAction func retweetButtonSelected(_ sender: Any) {
        let button = sender as! UIButton
        
        button.toggleRetweetStatus(tweet: tweet, success: { (tweet: Tweet) in
        }) { (error: Error) in
        }
    }
    
    @IBAction func favoriteButtonSelected(_ sender: Any) {
        let button = sender as! UIButton
        
        button.toggleFavoriteStatus(tweet: tweet, success: { (tweet: Tweet) in
        }) { (error: Error) in
        }
    }

    @IBAction func imageButtonSelected(_ sender: Any) {
        print( "Button Pressed" )
        delegate?.showUserProfile?( tweet: tweet )
    }
    
    static var identifier: String {
        return String(describing: self)
    }
    
    
    static var nib:UINib {
        return UINib(nibName: identifier, bundle: nil)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        print( "** awakeFromNib")
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}

extension UIButton {
    
    static let favoriteYesImage = UIImage( named: "favorite_yes")
    static let favoriteNoImage = UIImage( named: "favorite")
    
    static let retweetYesImage = UIImage( named: "retweet_yes")
    static let retweetNoImage = UIImage( named: "retweet")
    
    func toggleRetweetStatus( tweet: Tweet, success: @escaping (Tweet)->(), failure: @escaping (Error)->() ) {
        if tweet.retweeted {
            TwitterClient.shared.unretweet(tweetId: tweet.id_str!, success: { (tweetReturned: Tweet) in
                self.setImage( UIButton.retweetNoImage, for: UIControlState.normal )
                tweet.retweetCount -= 1
                tweet.retweeted = false
                success(tweet)
            }) { (error: Error) in
                failure(error)
            }
        } else {
            TwitterClient.shared.retweet(tweetId: tweet.id_str!, success: { (tweetReturned: Tweet) in
                self.setImage( UIButton.retweetYesImage, for: UIControlState.normal )
                tweet.retweetCount += 1
                tweet.retweeted = true
                success(tweet)
            }) { (error: Error) in
                failure(error)
            }
        }
    }
    
    func updateRetweetDisplay( tweet: Tweet ) {
        if tweet.retweeted {
            setImage( UIButton.retweetYesImage, for: UIControlState.normal )
        } else {
            setImage( UIButton.retweetNoImage, for: UIControlState.normal )
        }
    }
    
    func updateFavoriteDisplay( tweet: Tweet ) {
        if tweet.favorited {
            setImage( UIButton.favoriteYesImage, for: UIControlState.normal )
        } else {
            setImage( UIButton.favoriteNoImage, for: UIControlState.normal )
        }
    }
    
    func toggleFavoriteStatus( tweet: Tweet, success: @escaping (Tweet)->(), failure: @escaping (Error)->()  ) {
        
        print( "tweet.favoritesCount=\(tweet.favoritesCount)" )

        if tweet.favorited {
            TwitterClient.shared.unfavorite(tweetId: tweet.id_str!, success: { (tweetReturned: Tweet) in
                self.setImage( UIButton.favoriteNoImage, for: UIControlState.normal )
                tweet.favoritesCount -= 1
                tweet.favorited = false
                success(tweet)
            }, failure: { (error: Error) in
                failure(error)
            })
        } else {
            TwitterClient.shared.favorite(tweetId: tweet.id_str!, success: { (tweetReturned: Tweet ) in
                self.setImage( UIButton.favoriteYesImage, for: UIControlState.normal )
                tweet.favoritesCount += 1
                tweet.favorited = true
                success(tweet)
            }) { (error: Error) in
                print( "error=\(error)")
                failure(error)
            }
        }
    }
}
