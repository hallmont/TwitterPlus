//
//  TwitterClient.swift
//  TwitterApp
//
//  Created by John Nguyen on 9/27/17.
//  Copyright © 2017 John Nguyen. All rights reserved.
//

import UIKit
import BDBOAuth1Manager
import AFNetworking

class TwitterClient: BDBOAuth1SessionManager {

    
    static let shared: TwitterClient = TwitterClient(
        baseURL: URL(string: "https://api.twitter.com"),
        consumerKey: "2ufatl6Yv2o8XJQLdMNTqVQl0",
        consumerSecret: "ehPLYimDs5EyMn8tnvraSLOk8o07x9dHndOAnoikCJjLo0zSx8" )
    
    var loginSuccess: (() -> ())?
    var loginFailure: ((Error) -> ())?
    
    func login(success: @escaping ()->(), failure: @escaping (Error)->()) {
        loginSuccess = success
        loginFailure = failure
        
        TwitterClient.shared.deauthorize()
        TwitterClient.shared.fetchRequestToken(
            withPath: "oauth/request_token", method: "GET", callbackURL: URL(string: "twitterdemo://oauth"),
            scope: nil, success: { (requestToken: BDBOAuth1Credential!) -> Void in
                print( "request token=\(requestToken.token)")
                
                let url = URL(string: "https://api.twitter.com/oauth/authorize?oauth_token=\(requestToken.token!)")!
                UIApplication.shared.openURL(url)
                
        }) { (error: Error?) -> Void in
            print( "error: \(error!.localizedDescription)")
            self.loginFailure!(error!)
        }
    }
    
    func logout() {
        User.currentUser = nil
        deauthorize()
        
        NotificationCenter.default.post(name: User.userDidLogoutNotification, object: nil)
    }
    
    func handleOpenURL( url: URL ) {
        
        let requestToken = BDBOAuth1Credential( queryString: url.query)
        fetchAccessToken(withPath: "oauth/access_token", method: "POST", requestToken: requestToken, success: { (accessToken: BDBOAuth1Credential!) -> Void in
            //print("Access Token: \(accessToken.token) ")
            //print("Token Secret=\(accessToken.secret)")
      
            self.fetchCurrentAccount(success: { (user: User) in
                print( "** handleOpenURL: user.name=\(user.name)")
                User.currentUser = user
                self.loginSuccess?()
            }, failure: { (error: Error) in
                self.loginFailure?(error)
            })
        }) { (error: Error!) -> Void in
            print( "error: \(error.localizedDescription)" )
            self.loginFailure?(error)
        }
    }
    
    func fetchHomeTimeline( maxId: String?, success: @escaping ([Tweet]) -> (), failure: @escaping (Error) -> ()) {

        var parameters: NSDictionary!

        if maxId != nil {
            parameters = [
            "max_id": maxId!
            ]
        } else {
            parameters = nil
        }
        
        get("1.1/statuses/home_timeline.json", parameters: parameters, progress: nil, success: { (task: URLSessionDataTask, response: Any?) -> Void in
            let dictionaries = response as! [NSDictionary]
            
            let tweets = Tweet.tweetsWithArray(dictionaries: dictionaries)

            success(tweets)
        }, failure: { (task: URLSessionDataTask?, error: Error) -> Void in
            failure(error)
        })
    }
    
    func fetchCurrentAccount( success: @escaping (User) -> (), failure: @escaping (Error) -> ()) {
        get("1.1/account/verify_credentials.json", parameters: nil, progress: nil, success: { (task: URLSessionDataTask, response: Any?) -> Void in
        print( "account: \(response)")
        
        let userDictionary = response as! NSDictionary
        let user = User(dictionary: userDictionary)
            
        success(user)
        
        }, failure: { (task: URLSessionDataTask?, error: Error) -> Void in
            failure(error)
        })
    }
    
    func postTweet( text: String, success: @escaping (Tweet) -> (), failure: @escaping (Error) -> ()) {

        let parameters: NSDictionary = [
            "status": text
        ]
        
        post("1.1/statuses/update.json", parameters: parameters, progress: nil, success: { (task: URLSessionDataTask, response: Any?) in
            let dictionary = response as? NSDictionary
            let tweet = Tweet(dictionary: dictionary!)
            success(tweet)
        }) { (task: URLSessionDataTask?, error: Error) in
            failure(error)
        }
    }
    
    func replyTweet( tweetId: String, text: String, success: @escaping (Tweet) -> (), failure: @escaping (Error) -> ()) {
        
        let parameters: NSDictionary = [
            "status": text,
            "in_reply_to_status_id": tweetId
        ]
        
        post("1.1/statuses/update.json", parameters: parameters, progress: nil, success: { (task: URLSessionDataTask, response: Any?) in
            let dictionary = response as? NSDictionary
            let tweet = Tweet(dictionary: dictionary!)
            success(tweet)
        }) { (task: URLSessionDataTask?, error: Error) in
            failure(error)
        }
    }
    
    func retweet(tweetId: String, success: @escaping (Tweet) -> (), failure: @escaping (Error) -> ()) {
        var endpoint: String = "1.1/statuses/retweet.json"
        
        print( "tweetId=\(tweetId)")
        let params: NSDictionary = [
            "id": tweetId
        ]
        self.post(endpoint, parameters: params, progress: nil, success: { (task: URLSessionDataTask, response: Any?) in
            let dictionary = response as? NSDictionary
            let tweet = Tweet(dictionary: dictionary!)
            success(tweet)
        }) { (task: URLSessionDataTask?, error: Error) in
            failure(error)
        }
    }
    
    func unretweet(tweetId: String, success: @escaping (Tweet) -> (), failure: @escaping (Error) -> ()) {
        var endpoint: String = "1.1/statuses/unretweet.json"
        
        print( "tweetId=\(tweetId)")
        let params: NSDictionary = [
            "id": tweetId
        ]
        self.post(endpoint, parameters: params, progress: nil, success: { (task: URLSessionDataTask, response: Any?) in
            let dictionary = response as? NSDictionary
            let tweet = Tweet(dictionary: dictionary!)
            success(tweet)
        }) { (task: URLSessionDataTask?, error: Error) in
            failure(error)
        }
    }
    
    func favorite(tweetId: String, success: @escaping (Tweet) -> (), failure: @escaping (Error) -> ()) {
        var endpoint: String = "1.1/favorites/create.json"
        
        let params: NSDictionary = [
            "id": tweetId
        ]
        self.post(endpoint, parameters: params, progress: nil, success: { (task: URLSessionDataTask, response: Any?) in
            let dictionary = response as? NSDictionary
            let tweet = Tweet(dictionary: dictionary!)
            success(tweet)
        }) { (task: URLSessionDataTask?, error: Error) in
            failure(error)
        }
    }
    
    func unfavorite(tweetId: String, success: @escaping (Tweet) -> (), failure: @escaping (Error) -> ()) {
        var endpoint: String = "1.1/favorites/destroy.json"
        
        let params: NSDictionary = [
            "id": tweetId
        ]
        self.post(endpoint, parameters: params, progress: nil, success: { (task: URLSessionDataTask, response: Any?) in
            let dictionary = response as? NSDictionary
            let tweet = Tweet(dictionary: dictionary!)
            success(tweet)
        }) { (task: URLSessionDataTask?, error: Error) in
            failure(error)
        }
    }

}
