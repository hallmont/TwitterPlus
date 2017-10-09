//
//  User.swift
//  TwitterApp
//
//  Created by John Nguyen on 9/27/17.
//  Copyright © 2017 John Nguyen. All rights reserved.
//

import UIKit

class User: NSObject {
    static let userDidLogoutNotification: Notification.Name = Notification.Name(rawValue: "UserDidLogout")
    
    var name: NSString?
    var screenName: NSString?
    var screenNameDisplay: String?
    var profileURL: URL?
    var bannerURL: URL?
    var tagline: NSString?
    var dictionary: NSDictionary?
    var followersCount: Int?
    var friendsCount: Int?
    var tweetsCount: Int?
    
    init(dictionary: NSDictionary) {
        self.dictionary = dictionary
        
        // print( "dictionary 1: \(dictionary)")
        name = dictionary["name"] as? NSString
        screenName = dictionary["screen_name"] as? NSString
        screenNameDisplay = "@\(screenName!)"
        followersCount = dictionary["followers_count"] as? Int
        friendsCount = dictionary["friends_count"] as? Int
        tweetsCount = dictionary["statuses_count"] as? Int
        let profileURLString = dictionary["profile_image_url_https"] as? String
        if let profileURLString = profileURLString {
            profileURL = URL(string: profileURLString)
        }
        let bannerURLString = dictionary["profile_banner_url"] as? String
        print( "bannerURLString=\(bannerURLString)")
        if let bannerURLString = bannerURLString {
            bannerURL = URL(string: bannerURLString)
        }
        tagline = dictionary["description"] as? NSString
    }
    
    static var _currentUser: User?

    
    class var currentUser: User? {
        get {
            if _currentUser == nil {
                let defaults = UserDefaults.standard
                let userData = defaults.object(forKey: "currentUserData") as? NSData
                
                if let userData = userData {
                    let dictionary = try!
                        JSONSerialization.jsonObject(with: userData as Data, options: []) as! NSDictionary
                    _currentUser = User(dictionary: dictionary)
                }
            }
            
            return _currentUser
        }
        set(user) {
            _currentUser = user
            
            let defaults = UserDefaults.standard

            if let user = user {
                // print( "** user.dictionary=\(user.dictionary)")
                let data = try! JSONSerialization.data(withJSONObject: user.dictionary!, options: [])
                defaults.set(data, forKey: "currentUserData")
            } else {
                defaults.set(nil, forKey: "currentUserData")
            }
            
            defaults.synchronize()
        }
    }
}
