//
//  TweetsViewController.swift
//  TwitterApp
//
//  Created by John Nguyen on 9/29/17.
//  Copyright © 2017 John Nguyen. All rights reserved.
//

import UIKit

enum ItemType {
    case tweet
    case header
}

enum TweetsControllerType {
    case timeline
    case profile
    case mentions
}

protocol TableItem {
    var type: ItemType { get }
    var rowCount: Int { get }
}

class TweetsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, TweetsCellDelegate {

    @IBOutlet weak var tableView: UITableView!
    var tweets: [Tweet]!
    
    var items = [TableItem]()
    var tweetItem: TweetItem!
    var headerItem: HeaderItem!
    var user: User! = nil
    var screenName = ""
    @IBOutlet var timelineView: UIView!
    var isMoreDataLoading = false
    var loadingMoreView:InfiniteScrollActivityView?
    var controllerType: TweetsControllerType = .timeline
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 100
        tableView.register(TweetsCell.nib, forCellReuseIdentifier: TweetsCell.identifier)

        tweetItem = TweetItem()
        if controllerType == .profile {
            headerItem = HeaderItem()
            items.append(headerItem)
        }
        items.append(tweetItem)
        
        print( "** viewDidLoad - before fetchTweets()" )
        fetchTweets(maxId: nil, success: { (tweets: [Tweet]) in
            self.tweetItem.tweets = tweets
            self.tableView.reloadData()
        }) { (error: Error) in
        }

        // Set up Infinite Scroll loading indicator
        let frame = CGRect(x: 0, y: tableView.contentSize.height, width: tableView.bounds.size.width, height: InfiniteScrollActivityView.defaultHeight)
        loadingMoreView = InfiniteScrollActivityView(frame: frame)
        loadingMoreView!.isHidden = true
        tableView.addSubview(loadingMoreView!)
        
        var insets = tableView.contentInset
        insets.bottom += InfiniteScrollActivityView.defaultHeight
        tableView.contentInset = insets
        
        // Do any additional setup after loading the view.
        // Initialize a UIRefreshControl
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshControlAction(_:)), for: UIControlEvents.valueChanged)
        // add refresh control to table view
        tableView.insertSubview(refreshControl, at: 0)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if user != nil {
            print( "** user=\(user.name) screenName=\(screenName)" )
        }
        print( "** screenName=\(screenName)" )
        print( "** controllerType=\(controllerType)")

//        if screenName != "" {
//            fetchTweets(maxId: nil, success: { (tweets: [Tweet]) in
//                self.tweetItem.tweets = tweets
//                self.tableView.reloadData()
//            }) { (error: Error) in
//            }
//            tableView.reloadData()
//        }
    }
    
    func refreshControlAction( _ refreshControl: UIRefreshControl ) {
        
        fetchTweets(maxId: nil, success: { (tweets: [Tweet]) in
            self.tweetItem.tweets = tweets
            self.tableView.reloadData()
            refreshControl.endRefreshing()
        }) { (error: Error) in
            refreshControl.endRefreshing()
        }
    }
    
    func fetchTweets( maxId: String?, success: @escaping ([Tweet])->() = {_ in }, failure: @escaping (Error)->() = {_ in } )
    {
        switch controllerType {
        case .timeline:
            TwitterClient.shared.fetchHomeTimeline( maxId: maxId, success: { (tweets: [Tweet]) -> () in
                success(tweets)
            }, failure: { (error: Error) -> () in
                print(error.localizedDescription)
                failure(error)
            })
        case .profile:
            if screenName == "" {
                TwitterClient.shared.fetchHomeTimeline( maxId: maxId, success: { (tweets: [Tweet]) -> () in
                    
                    success(tweets)
                    
                }, failure: { (error: Error) -> () in
                    print(error.localizedDescription)
                    failure(error)
                })
            } else {
                TwitterClient.shared.fetchUserTimeline( maxId: maxId, screenName: screenName, success: { (tweets: [Tweet]) -> () in
                    
                    success(tweets)
                    
                }, failure: { (error: Error) -> () in
                    print(error.localizedDescription)
                    failure(error)
                })
            }
        case .mentions:
            TwitterClient.shared.fetchMentionsTimeline( maxId: maxId, success: { (tweets: [Tweet]) -> () in
                success(tweets)
            }, failure: { (error: Error) -> () in
                print(error.localizedDescription)
                failure(error)
            })
        }
    }
    
    // MARK: - TableView
    func numberOfSections(in tableView: UITableView) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return items[section].rowCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = items[indexPath.section]
        
        switch item.type {
        case .header:
            let cell = tableView.dequeueReusableCell(withIdentifier: "HeaderItem", for: indexPath)  as! HeaderCell
            let headerItem = item as! HeaderItem
            
            if user == nil {
                user = User.currentUser
            }
            print( "** self.user=\(self.user)")
            cell.user = self.user
            return cell
            
        case .tweet:
            let cell = tableView.dequeueReusableCell(withIdentifier: TweetsCell.identifier, for: indexPath)  as! TweetsCell
            let tweetItem = item as! TweetItem
            cell.tweet = tweetItem.tweets[indexPath.row]
            cell.delegate = self
            return cell
        }
    }
    
 
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let cell = tableView.cellForRow(at: indexPath)
        self.performSegue(withIdentifier: "DetailsSegue", sender: cell )
    }


    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if( segue.identifier! == "DetailsSegue") {
            let cell = sender as! TweetsCell
            let vc = segue.destination as! TweetDetailsViewController
            vc.cell = cell
        } else if( segue.identifier == "ComposeSegue" ) {
            let navigationController = segue.destination as! UINavigationController
            let vc = navigationController.topViewController as! ComposeTweetViewController
            vc.tweet = nil
            
            vc.completionHandler = { tweet in
                self.tweets.insert(tweet, at: 0)
                self.tableView.reloadData()
            }
        }
    }
    
    func setUser( user: User, screenName: String ) {
        self.user = user
        self.screenName = screenName
    }
    
    func showUserProfile( tweet: Tweet ) {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "TweetsViewController") as! TweetsViewController
        
        vc.setUser( user: tweet.user!, screenName: tweet.user!.screenName! as String )
        print( "** tweet screename=\(tweet.user!.screenName!) screenName=\(self.screenName)")

        vc.controllerType = .profile
        vc.navigationItem.leftBarButtonItem = nil
        self.navigationController?.show(vc, sender: self)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onLogoutButton(_ sender: Any) {
        TwitterClient.shared.logout()
    }
    
    // MARK: - Infinite scrolling
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        if (!isMoreDataLoading) {
            // Calculate the position of one screen length before the bottom of the results
            let scrollViewContentHeight = tableView.contentSize.height
            let scrollOffsetThreshold = scrollViewContentHeight - tableView.bounds.size.height
            
            // When the user has scrolled past the threshold, start requesting
            if(scrollView.contentOffset.y > scrollOffsetThreshold && tableView.isDragging) {
                isMoreDataLoading = true
                
                // Update position of loadingMoreView, and start loading indicator
                let frame = CGRect(x: 0, y: tableView.contentSize.height, width: tableView.bounds.size.width, height: InfiniteScrollActivityView.defaultHeight)
                loadingMoreView?.frame = frame
                loadingMoreView!.startAnimating()
                
                // ... Code to load more results ...
                loadMoreData()
            }
        }
    }
    
    func loadMoreData() {
        
        let maxId: String? = self.tweets.last?.id_str
        
        fetchTweets(maxId: maxId, success: { (tweets: [Tweet]) in
            if tweets.count > 1 {
                for i in 1..<tweets.count {
                    self.tweetItem.tweets.append( tweets[i] )
                }
            }
            self.isMoreDataLoading = false
            self.tableView.reloadData()
            self.loadingMoreView!.stopAnimating()
        }) { (error: Error) in
        }
    }
}

class InfiniteScrollActivityView: UIView {
    var activityIndicatorView: UIActivityIndicatorView = UIActivityIndicatorView()
    static let defaultHeight:CGFloat = 60.0
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupActivityIndicator()
    }
    
    override init(frame aRect: CGRect) {
        super.init(frame: aRect)
        setupActivityIndicator()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        activityIndicatorView.center = CGPoint(x: self.bounds.size.width/2, y: self.bounds.size.height/2)
    }
    
    func setupActivityIndicator() {
        activityIndicatorView.activityIndicatorViewStyle = .gray
        activityIndicatorView.hidesWhenStopped = true
        self.addSubview(activityIndicatorView)
    }
    
    func stopAnimating() {
        self.activityIndicatorView.stopAnimating()
        self.isHidden = true
    }
    
    func startAnimating() {
        self.isHidden = false
        self.activityIndicatorView.startAnimating()
    }
}

// MARK - TableItem
class TweetItem: TableItem {
    var tweets: [Tweet]!
    
    var type: ItemType {
        return .tweet
    }
    
    var rowCount: Int {
        if tweets != nil {
            return tweets.count
        }
        
        return 0
    }
}

class HeaderItem: TableItem {
    var type: ItemType {
        return .header
    }
    
    var rowCount: Int {
        return 1
    }
}

