//
//  TweetDetailsViewController.swift
//  TwitterApp
//
//  Created by John Nguyen on 9/30/17.
//  Copyright © 2017 John Nguyen. All rights reserved.
//

import UIKit

class TweetDetailsViewController: UIViewController {

    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var fullNameLabel: UILabel!
    @IBOutlet weak var screenNameLabel: UILabel!
    
    @IBOutlet weak var tweetTextLabel: UILabel!
    @IBOutlet weak var timestampLabel: UILabel!
    
    @IBOutlet weak var retweetButton: UIButton!
    @IBOutlet weak var favoriteButton: UIButton!

    @IBOutlet weak var favoritesCountLabel: UILabel!
    @IBOutlet weak var tweetCountLabel: UILabel!
    
    let favoriteYesImage = UIImage( named: "favorite_yes")
    let favoriteNoImage = UIImage( named: "favorite")
    
    let retweetYesImage = UIImage( named: "retweet_yes")
    let retweetNoImage = UIImage( named: "retweet")
    
    var tweet: Tweet!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        profileImageView.setImageWith((tweet.user?.profileURL)!)
        fullNameLabel.text = tweet.user?.name! as! String
        screenNameLabel.text = tweet.user?.screenNameDisplay
        tweetTextLabel.text = tweet.text as String?
        timestampLabel.text = tweet.timestamp?.getFormattedTimestamp()

        // Do any additional setup after loading the view.
        updateDisplay()
    }
    
    func updateDisplay() {
        favoritesCountLabel.text = "\(tweet.favoritesCount)"
        tweetCountLabel.text = "\(tweet.retweetCount)"
        print( "favoritesCount=\(tweet.favoritesCount) - retweetCount=\(tweet.retweetCount)")
        
        if tweet.favorited {
            favoriteButton.setImage( favoriteYesImage, for: UIControlState.normal )
        } else {
            favoriteButton.setImage( favoriteNoImage, for: UIControlState.normal )
        }
        
        if tweet.retweeted {
            retweetButton.setImage( retweetYesImage, for: UIControlState.normal )
        } else {
            retweetButton.setImage( retweetNoImage, for: UIControlState.normal )
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func replyButtonSelected(_ sender: Any) {
            
        self.performSegue(withIdentifier: "ReplySegue", sender: nil)
        
    }
        
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let navigation = segue.destination as? UINavigationController,
            let vc = navigation.viewControllers[0] as? ComposeTweetViewController {
            vc.tweet = tweet
            
            vc.completionHandler = { tweet in

            }
        }
    }
    
    @IBAction func retweetButtonSelected(_ sender: Any) {
        if self.tweet.retweeted {
            TwitterClient.shared.unretweet(tweetId: tweet.id_str!, success: { (tweetReturned: Tweet) in
                self.tweet.retweetCount -= 1
                self.tweet.retweeted = false
                self.updateDisplay()
            }) { (error: Error) in
                print( "error=\(error)")
            }
        } else {
            TwitterClient.shared.retweet(tweetId: tweet.id_str!, success: { (tweetReturned: Tweet) in
                self.tweet.retweetCount += 1
                self.tweet.retweeted = true
                self.updateDisplay()
            }) { (error: Error) in
                print( "error=\(error)")
            }
        }
    }
    
    @IBAction func favoriteButtonSelected(_ sender: Any) {
        if self.tweet.favorited {
            TwitterClient.shared.unfavorite(tweetId: tweet.id_str!, success: { (tweetReturned: Tweet ) in
                self.tweet.favoritesCount -= 1
                self.tweet.favorited = false
                self.updateDisplay()
            }) { (error: Error) in
                print( "error=\(error)")
            }
        } else {
            TwitterClient.shared.favorite(tweetId: tweet.id_str!, success: { (tweetReturned: Tweet ) in
                self.tweet.favoritesCount += 1
                self.tweet.favorited = true
                self.updateDisplay()
            }) { (error: Error) in
                print( "error=\(error)")
            }
        }
        

    }
}
