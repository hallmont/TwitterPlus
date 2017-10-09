//
//  MenuViewController.swift
//  HamburgerMenu
//
//  Created by John Nguyen on 10/4/17.
//  Copyright © 2017 John Nguyen. All rights reserved.
//

import UIKit

class MenuViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    @IBOutlet weak var tableView: UITableView!
    
    private var tweetsNavigationController: UIViewController!
    private var profileNavigationController: UIViewController!
    private var mentionsNavigationController: UIViewController!

    var menuItems: [MenuItem] = []
    
    var hamburgerViewController: HamburgerViewController!
    private var profileViewController: TweetsViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)

        tweetsNavigationController = storyboard.instantiateViewController(withIdentifier: "TweetsNavigationController")
        profileNavigationController = storyboard.instantiateViewController(withIdentifier: "TweetsNavigationController")
        mentionsNavigationController = storyboard.instantiateViewController(withIdentifier: "TweetsNavigationController")
        
        let mentionsNC = mentionsNavigationController as! UINavigationController
        let mentionsViewController = mentionsNC.topViewController as! TweetsViewController
        mentionsViewController.title = "Mentions"
        mentionsViewController.controllerType = .mentions
        
        let profileNC = profileNavigationController as! UINavigationController
        profileViewController = profileNC.topViewController as! TweetsViewController
        profileViewController.title = "Profile"
        profileViewController.controllerType = .profile

        
        menuItems.append( MenuItem(title: "Profile", viewController: profileNavigationController))
        menuItems.append( MenuItem(title: "Timeline", viewController: tweetsNavigationController))
        menuItems.append( MenuItem(title: "Mentions", viewController: mentionsNavigationController))
        
        // Do any additional setup after loading the view.
        hamburgerViewController.contentViewController = tweetsNavigationController
    }
    
    func getProfileVC() -> TweetsViewController {
        return profileViewController
        
    }
    
    func getProfileVC2() -> UIViewController {
        return profileNavigationController
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menuItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MenuCell", for: indexPath) as! MenuCell

        cell.menuTitleLabel.text = menuItems[indexPath.row].title
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        hamburgerViewController.contentViewController = menuItems[indexPath.row].viewController
    }
}

class MenuItem {
    var viewController: UIViewController!
    var title: String!
    init( title: String, viewController: UIViewController) {
        self.title = title
        self.viewController = viewController
    }
}
