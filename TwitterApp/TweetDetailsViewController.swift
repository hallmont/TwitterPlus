//
//  TweetDetailsViewController.swift
//  TwitterApp
//
//  Created by John Nguyen on 9/30/17.
//  Copyright © 2017 John Nguyen. All rights reserved.
//

import UIKit

class TweetDetailsViewController: UIViewController, TweetsCellDelegate {

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
    var cell: TweetsCell! {
        didSet {
            tweet = cell.tweet
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        profileImageView.setImageWith((tweet.user?.profileURL)!)
        fullNameLabel.text = tweet.user?.name! as! String
        screenNameLabel.text = tweet.user?.screenNameDisplay
        tweetTextLabel.text = tweet.text as String?
        timestampLabel.text = tweet.timestamp?.getFormattedTimestamp()
        
        retweetButton.updateRetweetDisplay(tweet: tweet)
        favoriteButton.updateFavoriteDisplay(tweet: tweet)

        // Do any additional setup after loading the view.
        updateDisplay()
    }

    func updateDisplay() {
        favoritesCountLabel.text = "\(tweet.favoritesCount)"
        tweetCountLabel.text = "\(tweet.retweetCount)"
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
        retweetButton.toggleRetweetStatus(tweet: tweet, success: { (tweet: Tweet) in
            self.tweet = tweet
            self.updateDisplay()
            self.cell.retweetButton.updateRetweetDisplay(tweet: tweet)
        }) { (error: Error) in
        }
    }
    
    @IBAction func favoriteButtonSelected(_ sender: Any) {
        favoriteButton.toggleFavoriteStatus(tweet: tweet, success: { (tweet: Tweet) in
            self.tweet = tweet
            self.updateDisplay()
            self.cell.favoriteButton.updateFavoriteDisplay(tweet: tweet)
        }) { (error: Error) in
        }
    }
}
