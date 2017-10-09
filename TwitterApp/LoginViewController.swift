//
//  LoginViewController.swift
//  TwitterApp
//
//  Created by John Nguyen on 9/26/17.
//  Copyright © 2017 John Nguyen. All rights reserved.
//

import UIKit
import BDBOAuth1Manager

class LoginViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onLoginButton(_ sender: Any) {
        
        TwitterClient.shared.login(success: {
            print( "I've logged in!" )
            
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            appDelegate.showMain()
            
        }) { (error: Error) in
            print( "Error: \(error.localizedDescription)")
        }
    }
}
