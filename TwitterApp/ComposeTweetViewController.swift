//
//  ComposeTweetViewController.swift
//  TwitterApp
//
//  Created by John Nguyen on 9/30/17.
//  Copyright © 2017 John Nguyen. All rights reserved.
//

import UIKit

class ComposeTweetViewController: UIViewController, UITextViewDelegate {

    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var fullNameLabel: UILabel!
    @IBOutlet weak var screenNameLabel: UILabel!
    @IBOutlet weak var textInputView: UITextView!
    @IBOutlet weak var characterLimitLabel: UILabel!
    @IBOutlet weak var replyLabel: UILabel!
    
    let kCharacterLimit = 140
    
    var completionHandler: ((Tweet)->())?
    var tweet: Tweet!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if tweet == nil {
            replyLabel.isHidden = true
        } else {
            replyLabel.isHidden = false
            replyLabel.text = "Replying to \((tweet.user?.screenNameDisplay)!)"
        }
        
        let user = User.currentUser

        profileImageView.setImageWith((user?.profileURL)!)
        fullNameLabel.text = user?.name! as! String
        screenNameLabel.text = user?.screenNameDisplay
        textInputView.delegate = self
        textInputView.becomeFirstResponder()
        // Do any additional setup after loading the view.
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        textInputView.setContentOffset(CGPoint.zero, animated: false)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func tweetButtonSelected(_ sender: Any) {
        if( replyLabel.isHidden == true ) {
            TwitterClient.shared.postTweet(text: textInputView.text, success: { (tweet: Tweet) in
                self.completionHandler?(tweet)  // return tweet to caller
                self.dismiss(animated: true, completion: nil)
            }) { (error: Error) in
            }
        } else {
            TwitterClient.shared.replyTweet(tweetId: tweet.id_str!, text: textInputView.text, success: { (tweet: Tweet) in
                self.completionHandler?(tweet)  // return tweet to caller
                self.dismiss(animated: true, completion: nil)
            }) { (error: Error) in
            }
        }
    }

    @IBAction func cancelButtonSelected(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    func textViewDidChange(_ textView: UITextView) {
        // Update countdown for tweet character limit
        characterLimitLabel.text = "\(kCharacterLimit - textView.text.characters.count)"
    }
}
