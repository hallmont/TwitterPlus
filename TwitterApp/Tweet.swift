//
//  Tweet.swift
//  TwitterApp
//
//  Created by John Nguyen on 9/27/17.
//  Copyright © 2017 John Nguyen. All rights reserved.
//

import UIKit

class Tweet: NSObject {

    var id_str: String?
    var text: NSString?
    var timestamp: Date?
    var retweetCount: Int = 0
    var favoritesCount: Int = 0
    var user: User?
    var favorited: Bool
    var retweeted: Bool
    var replyScreenName: NSString?
    
    init(dictionary: NSDictionary) {
        id_str = dictionary["id_str"] as? String
        text = dictionary["text"] as? NSString
        replyScreenName = dictionary["in_reply_to_screen_name"] as? NSString
        
        favorited = (dictionary["favorited"] as? Bool) ?? false
        retweeted = (dictionary["retweeted"] as? Bool) ?? false
        
        retweetCount = (dictionary["retweet_count"] as? Int) ?? 0
        favoritesCount = (dictionary["favorite_count"] as? Int) ?? 0
        
        let timestampString = dictionary["created_at"] as? String

        if let timestampString = timestampString {
            let formatter = DateFormatter()
            formatter.dateFormat = "EEE MMM d HH:mm:ss Z y"
            timestamp = formatter.date(from: timestampString)
        }
        user = User(dictionary: dictionary["user"] as! NSDictionary)
    }
    
    class func tweetsWithArray( dictionaries: [NSDictionary]) -> [Tweet] {
        var tweets = [Tweet]()
        
        for dictionary in dictionaries {
            let tweet = Tweet( dictionary: dictionary )
            
            tweets.append(tweet)
        }
        
        return tweets
    }
}

extension Date {
    func getElapsedInterval() -> String {
        let dateFormatterPrint = DateFormatter()
        dateFormatterPrint.dateFormat = "MMM dd"
        
        let interval = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: self, to: Date())
        
        if let year = interval.year, year > 0 {
            dateFormatterPrint.dateFormat = "MMM dd, yyyy"
            return dateFormatterPrint.string(from: self)
        } else if let month = interval.month, month > 0 {
            return dateFormatterPrint.string(from: self)
        } else if let day = interval.day, day > 0 {
            return dateFormatterPrint.string(from: self)
            
        } else if let hour = interval.hour, hour > 0 {
            return "\(hour)h"
        } else if let minute = interval.minute, minute > 0 {
            return "\(minute)m"
        } else if let second = interval.second, second > 0 {
            return "\(second)s"
        } else {
            return "now"
        }
    }
    
    func getFormattedTimestamp() -> String {
        let dateFormatterPrint = DateFormatter()
        dateFormatterPrint.dateFormat = "h:mm a - d MMM yyy"
        
        return dateFormatterPrint.string(from: self)
    }
}



